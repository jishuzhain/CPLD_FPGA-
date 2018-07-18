
module frequent_div(sysclk, clk_25mhz, clk_cnthz);
input sysclk;
output reg clk_25mhz, clk_cnthz;
reg[29:0] counter3;
//0.5Hz分频

always @(posedge sysclk)//or negedge reset
begin
		clk_25mhz <= ~clk_25mhz; 
end

always @(posedge clk_25mhz)
begin
	if(counter3 == 24999999)  //100Hz 为 4
		begin 
		clk_cnthz = ~clk_cnthz;  //0.5Hz输出作为闸门信号
		counter3 = 0;
		end
	else
		begin
		counter3 = counter3 + 1;
		end
end

/*
always @(posedge sysclk)//or negedge reset
begin
		if(counter4 == 24999)
			begin
			counter4 <= 0;
			clk_1khz <= ~clk_1khz;
			end
		else
			begin
			counter4 <= counter4 + 1;
			end 
end

always @(posedge clk_1khz)
begin
	if(counter3 == 999)  //100Hz 为 4
		begin 
		clk_cnthz = ~clk_cnthz;
		counter3 = 0;
		end
	else
		begin
		counter3 = counter3 + 1;
		end
end
*/
endmodule 