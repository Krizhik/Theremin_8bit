in_outs_init:
	out portd, zero
	out ddrd, zero
	out portb, zero
	out ddrb, zero	

	sbi ledddr,ledbit

	sbi ddrb,2	;��������� ���� � ������ �� �����
	ret