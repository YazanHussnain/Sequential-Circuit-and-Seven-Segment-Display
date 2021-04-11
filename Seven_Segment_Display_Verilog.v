`timescale 1ns / 1ps // timescale for simulation
module top(clk, reset, num, sel, wr, anode, cathode);
    input clk, wr, reset; //50Mhz clock, Read-Write bit, Reset Bit
    input [2:0] num; // Input number
    input [1:0] sel; // Selection bit to store input number in register
    output wire [3:0] anode; // Anode signal for seven segment
    output wire [6:0] cathode; // Provide low signal to pins of seven segment
    wire refresh_clock; // 100Hz clock from 50MHz
    wire [1:0] counter; // counter from 0 to 3
    wire [2:0] ONE_DIGIT, reg_digit1, reg_digit2, reg_digit3, reg_digit4; // One digit to display
    on seven segment and all other parameter is for connnecting inputs to control digit module
    // Register module use to store input data depending on selection bit when Read-Write bit is ON
    register register_capsule(.input_data(num), .clk(clk), .wr(wr), .sel(sel), .reset(reset),
    .digit1_reg(reg_digit1), .digit2_reg(reg_digit2), .digit3_reg(reg_digit3), .digit4_reg(reg_digit4));
    // Divide 50MHz clock to 100Hz
    clock_divider refreshclock_generator (.clk(clk), .divided_clk(refresh_clock));
    // Count 0 to 3. Control which digit show on which seven segment display
    counter counter_capsule(.refresh_clock(refresh_clock), .wr(wr), .counter(counter));
    // Control anode signal of seven segments
    SSD_anode_control SSD_anode_control_capsule(.counter(counter), .wr(wr), .anode(anode));
    // Take input data and provide a single digit to display on seven segment
    SSD_Control_digit SSD_Control_digit_capsule(.digit1(reg_digit1), .digit2(reg_digit2),
    .digit3(reg_digit3), .digit4(reg_digit4), .wr(wr), .counter(counter), .ONE_DIGIT(ONE_DIGIT));
    // Convert the single digit to cathode signal for seven segment display
    SSD_digit_to_cathode SSD_digit_to_cathode_capsule(.digit(ONE_DIGIT), .wr(wr),.cathode(cathode));
endmodule

module register(input_data, clk, wr, sel, reset, digit1_reg, digit2_reg, digit3_reg, digit4_reg);
    input [2:0] input_data;
    input clk, reset, wr;
    input [1:0] sel;
    output reg [2:0] digit1_reg, digit2_reg, digit3_reg, digit4_reg;
    always@(posedge clk) begin
        if(reset)begin
        digit1_reg <= 0;
        digit2_reg <= 0;
        digit3_reg <= 0; //This Register module store four data inputs
        // depending on selection bit
        digit4_reg <= 0;
        end else if(wr) begin
            if(sel == 2'b00) begin
                digit1_reg <= input_data;
            end else if(sel == 2'b01) begin
                digit2_reg <= input_data;
            end else if(sel == 2'b10) begin
                digit3_reg <= input_data;
            end else if(sel == 2'b11) begin
                digit4_reg <= input_data;
            end
        end
    end
endmodule

module SSD_digit_to_cathode(digit, wr, cathode);
    input [2:0] digit;
    input wr;
    output reg [6:0] cathode = 0;
    always@(digit or wr)begin
        if(~wr) begin
            case(digit)
                4'd0:
                    cathode = 8'b0000001; //Digit 0 configuration for seven segment display
                4'd1:
                    cathode = 8'b1001111; //Digit 1 configuration for seven segment display
                4'd2:
                    cathode = 8'b0010010; //Digit 2 configuration for seven segment display
                4'd3:
                    cathode = 8'b0000110; //Digit 3 configuration for seven segment display
                4'd4:
                    cathode = 8'b1001100; //Digit 4 configuration for seven segment display
                4'd5:
                    cathode = 8'b0100100; //Digit 5 configuration for seven segment display
                4'd6:
                    cathode = 8'b0100000; //Digit 6 configuration for seven segment display
                4'd7:
                    cathode = 8'b0001111; //Digit 7 configuration for seven segment display
                default:
                    cathode = 8'b0000001; //Default configuration for seven segment display
            endcase
        end
    end
endmodule

module SSD_Control_digit(digit1, digit2, digit3, digit4, wr, counter, ONE_DIGIT);
    input [2:0] digit1, digit2, digit3, digit4;
    input [1:0] counter;
    input wr;
    output reg [2:0] ONE_DIGIT = 0;
    always@(counter or wr) begin
        if(~wr) begin
            case(counter)
                2'd0:
                    ONE_DIGIT = digit1; // Left most digit
                2'd1:
                    ONE_DIGIT = digit2;
                2'd2:
                    ONE_DIGIT = digit3;
                2'd3:
                    ONE_DIGIT = digit4; // Right most digit
            endcase
        end
    end
endmodule

module SSD_anode_control(counter, wr, anode);
    input [1:0] counter;
    output reg [3:0] anode = 0;
    input wr;
    always@(counter or wr) begin
        if(~wr)begin
            case(counter)
                2'b00:
                    anode = 4'b0111; // Left most seven segment display
                2'b01:
                    anode = 4'b1011;
                2'b10:
                    anode = 4'b1101;
                2'b11:
                    anode = 4'b1110; // right most seven segment display
            endcase
        end
    end
endmodule

module counter(refresh_clock, wr, counter);
    input refresh_clock, wr;
    output reg [1:0] counter = 0;
    always@(posedge refresh_clock or wr) //Count 0 to 3
        if(~wr)
            counter <= counter + 1;
endmodule

module clock_divider(clk, divided_clk);
    input wire clk;
    output reg divided_clk = 0; //Divide 50MHz clock frequency to 100Hz clock frequency
    integer counter_value = 0;
    always@(posedge clk) begin
        //formula for the value by which frequency should be divided_clk
        // Divider = ( 50MHz / (2 * Desired Frequency) ) - 1
        if(counter_value == 249999) begin
            counter_value <= 0;
            divided_clk <= ~divided_clk;
        end else begin
            counter_value <= counter_value + 1;
            divided_clk <= divided_clk;
        end
    end
endmodule
