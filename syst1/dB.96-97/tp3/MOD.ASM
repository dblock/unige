;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
; Modulo routine (c) Daniel Doubrovkine - 1996
; divides DX|AX by (DI)BX, remainder from the entire division in AX
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
modulo  proc   near                 
        cmp     bx,0                    ;if bx is zero, than result will 
        je      theend                  ;return the value (division by zero)
        xor     di,di                   ;di to zero
        mov     si,bx                   ;dividing by DI:SI
        mov     cx,di
        cmp     di,dx
        jb      mainloop
        cmp     si,ax                
        ja      theend                  ;then there's nothing to do
   mainloop:   
        clc                             ;clear carry
        shl    si,1
        rcl    di,1                     ;shl DI:SI,1
        jc     nextloop
        cmp    di,dx                    ;if divider (DI:SI) > DX:AX
        ja     nextloop                 ;then substract
        cmp    si,ax
        ja     nextloop
   nextloop:  
        shr     di,1                    ;shr DI:SI,1
        rcr     si,1                    ;
        sub     ax,si                   ;substract right 16 
        sbb     dx,di                   ;substract left 16 - Carry
        mov     si,bx                   
        mov     di,cx                   ;evolutive division possible (di<>0)
        cmp     dx,di                   ;check that the result is smaller
        ja      mainloop                ;than the divider
        cmp     ax,si
        jae     mainloop
   theend:  
        ret
modulo  endp
