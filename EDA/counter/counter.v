//频率计分频模块
module counter(reset, clk, clk_1hz, clk_10hz, clk_100hz, clk_1khz);
input reset, clk;
output reg clk_1hz, clk_10hz, clk_100hz, clk_1khz;
reg[29:0] counter1, counter2, counter3, counter4;
always @(posedge clk or negedge reset)
begin
	if(!reset)//复位清零
		begin
		counter1 <= 0;
		counter2 <= 0;
		counter3 <= 0;
		counter4 <= 0;
		clk_1hz <= 0;
		clk_10hz <= 0;
		clk_100hz <= 0;
		clk_1khz <= 0;
		end
	else//计数分频 50M晶振下（实验板）
		//分频取值为一半，偶分频 N/2-1
		begin
		if(counter1 == 24999999)
			begin
			counter1 <= 0;
			clk_1hz <= ~clk_1hz;
			end
		else
			begin
			counter1 <= counter1 + 1;
			end
		if(counter2 == 249999)
			begin
			counter2 <= 0;
			clk_10hz <= ~clk_10hz;
			end
		else
			begin
			counter2 <= counter2 + 1;
			end
		if(counter3 == 24999)
			begin
			counter3 <= 0;
			clk_100hz <= ~clk_100hz;
			end
		else
			begin
			counter3 <= counter3 + 1;
			end
		if(counter4 == 2499)
			begin
			counter4 <= 0;
			clk_1khz <= ~clk_1khz;
			end
		else
			begin
			counter4 <= counter4 + 1;
			end
		end
end

endmodule