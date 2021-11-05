	rjmp ext_int0				; ext int 0
	rjmp ext_int1				; ext int 1
	reti				; timer1 
	reti				; timer1 compa
	reti				; timer1 ovf
	reti				; timer0 ovf
	reti				; UART Rx complete
	reti				; UART data register empty
	reti				; UART Tx complete
	rjmp acomp			; analog comparator 
reti	;pcint
reti	;tcnt1 compb
reti	;tcnt0 compa
reti	;tcnt0 compb
reti	;usi start
reti	;usi ovf
reti	;eeprom rdy
reti	;wdt ovf

