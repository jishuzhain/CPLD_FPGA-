
//等精度测频原理代码，D触发器
module mesureFreq (
  input       fx,
  input       fbase,
  input       fgate,
  output reg[31:0]  fxCnt,
  output reg[31:0]  fbaseCnt
  );
  
reg   startCnt;//开始计数标志位
reg[31:0] fxCntTemp,fbaseCntTemp;

//已知的频率计数
always @ (posedge fbase) 
begin
  if(startCnt)
    fbaseCntTemp <= fbaseCntTemp + 1;
  else
    fbaseCntTemp <= 32'h00000000;
end

//被测的频率计数
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
  if(fgate) 
    startCnt <= 1'b1;
  else
    startCnt <= 1'b0;
end

//output电平变化的时候输出锁存
always @ (negedge startCnt) 
begin
  fxCnt    <= fxCntTemp;
  fbaseCnt <= fbaseCntTemp;
end

endmodule