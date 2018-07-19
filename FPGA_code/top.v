module top 
(
  input     fx,
  input     fxb,
  input     CLK,		//CLK
  input		RSTn,
  input     start_sig,
  output LED,
  output wire LED1,
  output TX_Pin_Out
 );
 
 
	wire [31:0]fxCnt;
	wire [31:0]fbaseCnt;
	//改
	wire [31:0]dutyCnt;
	wire [31:0]delayCnt;
	
	wire measure_done;
	wire PLLCLK;
	
assign 	LED1=fdelay;
reg fdelay;//用于检测时间间隔
	
	
		//开始信号下降沿
	wire start_do;	
	reg H2L_F3 ;
	reg H2L_F4 ;
	 
	 always @ ( posedge CLK)
	    begin
			H2L_F3 <= start_sig;
			H2L_F4 <= H2L_F3;
		end
				
	/***************************************/
	
	assign start_do = H2L_F4 & !H2L_F3;
	
	/***************************************/
	
mesureFreq 	U1
(
	  .fx(fx),
	  .fbase(PLLCLK),		//CLK
	  //谢
	  .fdelay(fdelay),
	  .start_sig(start_do),
	  .fxCnt(fxCnt),
	  .fbaseCnt(fbaseCnt),
	  .dutyCnt(dutyCnt),
	  //谢
	  .delayCnt(delayCnt),
	  .done_sig(measure_done),
	  .LED(LED)
	  
	  
);


uartsent	U2
(
	.CLK(PLLCLK),
	.RSTn(RSTn),
	.Do_sig(measure_done),
	.fxCnt(fxCnt),
	.fbaseCnt(fbaseCnt),
	//改
	.dutyCnt(dutyCnt),
	.delayCnt(delayCnt),
	
	.TX_Pin_Out(TX_Pin_Out)
);

PLL U3
(
	.inclk0(CLK),
	.c0(PLLCLK)
);

////捕获A上升沿
///*
//reg fx1;
//always @ ( posedge  fx )
//	begin
//		fx1<=fx;
//	end
////捕获B上升沿
//reg fxb1;
//always @ ( posedge  fxb )
//	begin
//		fxb1<=fxb;
//	end

//检测A,边沿
	reg L2H_F1;
	reg L2H_F2;
	wire doneA_sig;
	 
	 always @ ( posedge CLK)
	    begin
			L2H_F1 <= fx;
			L2H_F2 <= L2H_F1;
		end
				
	/***************************************/
	
	assign doneA_sig = !L2H_F2 & L2H_F1;
	
	/***************************************/


	
//检测B,边沿
	reg L2H_F3;
	reg L2H_F4;
	wire doneB_sig; 
	 
	 always @ ( posedge CLK)
	    begin
			L2H_F3 <= fxb;
			L2H_F4 <= L2H_F3;
		end
				
	/***************************************/
	
	assign doneB_sig = !L2H_F4 & L2H_F3;
	
	/***************************************/





always @ ( posedge  PLLCLK )
	if(doneA_sig )
			fdelay<=1'b1;
	else if(doneB_sig )
			fdelay<=1'b0;
			
		
	
//测量时间间隔
//always @ ( posedge PLLCLK )
//	begin
//		if( fx1==0&&fx==1 )//A路上升沿启动
//			begin
//					fdelay<=1'b1;
//			end
//		else if( fxb1==0&&fxb==1 )//B路上升沿关闭
//			begin
//					fdelay<=1'b0;
//			end
//	end	




	
endmodule
