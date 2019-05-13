;REINES - Daniel Doubrovkine - dblock@infomaniak.ch - the simplest reines
;± stack segment definition ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
stackseg segment para stack 
        dw  256 dup (?)
stackseg ends       
;± stack segment end ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
                     
;± data segment definition ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                             
data segment para 'DATA'                                                    
        last_added      db      0               ;last added item            
        array           db      100 dup (0)     ;array for the pseudo list                
        len             dw      0               ;number of added items      
        square          db      9               ;size of the chess board
data ends                                                                   
;± data segment end ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
                                                                        
;± code segment definition ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
code segment                                                            
;± assumes for default segments ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±  
assume cs:code,ds:data,ss:stackseg                                      
        cld                     ;clear direction flag
        mov     ax,seg data     ;                                           
        mov     ds,ax           ;ds = data segment address              
                                                                        
        mov     al,1            ;add unit to the list                   
        call    add_item                                                
                                                                        
     mr_entry:                                                          
 	cmp     ds:[len],0      ;is the list empty (length=0)           
       	jbe     mr_exit         ;then exit                              
     mr_not_max:                                                         
        call    verify_list     ;check the list                         
 	jc      mr_invalid      ;if carry, then invalid                 
	mov     al,ds:[square]  ;al=board size                          
        cbw                     ;convert al to word: ax                 
	cmp     ds:[len],ax     ;is the length maximum?                 
	ja      mr_invalid      ;can be error (bigger!)                 
	je      mr_solution     ;if equal, a solution                   
	mov     al,1            ;add a unit to the list                 
	call    add_item                                                
	jmp     mr_entry        ;roll the backtracking algorithm        
   mr_invalid:                                                          
        call    backtrack       ;backtrack                              
      	jmp     mr_entry        ;roll
   mr_solution:                      
        call    affiche_array   ;a solution! write it to the screen
     comment &                  
        call    backtrack       ;remove comment and it will
        jmp     mr_entry        ;find all the solutions                     
             &                  
       	jmp     mr_exit         ;exit, only one solution needed           
   mr_exit:                                                    
        mov     ax,4C00h        ;exit without error
        int     21h                                                  
                                                                     
backtrack proc                                                       
  bk_retrack:                                                        
       	cmp     ds:[len],0      ;is the list empty, then exit                                     
     	je      bk_exit                                              
        mov     al,ds:[last_added]  
     	cmp     al,ds:[square]  ;is the last item at max?     
     	jne     bk_no_retrack   ;if not increment it
     	call    remove_item     ;remove item
     	jmp     bk_retrack      ;restart
  bk_no_retrack:                                                 
        inc     al              ;increment item                                 
        push    ax              ;save reg                                   
        call    remove_item     ;remove item                                 
        pop     ax              ;restore reg 
        call    add_item        ;add new item
  bk_exit:                                   
      	ret                     ;return
backtrack endp                                                   
                                                                 
add_item proc                                                    
        mov     si,offset ds:[array]   ;get the pointer to array                          
        add     si,ds:[len]            ;get the end of the array
        mov     ds:[si],al             ;add item
        mov     ds:[last_added],al     ;update the last_added
        inc     ds:[len]               ;increment the counter
        ret                                                      
add_item endp                                                    
                                                                 
remove_item proc                                                 
        mov     si,offset ds:[array]   ;get the pointer to array
        add     si,ds:[len]            ;get the end of the array
        dec     si                     ;get last item
        mov     al,0                   ;fill it with nothing
        mov     ds:[si],al                                       
        dec     ds:[len]               ;decrement the counter                          
        mov     al,ds:[si-1]           ;update the last added
        mov     ds:[last_added],al
        ret                                                      
remove_item endp                                                 
                                                                 
verify_list proc                                                 
        cmp     ds:[len],1              ;one item list is valid by default                          
      	jbe     vl_exit                 ;same for an empty list                    
        mov     si,offset ds:[array]    ;address of the array
       	mov     cx,ds:[len]             ;length of the array
        dec     cx                      ;do not check the last added item
        mov     dx,ds:[len]             
        mov     dh,0                     
   vl_diag:                                                            
        inc     dh                                               
        lodsb                                                    
        mov     bh,al                    

        ;last_added item on column dl
        ;bh item on column dh

	cmp     al,ds:[last_added]      ;check the duplicate                
     	je      vl_error                                    
                                         
        mov     bl,bh                   ;check diagonal 
        sub     bl,ds:[last_added]                     
        sub     bl,dh                                  
        add     bl,dl                                  
        jz      vl_error                               
                                                       
        mov     bl,ds:[last_added]      ;check anti-diagonal 
        sub     bl,bh                    
        sub     bl,dh                    
        add     bl,dl                    
        jz      vl_error                     
                                              
	loop    vl_diag                 ;next item
   vl_exit:
	clc                             ;exit without error                            
	ret                                                
   vl_error:                                               
        stc                             ;exit with error 
     	ret                                             
verify_list endp                                        
                                                        
affiche_array proc                      ;write the list to the screen                
        mov     si,offset ds:[array]    ;address of the array
        mov     cx,ds:[len]             ;total items to write
   aa_next:                                                  
        lodsb                   ;next item

        ;a routine must be added to print huger decimal numbers than 10
        mov     dl,al           ;write on screen
        add     dl,'0'                                  
        mov     ah,2                                    
        int     21h                                     
        
        loop    aa_next         ;loop till cx=0
        mov     ah,2            ;write and enter                            
        mov     dl,13                                                       
        int     21h                                                         
        mov     dl,10                                                       
        int     21h                                                         
        ret                                                                 
affiche_array endp                                                          
                                                                            
code ends                                                                   
;± code segment end ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
end                                                                         
;± program end ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±