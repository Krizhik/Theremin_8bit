ext_int_init:
	;для прерываний int0 и int1 настройка на спады
	in tmp,mcucr
	ori tmp,(1<<isc10)|(1<<isc00)
	out mcucr,tmp

	;разрешение прерывания int0
	in tmp,gimsk
	ori tmp,1<<int0
	out gimsk,tmp
	ret

;******************************************************************************************************	

ext_int0:
	push tmp
	in tmp,sreg
	push tmp
		;увеличим ключик
		inc go

		;rcall ledblink
		;обнулить счетчик строк
		clr string_low
		clr string_high
			ldi n_low,0xff
			ldi n_high,0xff
		;запустить прерывание обработки строк
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
	;увеличить счетчик строк
	ldi tmp,1
	add string_low,tmp
	adc string_high,zero
	;сравнение со strlow
	ldi tmp,low(strlow)
	cp string_low,tmp  
	ldi tmp,high(strlow)
	cpc string_high,tmp 
	brlo ext_int1_exit
		;сравнение со strhigh
		ldi tmp,low(strhigh)
		cp string_low,tmp 
		ldi tmp,high(strhigh)
		cpc string_high,tmp 
		brsh ext_int1_gt310
	
	;************** основной код **************
	;пропустить невидимую часть строки ( подготовительные данные (4.7мкс) + обратный ход луча (5.7мкс))
	;	возможно, "подготовительных данных" не будет
	;пустой цикл для пропуска
	/*ldi tmp,200
ext_int1_loop1:
		nop
	dec tmp
	brne ext_int1_loop1*/
	;обнулить счетчик таймера
	out tcnt1l,zero
	out tcnt1h,zero
		;запустить таймер
		ldi tmp,1<<cs10
		out tccr1b,tmp
	;пуск прерываний компаратора
	rcall acomp_start

	ldi go,1

	rjmp ext_int1_exit

ext_int1_gt310:
	;выключим компаратор
	andi tmp,0xff-(1<<acie)
	out acsr,tmp
	;отключить прерывание int1
	in tmp,gimsk
	andi tmp,0xff-(1<<int1)
	out gimsk,tmp
ext_int1_exit:
pop tmp
out sreg,tmp
pop tmp
reti

