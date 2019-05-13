.model small
.code

; modification du bit 0 (DTR) et 1 (RTS)

        mov     dx, 3FCh
B:      in      al,dx
        xor     al,1+2
        out     dx,al

        in      al,60h
        cmp     al,1
        jne     B

        mov     ax,4C00h
        int     21h
end
