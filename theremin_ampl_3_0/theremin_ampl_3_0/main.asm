;
; thermeovoks.asm
;
; Created: 29.08.2018 11:37:20
; Author : CNIIHM
;
/*
 видимая часть линий: с 24 по 310
 внутри линии (64мкс длиной):
  - подготовительные данные - 4.7мкс
  - обратный ход луча - 5.7мкс
  - видимая часть изображения - 51.95мкс
  - прямой ход луча - 1.65мкс
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
	;.include "misc.inc"		//мелкие разности
	.include "in_outs.inc"
	.include "ext_int.inc"


start:
	cli ; Запрещение глобальных прерываний
	clr XL	; чистим пареные регистры
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
	
	;пауза ~52мкс для пропуска видимой части линии
	ldi tmp,208
ext_int1_loop2:
		nop
		wdr	
	dec tmp
	brne ext_int1_loop2

	;выключим компаратор
	rcall acomp_off
	
	;выключение таймера
	out tccr1b,zero
	cbi ledport,ledbit
	;сравнение со strhigh
	ldi tmp,low(strhigh)
	cp string_low,tmp 
	ldi tmp,high(strhigh)
	cpc string_high,tmp 
	brlo loop

	clr string_low
	clr string_high
	
	;преобразование N в число для ШИМ
	;********************************
	//раскидываем значения по регистровым прарм X,Y,Z

	mov tmp,zl
	mov tmp2,zh
	

	//сложение всех чисел в одну регистровую пару
	add tmp,yl
	adc tmp2,yh

	add tmp,xl
	adc tmp2,xh
	
	add tmp,n_low
	adc tmp2,n_high
	


	//деление на 4
	lsr tmp2
	ror tmp
	lsr tmp2
	ror tmp
	




	;еще пара сдвигов
	lsr tmp2
	ror tmp
	lsr tmp2
	ror tmp
	
	;mov tmp,zl
	
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
	;укладка числа в ШИМ
	;********************************
		push zl
		push zh
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
	
	in tmp2,portb
	andi tmp2,0b11
	andi tmp,0b1111_1100
	or tmp2, tmp
	out portb, tmp2
    
	in tmp2, portd
	lpm tmp,z
	andi tmp2,0b1111_1110
	andi tmp,0b10
	lsr tmp
	add tmp2,tmp
	out portd,tmp2
		pop zh
		pop zl
	
	mov xl,yl
	mov xh,yh
		mov yl,zl
		mov yh,zh
	mov zl,n_low
	mov zh, n_high

	rjmp loop
	
near_pwm:
.db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255

in_pwm:
.db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
;
;	.include "massive.inc"