`timescale 1 ns/10 ps
module testbench_SSD();
    reg clk, reset, wr;
    reg [2:0] num;
    reg [1:0] sel;
    wire [3:0] anode;
    wire [6:0] cathode;
    top UUT(clk, reset, num, sel, wr, anode, cathode);
    parameter T = 20; // clk period
    // Clock generator
    initial begin
        clk = 0;
        forever #(T/2) clk=~clk;
    end
    // Test vector generator
    initial begin
        reset_dut;
        #100 num = 4; sel = 2'b00; wr = 1;
        #100 num = 5; sel = 2'b01; wr = 1;
        #100 num = 6; sel = 2'b10; wr = 1;
        #100 num = 7; sel = 2'b11; wr = 1;
        #25000000 wr = 0;
        #62500000 $stop;
    end
    task reset_dut;
        begin
            reset <= 1;
            #(T/4); reset <= 0;
        end
    endtask
endmodule
