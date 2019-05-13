comment &
  ------------------------------------------------------
  TP6 : the digital clock on the right top of the screen
  ------------------------------------------------------
  (c) Daniel Doubrovkine - uniGe.ch - 1996

	The clock keeps the color of the background!
&


	.model small                           ;automatic assumes
	.8086
clock   segment byte                           ;clock segment
	assume  cs:clock,ds:clock,es:clock,ss:clock
	org   100h                             ;usual .com entry stuff         

start:  jmp     entry_point                    ;getting into entry point 

	old_vector      dd      ?              ;saving old int 1C vector

new_vector      label   far                    ;the new vector entry
		pushf   
		push    ax es cx di es         ;save regs, though unnecessary
		std                            ;set direction
		mov     ax, 0B809h             ;the video seg
		mov     es, ax
		mov     ah, 02h                ;timer interrupt
		int     1Ah                    ;you can call some non-critical
					       ;ints, like 1Ah
		mov     di, 15                 ;this is a small optimization
@i_1:           xchg    cl, dh                 ;that makes the code ...well
		xchg    ax, cx                 ;really short
		mov     cl, ah
		aam     10h                    ;this function is undocumented
@i_2:           or      al, '0'                ;but exists since 8086
		dec     di                     ;divides by 10 and adds ah
		stosb
		xchg    al, ah
		jz      short i_ok
		jnp     short @i_2
		mov     al, ':'
		dec     di
		stosb
		jmp     short @i_1
i_ok:           
		pop     es di cx es ax         ;here we are finished
		popf
		jmp     cs:old_vector          ;jmp to the old vector


entry_point:
		
		push    es
		push    cs                     ;all this is really long
		pop     ds                     ;this is the cartesian method
					       ;for setting the new interrupt
					       ;and can be done in 4 lines of
					       ;code
		mov     ax, 351Ch              ;save the old 1Ch vector
		int     21h                    
		mov     word ptr[old_vector+2],es
		mov     word ptr[old_vector],bx

		mov     ax, 251Ch              ;new int 1Ch
		lea     dx, new_vector         
		int     21h                     

		lea     dx,entry_point         ;dx: size of resident code
		mov     cl,4                   ;no. of paragraphs
		shr     dx,cl                  
		inc     dx                     ;security para
		pop     es
		mov     ax,3100h               ;return to DOS
		int     21h

clock ends
end start
