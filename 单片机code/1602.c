#include <AT89x52.h>
sbit lcden = P2^2;
sbit lcdrs = P2^0;
sbit lcdrw = P2^1;
//void delay(uint x);
//void set_pos(uchar pos);
//void init_1602();
//void write_data(uchar date);
//void write_com(uchar com);

/*ms��ʱ����*/
void delay(uint x)
{
	uint i,j;
	for(i = 0; i < x; i++)
	for(j = 0; j < 112; j++);
}
/*********************д�����ӳ���***********************/
void write_com(uchar com)
{
	lcdrs = 0;
	P0 = com;
	delay(5);
	lcden = 1;
	delay(5);
	lcden = 0;
}
/*********************д�����ӳ���*************************/
void write_data(uchar date)
{
	lcdrs = 1;
	P0 = date;
	delay(5);
	lcden = 1;
	delay(5);
	lcden = 0;
}

/********************��ʼ���ӳ���**************************/
void init_1602()
{
	lcden = 0;
	lcdrw = 0;
	write_com(0x38);//����16*2��ʾ
	write_com(0x0c);//���ÿ���ʾ������ʾ��꣨��ʾ��0e��
	write_com(0x06);//дһ���ַ����ַָ���1
	write_com(0x01);//��ʾ��0������ָ����0
	write_com(0x80 + 0x1); //���������Ҫ�޸�ָ��λ��
	
}
/*******************����ָ��λ�ó���************************/
void set_pos(uchar pos)
{
 	write_com(pos | 0x80);
}
