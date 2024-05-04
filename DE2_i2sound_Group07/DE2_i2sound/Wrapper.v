module Wrapper (
input sample_clock,  
input reset, 
//input [1:0] selector, 
input [15:0] input_sample, 
output reg [15:0] output_sample
);
	
	wire [15:0] myecho;
	wire [15:0] myfilter;
//	reg  [1:0] switches;
	
//	echo_machine param (.sample_clock(sample_clock), .input_sample(input_sample), .output_sample(myecho));
	filter param2 (.sample_clock(sample_clock), .reset(reset), .input_sample1(input_sample), .output_sample1(myfilter));
	
always @(posedge sample_clock)
begin
//	switches = selector;
//	if (switches == 2'b00) output_sample = input_sample;
//		else if (switches == 2'b01) output_sample = myfilter;
//		else if (switches == 2'b10) output_sample = myecho;
	output_sample = myfilter;
end
endmodule
