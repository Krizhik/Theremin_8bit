
acomp:
push tmp
in tmp,sreg
push tmp
	sbi ledport,ledbit
	in tmp,tcnt1l
	in tmp2,tcnt1h
	cp tmp,n_low
	cpc tmp2,n_high
	brsh not_change_rez 
	mov n_low, tmp
	mov n_high, tmp2
not_change_rez:
	;�������� ����������
	rcall acomp_off
	;�������� ������
	out tccr1b,zero
pop tmp
out sreg,tmp
pop tmp
reti


;******************************************************************************************************

acomp_init:
	; ����������� ����������
	in tmp,didr
	ori tmp,3
	out didr,tmp

	in tmp,acsr
	ori tmp,3
	out acsr,tmp

	andi tmp,0xff-(1<<acie)
	out acsr,tmp
	ret


;******************************************************************************************************
;���������� �����������
acomp_off:
	in tmp,acsr
	andi tmp,0xff-(1<<acie)
	out acsr,tmp
ret
;******************************************************************************************************
;���� ���������� �����������
acomp_start:
in tmp,acsr
	ori tmp,1<<acie
	out acsr,tmp
ret