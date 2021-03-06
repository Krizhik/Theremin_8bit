ext_int_init:
	;��� ���������� int0 � int1 ��������� �� �����
	in tmp,mcucr
	ori tmp,(1<<isc10)|(1<<isc00)
	out mcucr,tmp

	;���������� ���������� int0
	in tmp,gimsk
	ori tmp,1<<int0
	out gimsk,tmp
	ret

;******************************************************************************************************	

ext_int0:
	push tmp
	in tmp,sreg
	push tmp
		;�������� ������
		inc go
		;rcall ledblink
		;�������� ������� �����
		clr string_low
		clr string_high
			ldi n_low,0xff
			ldi n_high,0xff
		;��������� ���������� ��������� �����
		in tmp,gimsk
		ori tmp,1<<int1
		out gimsk,tmp
	
	pop tmp
	out sreg,tmp
	pop tmp
reti

;******************************************************************************************************
ext_int1:
push tmp
in tmp,sreg
push tmp
	;��������� ������� �����
	ldi tmp,1
	add string_low,tmp
	adc string_high,zero
	;��������� �� strlow
	ldi tmp,low(strlow)
	cp string_low,tmp  
	ldi tmp,high(strlow)
	cpc string_high,tmp 
	brlo ext_int1_exit
		;��������� �� strhigh
		ldi tmp,low(strhigh)
		cp string_low,tmp 
		ldi tmp,high(strhigh)
		cpc string_high,tmp 
		brsh ext_int1_gt310
	
	;************** �������� ��� **************
	;���������� ��������� ����� ������ ( ���������������� ������ (4.7���) + �������� ��� ���� (5.7���))
	;	��������, "���������������� ������" �� �����
	;������ ���� ��� ��������
	/*ldi tmp,200
ext_int1_loop1:
		nop
	dec tmp
	brne ext_int1_loop1*/
	;�������� ������� �������
	out tcnt1l,zero
	out tcnt1h,zero
		;��������� ������
		ldi tmp,1<<cs10
		out tccr1b,tmp
	;���� ���������� �����������
	rcall acomp_start

	ldi go,1

	rjmp ext_int1_exit

ext_int1_gt310:
	;�������� ����������
	andi tmp,0xff-(1<<acie)
	out acsr,tmp
	;��������� ���������� int1
	in tmp,gimsk
	andi tmp,0xff-(1<<int1)
	out gimsk,tmp
ext_int1_exit:
pop tmp
out sreg,tmp
pop tmp
reti

