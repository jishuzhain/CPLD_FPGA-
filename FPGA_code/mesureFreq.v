module mesureFreq (
  input       fx,
  input       fbase,		//CLK
  //л
  input       fdelay,
  input       start_sig,
  output reg[31:0]  fxCnt,
  output reg[31:0]  fbaseCnt,
  output  done_sig,
  
  //�޸�
  output reg[31:0] dutyCnt,
  //л
  output reg[31:0]  delayCnt,
  
  output LED
  );
	reg done = 1'b0;
	reg   startCnt;
	reg[31:0] fxCntTemp,fbaseCntTemp;
	
	//�޸�
	reg[31:0] dutycntTemp;
	reg[31:0] delaycntTemp;

	always @ (posedge fbase)  begin
	  if(startCnt)
		fbaseCntTemp <= fbaseCntTemp + 1;
	  else
		fbaseCntTemp <= 32'h00000000;
	end

	always @ (posedge fx)   begin
	  if(startCnt)
		fxCntTemp <= fxCntTemp + 1;
	  else
		fxCntTemp <= 32'h00000000;
	end
	
	//��ռ�ձȼ���
	always @ (posedge fbase)   begin
	  if(rfgate==1&&startCnt==0)
			dutycntTemp <=0;
	  else if(startCnt&&fx)
		dutycntTemp <= dutycntTemp + 1;
	  else 
		dutycntTemp <= dutycntTemp;
	end
	
	//л
	
	reg startit;
	//����ʱ����
	always @ (posedge fbase)   begin
	  if(rfgate==1 && startit==0)
			delaycntTemp <=0;
	  else if(startit && fdelay)
		delaycntTemp <= delaycntTemp + 1;
	  else 
		delaycntTemp <= delaycntTemp;
	end
	
  //output reg[31:0]  delayCnt,
  
	//synchronous sig A
	always @ (posedge fdelay) begin
	  if(rfgate) 
		startit <= 1'b1;
	  else
		startit <= 1'b0;
	end	
	
	//synchronous fgate
	always @ (posedge fx) begin
	  if(rfgate) 
		startCnt <= 1'b1;
	  else
		startCnt <= 1'b0;
	end

	//output
	always @ (negedge startCnt) begin
	  fxCnt    <= fxCntTemp;
	  fbaseCnt <= fbaseCntTemp;
	  //�޸�
	  dutyCnt  <= dutycntTemp;
	  delayCnt  <= delaycntTemp;
	end

	//done_sig
	reg H2L_F1 = 1'b0;
	reg H2L_F2 = 1'b0;
	 
	 always @ ( negedge fbase)
	    begin
			H2L_F1 <= startCnt;
			H2L_F2 <= H2L_F1;
		end
				
	/***************************************/
	
	assign done_sig = H2L_F2 & !H2L_F1;
	
	/***************************************/
	
	
	
	//gate produce
	
	parameter T1S = 32'd199_999_999;	//200M,1S
	
	/***************************/
	
	reg [31:0]Count1 = 32'd0;
	reg rfgate = 1'b0;
	/*************闸门产生**************/
	
		
	always @(posedge fbase )
		if(Count1 == T1S)
			begin
				Count1 <= 32'd0;  rfgate <= 1'b0;
			end
		else if(rfgate == 1)
			Count1<=Count1+1'b1;
		else if(start_sig)
			rfgate <= 1'b1;
			

//				reg [31:0]Count1 = 32'd0;
//	reg rfgate = 1'b0;
//	/*************闸门产生**************/
//	
//		
//	always @(posedge fbase )
//		if(Count1 == T1S)
//			begin
//				Count1 <= 32'd0;  rfgate <= 1'b0;
//			end
//		else if(rfgate == 1)
//			Count1<=Count1+1'b1;
//		else if(start_sig)
//			rfgate <= 1'b1;
			
	/***********触发脉冲检�**************/
	assign LED = rfgate;

	
endmodule