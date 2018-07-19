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
	//��
	wire [31:0]dutyCnt;
	wire [31:0]delayCnt;
	
	wire measure_done;
	wire PLLCLK;
	
assign 	LED1=fdelay;
reg fdelay;//���ڼ��ʱ����
	
	
		//��ʼ�ź��½���
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
	  //л
	  .fdelay(fdelay),
	  .start_sig(start_do),
	  .fxCnt(fxCnt),
	  .fbaseCnt(fbaseCnt),
	  .dutyCnt(dutyCnt),
	  //л
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
	//��
	.dutyCnt(dutyCnt),
	.delayCnt(delayCnt),
	
	.TX_Pin_Out(TX_Pin_Out)
);

PLL U3
(
	.inclk0(CLK),
	.c0(PLLCLK)
);

////����A������
///*
//reg fx1;
//always @ ( posedge  fx )
//	begin
//		fx1<=fx;
//	end
////����B������
//reg fxb1;
//always @ ( posedge  fxb )
//	begin
//		fxb1<=fxb;
//	end

//���A,����
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


	
//���B,����
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
			
		
	
//����ʱ����
//always @ ( posedge PLLCLK )
//	begin
//		if( fx1==0&&fx==1 )//A·����������
//			begin
//					fdelay<=1'b1;
//			end
//		else if( fxb1==0&&fxb==1 )//B·�����عر�
//			begin
//					fdelay<=1'b0;
//			end
//	end	




	
endmodule
