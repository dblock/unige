.model small
.code

; modification du bit 1 (RTS)
; (pour la mesure de l'impedance de la source)

        mov     dx, 3FCh
        in      al,dx
        xor     al,2
        out     dx,al

        mov     ax,4C00h
        int     21h
end
