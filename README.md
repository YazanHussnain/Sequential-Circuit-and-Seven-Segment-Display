# Sequential Circuits and Seven Segment Display
<!-- wp:paragraph -->
<p><strong>Top Module</strong></p>
<!-- /wp:paragraph -->

<!-- wp:image {"align":"center","id":180,"width":448,"height":290,"sizeSlug":"large","linkDestination":"none"} -->
<div class="wp-block-image"><figure class="aligncenter size-large is-resized"><img src="https://electronicinstruction.files.wordpress.com/2021/04/seven-segment-display.png?w=607" alt="" class="wp-image-180" width="448" height="290"/></figure></div>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>There are six module used that lead us to our desired output. First Digit Register, This register store input date on memory locations depending on the selection bit and read-write bit. If sel is 00 and read-write bit is 1 than date write on the memory.<br>Second Clock Divider, this divides the 50MHz clock frequency to 100Hz clock frequency<br>because at this high frequency(50MHz) Seven segment may not work properly. 100Hz is good because minimum frequency for human not to detect for four segments is complete in this frequency.<br>Third Counter, this counter decides that which seven segments is turned on for which digit.<br>Means, for first digit Left most seven segment is on and for last digit right most seven segment display is on.<br>Fourth Anode Control, this controls the anode signal for seven segment display depending on counter.<br>Fifth Control Digit, that control the digit to appear on which seven segment display.<br>Sixth Digit to Cathode, that converts the Digit to seven segment display configurations.</p>
<!-- /wp:paragraph -->
