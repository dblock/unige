; version 1.0 (almost) as in the original TP

mystack segment stack                   ; stack segment of 100 words
        dw 100 dup  (?)                 ; actually nobody needs a stack
mystack ends                            ; anyway...

data segment public                     ; data segment to make the prog
        mytable db 256 dup (?)          ; look clean...
data ends                               

code segment                            
start:
	mov 	ax, data
        mov     ds, ax                  
	assume 	cs:code, ds:data, ss: mystack, es:nothing

	xor 	bx,bx
localloop:
        mov     mytable[bx],bl          ; mov ds:mytable[bx]
	inc	bx
	cmp	bx,255
        jb      localloop               ; loop while filling the table with
                                        ; incrementing the counter

        mov     ah,4Ch                  ; terminate the prog
	int	21h

code ends
end start