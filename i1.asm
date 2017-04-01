	.model 	tiny
	.code
	org 	100h
M:
	mov 	ah, 09h
	mov 	dx, offset msg
	int 	21h
	xor 	cx, cx
	xor 	ax, ax
	mov 	es, ax
	push 	es:[9h*4]
	push 	es:[9h*4+2]
	mov 	es:[9h*4], offset lala
	mov 	es:[9h*4+2], ds
	pop 	es
	pop 	bx
	mov 	word ptr old_vect, bx
	mov 	word ptr old_vect + 2, es
	jmp 	start
	msg 	db 	'��室 �� ESC (����砥� ��� ASCII-��� � �멤��)', 13, 10, 24h
lala proc
	pushf
	call 	dword ptr old_vect
	in  	al, 60h
	cmp 	al, 128
	jg  	pressed
	mov 	ch, 0
	mov 	cl, 0
	iret
	pressed:
		call 	prnt_symb
		cmp 	ch, 0
		mov 	ch, 1
		mov 	cl, 0
		iret
	ok:
		mov 	cl, 1
		iret
	old_vect 	dd 	?
lala endp
start:
	mov 	ah, 0
	int 	16h
	cmp 	cl, 1
	je  	start
	cmp 	al, 27
	pushf
	call 	prnt_symb
	popf
	jne 	start
	mov 	ax, 0
	mov 	es, ax
	mov 	di, 9h*4
	mov 	si, offset old_vect
	movsw
	movsw
	ret
prnt_symb proc
	push 	ax
	push 	cx
	mov 	bl, 16
	xor 	cx, cx
	get_num:
		mov 	ah, 0
		div 	bl
		inc 	cx
		mov 	dl, ah
		push 	dx
		cmp 	al, 0
		jne 	get_num
	prnt:
		mov 	bx, offset symbols
		pop 	ax
		xlat
		mov 	dl, al
		mov 	ah, 02h
		int 	21h
		loop 	prnt
	mov 	dl, 10
	int 	21h
	pop 	cx
	pop 	ax
	ret
prnt_symb endp
	symbols 	db 	'0123456789ABCDEF'
end M