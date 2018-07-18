
//�Ⱦ��Ȳ�Ƶԭ����룬D������
module mesureFreq (
  input       fx,
  input       fbase,
  input       fgate,
  output reg[31:0]  fxCnt,
  output reg[31:0]  fbaseCnt
  );
  
reg   startCnt;//��ʼ������־λ
reg[31:0] fxCntTemp,fbaseCntTemp;

//��֪��Ƶ�ʼ���
always @ (posedge fbase) 
begin
  if(startCnt)
    fbaseCntTemp <= fbaseCntTemp + 1;
  else
    fbaseCntTemp <= 32'h00000000;
end

//�����Ƶ�ʼ���
always @ (posedge fx)   
begin
  if(startCnt)
    fxCntTemp <= fxCntTemp + 1;
  else
    fxCntTemp <= 32'h00000000;
end

//synchronous fgateͬ��բ��
always @ (posedge fx) 
begin
  if(fgate) 
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

endmodule