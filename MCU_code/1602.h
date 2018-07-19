#ifndef _1602_H_
#define _1602_H_
	extern 	void delay(uint x);
	void set_pos(uchar pos);
	void init_1602();
	void write_data(uchar date);
	void write_com(uchar com);
#endif