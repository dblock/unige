; version 1.1 with 1024 words table to fill from 0 to 1023

mystack segment stack
	dw 100 dup  (?)
mystack ends

data segment public
        mytable dw 1024 dup (?)
data ends

code segment
start:
	mov 	ax, data
	mov 	ds, ax
	assume 	cs:code, ds:data, ss: mystack, es:nothing

	xor 	bx,bx
        xor     cx,cx                           ; we want to fill with 0..1023
localloop:                                      ; cx will be used therefore
        mov     mytable[bx],cx
        add     bx,2                            ; next word 
        inc     cx                              
        cmp     bx,1023
        jb      localloop                       ; loop till finished the fill

        mov     ah,4Ch                  
	int	21h

code ends
end start