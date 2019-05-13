; version 1.2 ... a little optimized ... and who needs a stack anyway?

.model tiny
.code

        mytable dw 1024 dup (?)                 

start:                                                                                          
        push    cs                              ; for stosw which moves
        pop     es                              ; ax into es:[di]

        xor     ax,ax                           
        mov     cx,1023                         ; set the counter
        mov     di,offset mytable               ; point to mytable

   myloop:
        inc     ax
        stosw                                   ; fill the word
        loop    myloop                          ; restart till cx = 0

        mov     ah,4Ch                          ; terminate prog
        int     21h                             
                                                
end start