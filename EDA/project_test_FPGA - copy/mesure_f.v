//�ź��������Ÿ�Ϊ40��ԭ����100��
module mesure_f(sysclk, fx,  
				clk_25mhz, 
				clk_cnthz, sel0, 
				sel1, sel2, data_out);
input 	sysclk;
input   fx;//待测频率输入
input sel0, sel1, sel2;  //单片�个选择�
output[7:0] data_out; //数据输出缓冲寄存�
reg[7:0] data_out;
output reg clk_25mhz, clk_cnthz; //0.5Hz作为闸门和中断信�
reg[29:0] counter3;
reg[31:0]  fxCnt;   //�������ֵ 
reg[31:0]  fbaseCnt;  //�������ֵ 
reg   startCnt;   //开始计数标志位
reg[31:0] fxCntTemp, fbaseCntTemp;  //待测频率计数�

//PLLʹ��-------------------------------------------------------------
PLL_test	PLL_test_inst (
//	.areset ( areset_sig ),
	.inclk0 ( sysclk ),
	.c0 ( sysclk_100m ),
//	.locked ( locked_sig )
	);
//---------------------------------------------------------------------

//---------------------------------------分频模块-------------------------------------
//0.5Hz分频
always @(posedge sysclk)//or negedge reset
begin
		clk_25mhz <= ~clk_25mhz; 
end

always @(posedge clk_25mhz)
begin
	if(counter3 == 24999999)  //100Hz �4
		begin 
		clk_cnthz = ~clk_cnthz;  //0.5Hz输出作为闸门信号
		counter3 = 0;
		end
	else
		begin
		counter3 = counter3 + 1;
		end
end
//--------------------------------------------------------------------------------

//----------------------------------------等精度测频模�---------------------------------
//��֪��Ƶ�ʼ���
always @ (posedge sysclk_100m)  
begin
  if(startCnt)
    fbaseCntTemp <= fbaseCntTemp + 1;
  else
    fbaseCntTemp <= 32'h00000000;
end

//被测的频率计�
always @ (posedge fx)   
begin
  if(startCnt)
    fxCntTemp <= fxCntTemp + 1;
  else
    fxCntTemp <= 32'h00000000;
end

//synchronous fgate同步闸门
always @ (posedge fx) 
begin
  if(clk_cnthz) 
    startCnt <= 1'b1;
  else
    startCnt <= 1'b0;
end

//output��ƽ�仯��ʱ���������
always @ (negedge startCnt) 
begin
  fxCnt    <= fxCntTemp;
  fbaseCnt <= fbaseCntTemp;
end
//---------------------------------------------------------------------------------

//----------------------------------通信模块---------------------------------------
always @(sel0 or sel1 or sel2 or fxCnt or fbaseCnt)
begin//困难，现在只输出一个计数值，多想�
	if(sel0 == 1'b0)
		if(sel1 == 1'b0)
			case(sel2)
			1'b0: data_out[7:0] = fxCnt[7:0]; //最��
			1'b1: data_out[7:0] = fxCnt[15:8];
			default: data_out[7:0] = 8'bx; //输出无关�
			endcase
		else
			case(sel2)
			1'b0: data_out[7:0] = fxCnt[23:16]; //8�
			1'b1: data_out[7:0] = fxCnt[31:24];
			default: data_out[7:0] = 8'bx; //输出无关�
			endcase
	else
		if(sel1 == 1'b0)
			case(sel2)
			1'b0: data_out[7:0] = fbaseCnt[7:0]; //最��
			1'b1: data_out[7:0] = fbaseCnt[15:8];
			default: data_out[7:0] = 8'bx; //输出无关�
			endcase
		else
			case(sel2)
			1'b0: data_out[7:0] = fbaseCnt[23:16]; //8�
			1'b1: data_out[7:0] = fbaseCnt[31:24];
			default: data_out[7:0] = 8'bx; //输出无关�
			endcase
	
end	

//---------------------------------------------------------------------------------------
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
	if(counter3 == 999)  //100Hz �4
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