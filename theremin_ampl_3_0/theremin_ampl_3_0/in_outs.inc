in_outs_init:
	ldi tmp,1
	out portd, zero
	out ddrd, tmp
	ldi tmp, 0b1111_1100
	out portb, zero
	out ddrb, tmp

	sbi ledddr,ledbit

	ret