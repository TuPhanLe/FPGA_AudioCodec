`timescale 1ns / 1ps
module filter (input sample_clock, input reset, input [15:0] input_sample1, output [15:0] output_sample1);

parameter N = 45; //Specify the number of taps

reg  [15:0] delayholder[N-1:0];
wire signed[31:0] summation[N-1:0];
wire signed[15:0] finsummations[N-1:0];
wire signed[15:0] finsummation;

//Specifying our coefficients
reg signed[15:0] coeffs[N-1:0] = '{
        16'h0007, 16'h0015, 16'h002B, 16'h004C, 16'h007E,
        16'h00C5, 16'h0127, 16'h01A6, 16'h0243, 16'h02FF,
        16'h03D9, 16'h04CC, 16'h05D4, 16'h06EA, 16'h0807,
        16'h0920, 16'h0A2E, 16'h0B25, 16'h0BFF, 16'h0CB1,
        16'h0D35, 16'h0D87, 16'h0DA3, 16'h0D87, 16'h0D35,
        16'h0CB1, 16'h0BFF, 16'h0B25, 16'h0A2E, 16'h0920,
        16'h0807, 16'h06EA, 16'h05D4, 16'h04CC, 16'h03D9,
        16'h02FF, 16'h0243, 16'h01A6, 16'h0127, 16'h00C5,
        16'h007E, 16'h004C, 16'h002B, 16'h0015, 16'h0007
 };

integer x;
integer z;


generate
genvar i;
for (i=0; i<N; i=i+1)
    begin: mult1
        multiplier mult1(.dataa(coeffs[i]), .datab(delayholder[i]),.result(summation[i]));
    end
endgenerate

always @(posedge sample_clock or posedge reset)
begin
if(reset)
        begin
		  output_sample1 = 0;
		  for (z=0; z<N; z=z+1)
		  begin
		  delayholder[z] = 0;
		  end
end

else
        begin  
		  for (z=N-1; z>0; z=z-1)
		  begin
		  delayholder[z] = delayholder[z-1];
		  end
		  delayholder[0] = input_sample1;
end

	     for (z=0; z<N; z=z+1)
	     begin
        finsummations[z] = {summation[z][31], summation[z][29:15]};  //summation[z] >>> 15;
        end
	 
		  finsummation = 0;
	     for (z=0; z<N; z=z+1)
		  begin
		  finsummation = finsummation + finsummations[z];
		  end

		  output_sample1 = finsummation;
end

endmodule
