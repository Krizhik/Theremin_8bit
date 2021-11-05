
ledblink:
	sbis ledport,ledbit
	rjmp ledblink_z
	cbi ledport,ledbit
	ret
ledblink_z:
	sbi ledport,ledbit
	ret 
