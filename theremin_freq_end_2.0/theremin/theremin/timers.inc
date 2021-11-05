timer0_init:
	;подготовить и пустить шимку на нулевом таймере
	ldi tmp, (1<<WGM00)|(1<<WGM01)|(1<<COM0A0)
	out TCCR0A,tmp
	ldi tmp,(1<<WGM02)|(1<<CS02);256  |(1<<CS00)	;1024
	;ldi tmp,(1<<WGM02)|(1<<CS00)	;1
	out TCCR0B, tmp;поделил на 1024

	ldi tmp,5
	out OCR0A,tmp
	ret

;******************************************************************************************************

timer1_init:
	;подготовить t1
	out tccr1a,zero
	out tccr1b,zero
	out tccr1c,zero
	ret

;******************************************************************************************************

/*
delay:
	push tmp
	ldi tmp,100
delay_loop:
		rcall smallpause
	dec tmp
	brne delay_loop
	pop tmp
	ret

;******************************************************************************************************

smallpause:
	push tmp
	clr tmp
smallpause_loop:
		push tmp
		pop tmp
	dec tmp
	brne smallpause_loop
	pop tmp
	ret
	*/


;******************************************************************************************************

	/*
tcnt0_compa:
	push tmp
	in tmp,sreg
	push tmp
		;rcall ledblink
	pop tmp
	out sreg,tmp
	pop tmp
	reti*/