#include <AT89x52.h>
sbit lcden = P2^2;
sbit lcdrs = P2^0;
sbit lcdrw = P2^1;
//void delay(uint x);
//void set_pos(uchar pos);
//void init_1602();
//void write_data(uchar date);
//void write_com(uchar com);

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
	P0 = com;
	delay(5);
	lcden = 1;
	delay(5);
	lcden = 0;
}
/*********************写数据子程序*************************/
void write_data(uchar date)
{
	lcdrs = 1;
	P0 = date;
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
