//通信模块
module communication_mcu(data_out, data_in0, data_in1, sel0, sel1, sel2);
input sel0, sel1, sel2;  //单片机3个选择位
input[31:0] data_in0, data_in1; //计数完毕后的两个值输入
output[7:0] data_out; //数据输出缓冲寄存器
reg[7:0] data_out;
always @(sel0 or sel1 or sel2 or data_in0 or data_in1)
begin//困难，现在只输出一个计数值，多想想
	if(sel0 == 1'b0)
		if(sel1 == 1'b0)
			case(sel2)
			1'b0: data_out[7:0] = data_in0[7:0]; //最低8位
			1'b1: data_out[7:0] = data_in0[15:8];
			default: data_out[7:0] = 8'bx; //输出无关值
			endcase
		else
			case(sel2)
			1'b0: data_out[7:0] = data_in0[23:16]; //8位
			1'b1: data_out[7:0] = data_in0[31:24];
			default: data_out[7:0] = 8'bx; //输出无关值
			endcase
	else
		if(sel1 == 1'b0)
			case(sel2)
			1'b0: data_out[7:0] = data_in1[7:0]; //最低8位
			1'b1: data_out[7:0] = data_in1[15:8];
			default: data_out[7:0] = 8'bx; //输出无关值
			endcase
		else
			case(sel2)
			1'b0: data_out[7:0] = data_in1[23:16]; //8位
			1'b1: data_out[7:0] = data_in1[31:24];
			default: data_out[7:0] = 8'bx; //输出无关值
			endcase
	
end	
endmodule 