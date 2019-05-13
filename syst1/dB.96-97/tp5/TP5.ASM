; (c) Daniel Doubrovkine - Lab 5 - 1996
; note: algorithm assumes that the labyrinth is correctly constructed
;       and contains an entry, an exit and walls all around it

data segment
        include plan.asm                        ;the laby data
        lstart          db      'þ'             ;starting point
        lwall           db      '±'             ;laby wall
        lend            db      16              ;laby ends here
        lnothing        db      ' '             ;a space
        lback           dw      07FFh           ;erase char
        cool            db      'You found it!',10,13,'Thanks for using the most unefficient algorithm in the world!',13,10,'$'
data ends

lstack segment stack
        dw 500 dup (0)
lstack ends

code segment
        assume cs:code, ds:data, ss:lstack

        lwidth   equ      26                    ;laby assumed width
        lheight  equ      18                    ;laby assumed height
        
start:
        push    ax bx cx dx es ds si di         ;save general purpose regs
                
        mov     ax, data
        mov     ds, ax                          ;define data seg 
        call    draw_laby                       ;draw the labyrinth
        
        mov     di, bx                          ;set the starting point
        mov     bh, lend                        ;set the ending checker
        call    visit_pos                       ;start with the first one
        
        mov     ah,2                            ;set the cursor position
        mov     dl, 0                           ;first column
        mov     dh, lheight                     ;row at end of laby
        sub     bh, bh                          ;first page
        int     10h                             ;go for it

        mov     ah,9                            
        mov     dx, offset cool
        int     21h                             ;show the cool message

        pop     di si ds es dx cx bx ax         ;restore modified regs
        mov     ax,4C00h                        
        int     21h                             ;terminate 

draw_laby proc
        mov     ax, 3                           ;reset the video mode
        int     10h                             ;actually clear screen
        mov     ax, 0B800h                      ;start of the video memory
        mov     es, ax                          ;the segment
        xor     di, di                          ;zero the offset
        
        mov     cx, lheight                     ;height loop counter
        mov     si, offset plan                 ;offset of the laby
   height_loop:
        push    cx                              ;save for internal loop
        mov     cx, lwidth                      ;generate the internal loop
   width_loop:
        lodsb                                   ;next char
        call    translate                       ;analyse the byte
        stosw
        loop    width_loop                      ;loop the width loop
        add     di, 160 - lwidth*2              ;set next line
        pop     cx                              ;restore for height loop
        loop    height_loop                     ;execute it
        ret
draw_laby endp

translate proc
        cmp     al, 0                           ;nothing
        jne     no_nothing
        mov     al, lnothing
        mov     ah, 7
        ret
   no_nothing:
        cmp     al, 9                           ;wall
        jne     no_wall
        mov     al, lwall
        mov     ah, 1
        ret
   no_wall:
        cmp     al, 5                           ;start
        jne     no_start
        mov     al, lstart
        mov     ah, 2
        mov     bx, di
        add     bx, 2
        ret
   no_start:
        cmp     al, 1                           ;end
        jne     tp_end
        mov     al, lend
        mov     ah, 3
        ret
   tp_end:
        ret
translate endp

visit_pos proc
        clc                                     ;clear the carry flag
        cmp     es:[di], bh                     ;did we reach the end
        je      all_done                        ;then forget about it
        call    vertical_retrace                ;make it slow
        mov     ax, 03FEh                       ;show the move
        mov     es:[di], ax                     ;store the move char
        mov     al, ' '                         ;the max clean char
        cmp     es:[di+160], al                 ;bottom move?
        jnbe    no_down                         
        push    di ax
        add     di, 160
        call    visit_pos                       ;make the up move
        pop     ax di
        jc      all_done
   no_down:        
        cmp     es:[di-2], al                   ;left move?
        jnbe    not_left
        push    di ax
        sub     di, 2
        call    visit_pos                       ;make the left move
        pop     ax di
        jc      all_done
   not_left:
        cmp     es:[di-160], al                 ;up move?
        jnbe    not_top
        push    di ax
        sub     di, 160
        call    visit_pos                       ;make the up move
        pop     ax di
        jc      all_done
   not_top:
        cmp     es:[di+2], al                   ;right move?
        jnbe    not_right
        push    di ax
        add     di, 2
        call    visit_pos                       ;make the right move
        pop     ax di
        jc      all_done
   not_right:
        mov     ax, 07FFh                       ;we are going back, a dead 
        mov     es:[di],ax                      ;end was found, store the 
        call    vertical_retrace                ;char slow a bit and exit
        ret                            
   all_done:
        stc                                     ;an exit was found!
        ret
visit_pos endp

vertical_retrace proc                           ;wait for vertical retrace
        mov     dx, 03DAh                       ;(silly brute method)
   vr_loop:
        in      al, dx
        test    al, 8
        jz      vr_loop
   vr_inside:   
        in      al,dx
        test    al,8
        jnz     vr_inside
        ret
vertical_retrace endp

code ends
end start

