;
; thermeovoks.asm
;
; Created: 29.08.2018 11:37:20
; Author : CNIIHM
;
/*
 ������� ����� �����: � 24 �� 310
 ������ ����� (64��� ������):
  - ���������������� ������ - 4.7���
  - �������� ��� ���� - 5.7���
  - ������� ����� ����������� - 51.95���
  - ������ ��� ���� - 1.65���
*/

.list
.def zero=r2
.def tmp=r16
.def string_low=r17
.def string_high=r18
.def n_low=r19
.def n_high=r20
.def go=r21
.def tmp2=r22
.def tmp3=r23
.def count = r24
.def tmp4=r25
.equ kadr=2
.equ string=3
.equ strlow=150
.equ strhigh=250

.equ ledport=portd
.equ ledddr=ddrd
.equ ledbit=6

.cseg
.org 0

rjmp start
	.include "intvectors.inc"
	.include "acomp.inc"
	.include "timers.inc"
	.include "misc.inc"		//������ ��������
	.include "in_outs.inc"
	.include "ext_int.inc"


start:
	cli ; ���������� ���������� ����������
	clr XL	; ������ ������� ��������
	clr XH
	clr YL
	clr YH
	clr ZL
	clr ZH
	clr zero
	clr go
	    
	ldi tmp, low(RAMEND)
	out spl, tmp

	rcall in_outs_init
	rcall ext_int_init

	rcall timer1_init
	rcall timer0_init

	rcall acomp_init

	sei
	ldi count,5

loop:
	wdr
	dec count
;	inc tmp
;	out ocr0a,tmp
;	rcall delay
//	rjmp loop
	
	tst go
	breq loop
	clr go
	
	;����� ~52��� ��� �������� ������� ����� �����
	ldi tmp,208
ext_int1_loop2:
		nop
		wdr	
	dec tmp
	brne ext_int1_loop2

	;�������� ����������
	rcall acomp_off
	
	;���������� �������
	out tccr1b,zero
	cbi ledport,ledbit
	;��������� �� strhigh
	ldi tmp,low(strhigh)
	cp string_low,tmp 
	ldi tmp,high(strhigh)
	cpc string_high,tmp 
	brlo loop

	clr string_low
	clr string_high
	
	;�������������� N � ����� ��� ���
	;********************************
	//����������� �������� �� ����������� ����� X,Y,Z
	cpi count,4
	brsh m_x 
	
	cpi count,3
	brsh m_y

	cpi count,2
	brsh m_z

	tst count		; ��� ������� �������� � ���������� ����
	breq akkum

m_x:
	mov xl,n_low
	mov xh,n_high
	rjmp akkum

m_y:
	mov yl,n_low
	mov yh,n_high
	rjmp akkum

m_z:
	mov zl,n_low
	mov zh,n_high
	rjmp akkum

akkum:
	ldi count,5
	//�������� ���� ����� � ���� ����������� ����
	add zl,yl
	adc zh,yh

	add zl,xl
	adc zh,xh
	
	add zl,n_low
	adc zh,n_high
	


	//������� �� 4
	lsr zh
	ror zl
	lsr zh
	ror zl
	
	;��� ���� �������
	lsr zh
	ror zl
	lsr zh
	ror zl
	
	mov tmp,zl
	
	;andi tmp,0b1111_1100
	;lsr tmp
	;lsr tmp
	
	;mov tmp2,zh //???????????

	;andi tmp2,0b0000_0011
	;swap tmp2
	;lsl tmp2
	;lsl tmp2
	;or tmp,tmp2

	///ldi tmp, tmp<<4;
	;������� ����� � ���
	;********************************

qwe:
	ldi zl,low(in_pwm*2)
	ldi zh,high(in_pwm*2)
	clr tmp3

qwe_loop:
	inc tmp3
	lpm tmp2,z+
	cp tmp,tmp2
	brne qwe_loop

	dec tmp3

	ldi zl,low(near_pwm*2)
	ldi zh,high(near_pwm*2)
	add zl,tmp3
	adc zh,zero

	lpm tmp,z

	out OCR0A,tmp
    rjmp loop
	
near_pwm:
.db 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,17,19,22,24,26,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,58,60,62,64,65,67,69,70,72,73,75,76,78,79,81,82,84,85,86,88,89,90,92,93,94,95,97,98,99,100,101,102,103,105,106,107,108,109,110,111,112,113,114,115,116,116,117,118,119,120,121,122,122,123,124,125,126,126,127,128,129,129,130,131,131,132,133,133,134,135,135,136,136,137,138,138,139,139,140,140,141,142,142,143,143,144,144,145,145,145,146,146,147,147,148,148,149,149,149,150,150,151,151,151,152,152,152,153,153,154,154,154,155,155,155,156,156,156,156,157,157,157,158,158,158,158,159,159,159,160,160,160,160,161,161,161,161,161,162,162,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160

in_pwm:
.db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,0
;
;	.include "massive.inc"

 