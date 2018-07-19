#include <AT89x52.h>
#include <math.h>
//#include "1602.h"
#define uchar unsigned char
#define uint unsigned int
#define ulong unsigned long int
#define CPLD_DATA P1
sbit sel_num = P3^3;//选择接收哪一个数据
sbit sel_num_low = P3^4; //选择两个数据的低16位
sbit sel_num_high = P3^5;  //选择两个数据的高16位

//sbit lcden = P2^2;
//sbit lcdrs = P2^0;
//sbit lcdrw = P2^1;
sbit lcden = P0^2;
sbit lcdrs = P0^0;
sbit lcdrw = P0^1;

void delay(uint x);
void set_pos(uchar pos);
void init_1602();
void write_data(uchar date);
void write_com(uchar com);

void mov_data();
void operation(); 
void display();  
ulong convert(ulong dat);
//code 是写入rom的
uchar  cnt_data[] = {0, 0, 0, 0, 0, 0, 0, 0}; //8个8位，待测频率计数值
//uchar  cnt_data[] = {0x40, 0x78, 0x7D, 0x01, 0x40, 0x78, 0x7D, 0x01}; //8个8位，待测频率计数值
uchar  display_data[] = "        .       "; //显示缓冲
ulong fxcnt; //转换得到的值
bit extern_int0_flag;  //中断标志位
void InitMCU();
void main()
{
	delay(500); //延时等电源稳定
	InitMCU();
	init_1602();
	while(1)
	{
		if(extern_int0_flag)
		{
			mov_data();  //接收数据
			extern_int0_flag = 0; //清除中断标志
		}
		operation();   //数据处理
		set_pos(0x40); //设置第二行显示位置
		display();   //数据1602显示
		delay(200);  //考虑加不加
	}
}

//*********************二进制变十进制*******************
ulong convert(ulong dat)
{
	//32位转换
	ulong sum = 0;
	char n;
	for(n = 31; n >= 0; n--)
	{
		if((dat&0x80000000) == 0x80000000)
		{
			sum = sum + pow(2,n);  //2的几次方
		}
		else
		{
			
		}
		dat <<= 1;   //左移*2
	}
	return sum;
}
/****************初始化单片机************************/
void InitMCU()
{
	//修改ET0为EX0
	EX0 = 1; //开启外部中断0
	IT0 = 1; //触发方式
	EA = 1; //开总中断
	
}

/*****************外部中断函数************************/
void extern_int0() interrupt 0
{
	extern_int0_flag = 1;  //中断标志为1
}

/*****************接受CPLD数据****************************/
void mov_data()
{
	uchar a, b, c, d = 0;
	CPLD_DATA = 0xFF; //先拉高数据口
//	sel_num = 0; //选择fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[0] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 0; //选择fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[1] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 0; //选择fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[2] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 0; //选择fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[3] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 1; //选择fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[4] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 1; //选择fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[5] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 1; //选择fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[6] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
//	
//	sel_num = 1; //选择fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[7] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
	for(a = 0; a < 2; a++)
		for(b = 0; b < 2; b++)
			for(c = 0; c < 2; c++)
			{
	
					sel_num = a; //选择fxcnt
					sel_num_low = b; //
					sel_num_high = c;  //多次位操作，考虑总线
					delay(1);
					cnt_data[d++] = CPLD_DATA;//低位为fxcnt,高位为fbasecnt
				
			}
	d = 0;  //清零下次计数
}
/*******************对接收的数据操作****************/
void operation()
{
	//调试并且修改这里
	ulong  F_X = 0;
	uint temp_s;
	float temp, fxcnt, fbasecnt, F_X_P;
//	fbasecnt=cnt_data[7]<<24+cnt_data[6]<<16+cnt_data[5]<<8+cnt_data[4];
	fbasecnt = cnt_data[7]*16777216+cnt_data[6]*65536+cnt_data[5]*256+cnt_data[4];
	fbasecnt = convert(fbasecnt);  //转换十进制
	
	fxcnt = cnt_data[3]*16777216+cnt_data[2]*65536+cnt_data[1]*256+cnt_data[0];
	fxcnt = convert(fxcnt); //转换十进制
	
//	F_X = fxcnt / fbasecnt * 25000000;  
	temp = fxcnt / fbasecnt;   //高频数太大，可能会溢出
	F_X = temp * 100000000;  //修改为系统时钟50M
	F_X_P = temp * 100000000 - F_X;
	display_data[9] = F_X_P * 10 + 48;
	temp_s = F_X_P * 100;
	display_data[10] = temp_s % 10 + 48;
	temp_s = F_X_P * 1000;
	display_data[11] = temp_s % 10 + 48;
	temp_s = F_X_P * 10000;
	display_data[12] = temp_s % 10 + 48;
	temp_s = F_X_P * 100000;
	display_data[13] = temp_s % 10 + 48;
	temp_s = F_X_P * 1000000;
	display_data[14] = temp_s % 10 + 48;
	temp_s = F_X_P * 10000000;
	display_data[15] = temp_s % 10 + 48;
	//未考虑小数点
	display_data[0] = F_X / 10000000 + 48;
	display_data[1] = F_X / 1000000 % 10 + 48;
	display_data[2] = F_X / 100000 % 10 + 48;
	display_data[3] = F_X / 10000 % 10 + 48;
	display_data[4] = F_X / 1000 % 10 + 48;
	display_data[5] = F_X / 100 % 10 + 48;
    display_data[6] = F_X / 10 % 10 + 48;
    display_data[7] = F_X % 10 + 48;
}

void display()
{
	
	uchar i;
	//未考虑小数点
//	uchar qw, bw, sw, w, q, b, s, g;
//	qw = F_X / 10000000;
//	bw = F_X / 1000000 % 10;
//	sw = F_X / 100000 % 10;
//	w = F_X / 10000 % 10;
//	q = F_X / 1000 % 10;
//	b = F_X / 100 % 10;
//	s = F_X / 10 % 10;
//	g = F_X % 10;
	for(i = 0; i < 16; i++)
	{
		write_data(display_data[i]);
	}
	
}

/*ms延时函数*/
void delay(uint x)
{
	uint i,j;
	for(i = 0; i < x; i++)
	for(j = 0; j < 112; j++);
}
/*********************写命令子程序***********************/
void write_com(uchar com)
{
	lcdrs = 0;
	P2 = com;
	delay(5);
	lcden = 1;
	delay(5);
	lcden = 0;
}
/*********************写数据子程序*************************/
void write_data(uchar date)
{
	lcdrs = 1;
	P2 = date;
	delay(5);
	lcden = 1;
	delay(5);
	lcden = 0;
}

/********************初始化子程序**************************/
void init_1602()
{
	lcden = 0;
	lcdrw = 0;
	write_com(0x38);//设置16*2显示
	write_com(0x0c);//设置开显示，不显示光标（显示改0e）
	write_com(0x06);//写一个字符后地址指针加1
	write_com(0x01);//显示清0，数据指针清0
	write_com(0x80 + 0x1); //这里可能需要修改指针位置
	
}
/*******************设置指针位置程序************************/
void set_pos(uchar pos)
{
 	write_com(pos | 0x80);
}
