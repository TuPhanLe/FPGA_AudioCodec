
module Wrapper (
	AUD_ADCDAT,
	AUD_BCLK,
	AUD_ADCLRCK,
   AUD_DACLRCK,
   AUD_DACDAT
	
	);
input AUD_ADCDAT;
input AUD_BCLK;
input AUD_ADCLRCK;
input AUD_DACLRCK;
output AUD_DACDAT;

endmodule	

// Signed adder

module signed_adder
#(parameter WIDTH=16)
(
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	input cin,
	output [WIDTH:0] result
);

	assign result = dataa + datab + cin;

endmodule

// Quartus Prime Verilog Template
// Signed multiply

module signed_multiply
#(parameter WIDTH=16)
(
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	output [2*WIDTH-1:0] dataout
);

	 assign dataout = dataa * datab;

endmodule


module register
#(parameter WIDTH=16)
(
	dataa,
	clk,
	reset_n,
	dataout
);

	input dataa;
	input clk;
	input reset_n;
	output [15:0] dataout;
always@ (posedge clk)
	if(reset_n == 1'b0)
		dataout <= 0;
			
	else				
		dataout <= dataa;

endmodule


module serial_fir_filter
(
	clk, 
	reset_n,
	d,
	q
);
input clk;
input reset_n;
input  signed[15:0] d;
output  signed[15:0] q;
 reg[WIDTH-1:0] delay[WIDTH-1:0];
 reg[2*WIDTH-1:0] prod;
 reg[WIDTH:0] sum;
 reg [WIDTH-1:0] lut_rom[0:WIDTH-1];			  
 reg[WIDTH-1:0] coefficient;
			  
assign delay[0] = d;
integer i = 0;
			  
initial
	begin: lut_initalization
		$readmemb("D:/LEARN/BTL_FPGA/rom-data.txt", lut_rom);
	end
					
genvar n;
generate
	for(n = 1; n < WIDTH; n = n + 1)
		begin:generator
			register reg_inst0(.dataa(delay[n-1]),
									 .clk(clk),
									 .reset_n(reset_n),
									 .dataout(delay[n]));
		end
endgenerate
			 
always@(posedge clk)
	for(i = 0; i <= WIDTH - 1; i = i+ 1)
		begin: generate_address
			coefficient  <= lut_rom[i];
		end
					
signed_multiply inst(.dataa(delay[WIDTH-1]),
				         .datab(coefficient),
							.dataout(prod));
				
signed_adder adder_fir(.dataa($signed(prod[2 * WIDTH-2:WIDTH-1])),
							  .datab(q),
							  .cin(0),
							  .result(sum));

register reg_inst1(.dataa($signed(sum[WIDTH:1])),
						 .clk(clk),
						 .reset_n(reset_n),
						 .dataout(q));

endmodule