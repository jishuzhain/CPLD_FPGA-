module jicunqi(clk, din, dout);
	input clk;
	input din;
	output dout;
	reg dout;
	
	always @(posedge clk )
	begin
		dout <= din;
	end
endmodule 