;(c) Daniel Doubrovkine - University of Geneva - 1996 - TP4 - ASM - far library routines

.8086

tiodata segment public
	decstring 	db 9 dup (0)
	current_value 	dw 0
tiodata ends

tiocode segment public
	assume 	cs: tiocode
	org 	00h

	public 	todec, tidec

todec proc far
	push	bp				;keep bp for future use
	mov 	bp, sp				;caller's stack frame

	mov	ax, word ptr [bp+8]		;get the parameters from the caller's 
	mov	es, ax				;stack frame, passing references, not
	mov	bx, word ptr [bp+6]		;values, parameters contain addresses of
	mov	ax, word ptr es:[bx]		;the source variable

	push	ax dx di si ds es  		;save modified registers
	assume	cs: tiocode, ds: tiodata, es: tiodata
	mov	dx, tiodata
	mov	es, dx
	mov	ds, dx
        xor     cx,cx                   	;count of digits placed on stack
	mov	si,10				;set the divisor
	mov     di, offset decstring		;set the target string for decimal value
   non_zero:
        xor     dx,dx                   	;set upper word of N to 0
        div     si                      	;calculate N/10 and (N mod 10)
        push    dx                      	;push one digit onto the stack
        inc     cx                      	;one more digit added
        or      ax,ax                   	;N = 0 yet?
        jne     non_zero                	;nope, continue
   write_digit:
        pop     ax                      	;get the least significant digit
        add     al,'0'                  	;convert to a _decent_ representation
        stosb                           	;store it
        loop    write_digit             	;loop the output
        mov     al,'$'                  	;string terminator
        stosb                           	;store the termiantor
        mov     ah,9				;output the string on to the screen
        mov     dx, offset decstring
        int     21h
	pop	es ds si di dx ax		;restore modified registers
	mov 	sp, bp				;restore caller's stack frame
	pop 	bp				;restore bp
	retf    4             			;if ARG was not used, ret 4 must be here
todec endp

tidec proc far
	push	bp				;keep bp for future use
	mov 	bp, sp				;caller's stack frame

	push	es di si bx cx dx ds		;preserve modified registers
	assume	cs: tiocode, ds:tiodata		;generate assumes for TASM
	mov	ax, tiodata			
	mov	ds, ax				;set ds to data segment
	mov	es, ax				;set es to data segment
	mov	current_value, 0		;set current value to zero
	
   next_char:
	xor	ax,ax
	int	16h				;get a key from the keyboard
	cmp	al,8				;check the backspace
	jne	noback				
	call	divide				;divide by ten if backspace
	jmp	filter
   noback:
	cmp	al,32				;check if anything invalud
	jb	char_finished			;if enter or similar, then break
   filter:
	call	filter_chars			;check validity
	jc	next_char
	call	calculate_value			;check overflow
	jc	next_char
	mov	ah,2				;show character
	mov	dl,al
	add	dl,'0'
	int	21h
	jmp	next_char

   char_finished:

	mov	ax, current_value		;get the parameters from the caller's stack
	mov	bx, word ptr [bp+8]		;frame
	mov	es, bx
	mov	bx, word ptr [bp+6]
	mov	word ptr es:[bx], ax		;set the result value

	pop	ds dx cx bx si di es		;restore registers

	mov 	sp, bp				;restore caller's stack frame
	pop 	bp				;restore bp
	retf	4				;return to caller 
tidec endp

filter_chars proc				;check the value validity
	cmp	al,'0'
	jb	invalid
	cmp	al,'9'
	ja	invalid
	sub	al,'0'
	clc
	ret
   invalid:
	stc
	ret
filter_chars endp

calculate_value proc				;calculate the value entered for overflow
	push	ax bx cx
	sub	ah,ah	
	mov	cx, ax
	mov	ax, current_value
	mov	bx, 10
	mul	bx
	cmp	dx,0
	ja	overflow
	add	ax, cx
	jc	overflow
	mov	current_value, ax
   no_overflow:
	pop	cx bx ax
	clc
	ret
   overflow:
	pop	cx bx ax
	stc
	ret 
calculate_value endp

divide proc					 ;simulate a backspace
	push	ax bx
	mov	ax, current_value
	cmp	ax, 0
	je	no_divide
	xor	dx, dx
	mov	bx, 10
	div	bx
	mov	current_value, ax
	mov	ah,2
	mov	dl,8
	int	21h
	mov	dl,' '
	int	21h
	mov	dl,8
	int	21h
   no_divide:
	pop	bx ax
	ret
divide endp

tiocode ends

end