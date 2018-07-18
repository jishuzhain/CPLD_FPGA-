
//50hZÊä³ö
module fengmingqi(clk, rst_n, fm);
 input clk;
 input rst_n;
 output fm;
 reg fm;
 reg[19:0] cnt;
 always @(posedge clk or negedge rst_n)
 begin
	if(! rst_n)
		cnt <= 20'd0;
	else if(cnt < 20'd999_999)
		cnt <= cnt + 1'b1;
	else
		cnt <= 20'd0;
 end
 
 always @(posedge clk or negedge rst_n)
 begin
	if(! rst_n)
		fm <= 1'b0;
	else if(cnt < 20'd500_000)
		fm <= 1'b1;
	else
		fm <= 1'b0;
 end
 
 endmodule 


/********************************************
//Êä³ö1khz
module fengmingqi(clk, rst_n, fm);
 input clk;
 input rst_n;
 output fm;
 reg fm;
 reg[19:0] cnt;
 always @(posedge clk or negedge rst_n)
 begin
	if(! rst_n)
		cnt <= 20'd0;
	else if(cnt < 20'd49_999)
		cnt <= cnt + 1'b1;
	else
		cnt <= 20'd0;
 end
 
 always @(posedge clk or negedge rst_n)
 begin
	if(! rst_n)
		fm <= 1'b0;
	else if(cnt < 20'd25_000)
		fm <= 1'b1;
	else
		fm <= 1'b0;
 end
 
 endmodule 
******************************************/

/*****************************************************
module fengmingqi(clk, rst_n, fm);
	input clk;
	input rst_n;
	output fm;
	reg fm;
	reg[19:0] cnt;
always @(posedge clk or negedge rst_n)
begin
	if(! rst_n)
		cnt <= 20'd0;
	else if(cnt == 20'd24_999)
		fm = ~fm;
	else
		cnt <= cnt + 1'b1;
		
end
endmodule 
*********************************************************/