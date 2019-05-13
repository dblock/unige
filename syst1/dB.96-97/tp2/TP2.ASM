; version 1.0 (almost) as in the original TP

mystack segment stack                   ; stack segment of 100 words
        dw 100 dup  (?)                 ; actually nobody needs a stack
mystack ends                            ; anyway...

data segment public                     ; data segment to make the prog
        copyright       db      '(c) Daniel Doubrovkine - uniGe / STI - A.R.R. - 1996 - doubrov5@cui.unige.ch',13,10,'$'
        decstring       db      9 dup (0)
        enterval        db      'Please press a valid key: $';
        header          db      13,10,'dec - bin - hex - oct',13,10,'$'
data ends                               

code segment                            

affiche macro message                           ;macro for output of a $.str
        push    ax dx
        mov     ah,9
        mov     dx, offset message
        int     21h
        pop     dx ax
endm

start:
        push    ax bx cx dx es ds 
        
        mov     ax, data
        mov     ds, ax                  
        mov     es, ax
        assume  cs:code, ds:data, ss: mystack, es:data
        affiche copyright        
        affiche enterval                ;ask for a key
        xor     ax,ax
        int     16h                     ;get a key
        mov     ah,2
        mov     dl,al
        int     21h
        sub     ah,ah
        affiche header                  ;output in different bases
        mov     si,10                   ;can do till 127 
        call    output_value
        mov     si,2
        call    output_value
        mov     si,16
        call    output_value
        mov     si,8
        call    output_value
        
        pop     ds es dx cx bx ax
        mov     ah,4Ch                  ; terminate the prog
        int     21h

;北 output_value 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
; purpose: output a value to screen after converting 
; entry  : ax: 16 bit integer to convert
;          si: target base
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
output_value proc
        push    dx ax
        mov     di, offset decstring
        call    convert_base
        mov     ah,2
        mov     dl,' '
        int     21h
        affiche decstring
        pop     ax dx
        ret
output_value endp

;北 convert_base 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
; purpose: output a value to a ASCII string at ds:[di] in a different base
; entry  : ax: 16 bit integer to convert
;          si: target base
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
convert_base   proc
        push    ax cx dx si             ;preseve registers
        xor     cx,cx                   ;count of digits placed on stack
   non_zero:
        xor     dx,dx                   ;set upper word of N to 0
        div     si                      ;calculate N/10 and (N mod 10)
        push    dx                      ;push one digit onto the stack
        inc     cx                      ;one more digit added
        or      ax,ax                   ;N = 0 yet?
        jne     non_zero                ;nope, continue
   write_digit:
        pop     ax                      ;get the least significant digit
        add     al,'0'                  ;convert to a _decent_ representation
        cmp     al,'9'                  ;hexa char value?
        jbe     nothexa                 ;convert to hexa
        add     al,'A'-'9'-1            
   nothexa:
        stosb                           ;store it
        loop    write_digit             ;loop the output
        mov     al,'$'                  ;terminate the string
        stosb                           ;store the termiantor
        pop     si dx cx ax             ;restore registers
        ret                             
convert_base    endp

code ends
end start
