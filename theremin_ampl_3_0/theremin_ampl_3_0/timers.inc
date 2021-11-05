

;******************************************************************************************************

timer1_init:
	;ןמהדמעמגטעü t1
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