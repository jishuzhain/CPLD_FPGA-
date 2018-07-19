module uartsent
(
	input CLK,
	input RSTn,
	
	input Do_sig,
	input[31:0]  fxCnt,
	input[31:0]  fbaseCnt,
	//¸Ä
	input[31:0]  dutyCnt,
	input[31:0]  delayCnt,
	
	output TX_Pin_Out
);

	wire isDone;

	tx_module U0
	(
		.CLK(CLK), 
		.RSTn(RSTn),
		.TX_Data(data), 
		.TX_En_Sig(rEN),
		.TX_Done_Sig(isDone), 
		.TX_Pin_Out(TX_Pin_Out)
	);
	//¸Ä
	reg [7:0]Data[15:0];
	reg [5:0]i = 6'd0;
	
	reg rEN=1'b0;
	reg [7:0]data;
	
	always@(posedge CLK or posedge Do_sig)			//ï¿½ï¿½Ê¼ï¿½ÅºÅºï¿½ï¿½ï¿½Öµ
		if(Do_sig)
			begin
			//¸Ä
				Data[15] <=dutyCnt[31:24];
				Data[14] <=dutyCnt[23:16];
				Data[13] <=dutyCnt[15:8]; 
				Data[12] <=dutyCnt[7:0];  
				Data[11] <=delayCnt[31:24];   
				Data[10] <=delayCnt[23:16];   
				Data[9] <=delayCnt[15:8];    
				Data[8] <=delayCnt[7:0]; 
				
				Data[7] <=fxCnt[31:24];
				Data[6] <=fxCnt[23:16];
				Data[5] <=fxCnt[15:8]; 
				Data[4] <=fxCnt[7:0];  
				Data[3] <=fbaseCnt[31:24];   
				Data[2] <=fbaseCnt[23:16];   
				Data[1] <=fbaseCnt[15:8];    
				Data[0] <=fbaseCnt[7:0]; 
				i <= 1'b1;				//ï¿½ï¿½Ê¼ï¿½ï¿½ï¿½ï¿½
			end
		else 
			begin
				if(rEN == 1'b0 && i>= 1'b1)
					begin
						case(i)
						//¸Ä
						6'd1 : begin data <= Data[15]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd2 : begin data <= Data[14]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd3 : begin data <= Data[13]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd4 : begin data <= Data[12]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd5 : begin data <= Data[11]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd6 : begin data <= Data[10]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd7 : begin data <= Data[9]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd8 : begin data <= Data[8]; rEN <= 1'b1;  i <= i +1'b1; end
						
						6'd9 : begin data <= Data[7]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd10 : begin data <= Data[6]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd11 : begin data <= Data[5]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd12 : begin data <= Data[4]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd13 : begin data <= Data[3]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd14 : begin data <= Data[2]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd15 : begin data <= Data[1]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd16 : begin data <= Data[0]; rEN <= 1'b1;  i <= i +1'b1; end
						6'd17 : begin data <= 8'hff  ; rEN <= 1'b1;  i <= i +1'b1; end
						//sent mode code,equal test freq
						6'd18: begin data <= 8'h0d  ; rEN <= 1'b1;  i <= i +1'b1; end
						6'd19: begin data <= 8'h0a  ; rEN <= 1'b1;  i <= i +1'b1; end
						6'd20: i <= 1'b0;
						endcase

					end
				if(isDone == 1'b1)		//ï¿½Õµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Åºï¿½ï¿½ï¿½ï¿½Ê¹ï¿½Ü¶Ë£ï¿½ï¿½É·ï¿½ï¿½ï¿
					begin
						rEN <=1'b0;
					end	

			end
						
						
						
						
						
						
						
						
endmodule
	