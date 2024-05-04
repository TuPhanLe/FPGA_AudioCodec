
module parallel_to_serial 
( 		bclk, 
	 lrclk, 
	 reset_n, 
	 in_data, 
	  data
);


	input bclk;
	input lrclk; 
	input reset_n; 
	input in_data; 
	output reg [15:0] data;
reg [3:0] bit_counter;
reg [15:0] data_buffer;		// Buffer the input data, because it might change
reg lrclk_d1;
wire start;
wire new_data;

	assign new_data = ~lrclk & lrclk_d1; // The transfer should start 1 bclk cycle after the negative edge on lrclk
//	assign start = new_data;
	assign start = lrclk ^ lrclk_d1;

	always @(negedge bclk or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			bit_counter <= 4'hf;
		else
			if (start || (bit_counter != 4'hf))
				bit_counter <= bit_counter - 1'b1;
	end

	always @(negedge bclk or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			data_buffer <= 16'h0000;
		else if (new_data)
				data_buffer <= in_data;
	end

	always @(negedge bclk)
	begin
		lrclk_d1 <= lrclk;
	end

	always @(negedge bclk or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			data <= 1'b0;
		else
		begin
			if (bit_counter != 4'hf || ~new_data)
				data <= data_buffer[bit_counter];
			else
				data <= 1'b0;
		end
	end


endmodule