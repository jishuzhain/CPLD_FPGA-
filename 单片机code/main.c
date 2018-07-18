#include <AT89x52.h>
#include <math.h>
//#include "1602.h"
#define uchar unsigned char
#define uint unsigned int
#define ulong unsigned long int
#define CPLD_DATA P1
sbit sel_num = P3^3;//ѡ�������һ������
sbit sel_num_low = P3^4; //ѡ���������ݵĵ�16λ
sbit sel_num_high = P3^5;  //ѡ���������ݵĸ�16λ

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
//code ��д��rom��
uchar  cnt_data[] = {0, 0, 0, 0, 0, 0, 0, 0}; //8��8λ������Ƶ�ʼ���ֵ
//uchar  cnt_data[] = {0x40, 0x78, 0x7D, 0x01, 0x40, 0x78, 0x7D, 0x01}; //8��8λ������Ƶ�ʼ���ֵ
uchar  display_data[] = "        .       "; //��ʾ����
ulong fxcnt; //ת���õ���ֵ
bit extern_int0_flag;  //�жϱ�־λ
void InitMCU();
void main()
{
	delay(500); //��ʱ�ȵ�Դ�ȶ�
	InitMCU();
	init_1602();
	while(1)
	{
		if(extern_int0_flag)
		{
			mov_data();  //��������
			extern_int0_flag = 0; //����жϱ�־
		}
		operation();   //���ݴ���
		set_pos(0x40); //���õڶ�����ʾλ��
		display();   //����1602��ʾ
		delay(200);  //���ǼӲ���
	}
}

//*********************�����Ʊ�ʮ����*******************
ulong convert(ulong dat)
{
	//32λת��
	ulong sum = 0;
	char n;
	for(n = 31; n >= 0; n--)
	{
		if((dat&0x80000000) == 0x80000000)
		{
			sum = sum + pow(2,n);  //2�ļ��η�
		}
		else
		{
			
		}
		dat <<= 1;   //����*2
	}
	return sum;
}
/****************��ʼ����Ƭ��************************/
void InitMCU()
{
	//�޸�ET0ΪEX0
	EX0 = 1; //�����ⲿ�ж�0
	IT0 = 1; //������ʽ
	EA = 1; //�����ж�
	
}

/*****************�ⲿ�жϺ���************************/
void extern_int0() interrupt 0
{
	extern_int0_flag = 1;  //�жϱ�־Ϊ1
}

/*****************����CPLD����****************************/
void mov_data()
{
	uchar a, b, c, d = 0;
	CPLD_DATA = 0xFF; //���������ݿ�
//	sel_num = 0; //ѡ��fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[0] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 0; //ѡ��fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[1] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 0; //ѡ��fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[2] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 0; //ѡ��fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[3] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 1; //ѡ��fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[4] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 1; //ѡ��fxcnt
//	sel_num_low = 0; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[5] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 1; //ѡ��fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 0; 
//	delay(1);
//	cnt_data[6] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
//	
//	sel_num = 1; //ѡ��fxcnt
//	sel_num_low = 1; //
//	sel_num_high = 1; 
//	delay(1);
//	cnt_data[7] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
	for(a = 0; a < 2; a++)
		for(b = 0; b < 2; b++)
			for(c = 0; c < 2; c++)
			{
	
					sel_num = a; //ѡ��fxcnt
					sel_num_low = b; //
					sel_num_high = c;  //���λ��������������
					delay(1);
					cnt_data[d++] = CPLD_DATA;//��λΪfxcnt,��λΪfbasecnt
				
			}
	d = 0;  //�����´μ���
}
/*******************�Խ��յ����ݲ���****************/
void operation()
{
	//���Բ����޸�����
	ulong  F_X = 0;
	uint temp_s;
	float temp, fxcnt, fbasecnt, F_X_P;
//	fbasecnt=cnt_data[7]<<24+cnt_data[6]<<16+cnt_data[5]<<8+cnt_data[4];
	fbasecnt = cnt_data[7]*16777216+cnt_data[6]*65536+cnt_data[5]*256+cnt_data[4];
	fbasecnt = convert(fbasecnt);  //ת��ʮ����
	
	fxcnt = cnt_data[3]*16777216+cnt_data[2]*65536+cnt_data[1]*256+cnt_data[0];
	fxcnt = convert(fxcnt); //ת��ʮ����
	
//	F_X = fxcnt / fbasecnt * 25000000;  
	temp = fxcnt / fbasecnt;   //��Ƶ��̫�󣬿��ܻ����
	F_X = temp * 100000000;  //�޸�Ϊϵͳʱ��50M
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
	//δ����С����
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
	//δ����С����
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
	P2 = com;
	delay(5);
	lcden = 1;
	delay(5);
	lcden = 0;
}
/*********************д�����ӳ���*************************/
void write_data(uchar date)
{
	lcdrs = 1;
	P2 = date;
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
