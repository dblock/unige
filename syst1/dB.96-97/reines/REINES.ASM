;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; REINES - Queens (version 1.13.00 - 06/12/95)
; (c) Daniel Doubrovkine - uniGE.ch - November/December 1995
; distribute freely, email welcome: dblock@infomaniak.ch
; 
; This program calculates all the possibilities to place queens on a square
; chess board of any size without one attacking another.
;
; Requirements:
;
; þ decent computer (will not work on Commodore 64...no way)
;
; Features:
;
; þ powerful super-fast backtracking method...if someone makes a faster
;   please DO send me a mail! (I pay a beer to the one who resolves this
;   problem and writes a much faster algorithm with or without the 
;   backtracking method.)
;     including:                                    
;      - leftside backtracking
;      - half lists    
;      - pointers displacement
;      (see detailed explanation later...)
; þ half list calculation
; þ directable from command line
; þ suppress messages and results' output, faster calculation (M)
; þ interruptable calculation, may restart with any legal list! (P)
; þ full 32 bit calculus, huge numbers compatible (gotta 14 million solutions
;   for 16 queens)     
; þ fully portable 386 32bit routines
; þ 100% ASM of course 
; þ 100% English comments (I would say of course too, but some of my Swiss
;                          friends do not appreciate.)
;                                
; Methods used for faster calculation:
; Note: Except for the pointers displacement method, others are not due to
;       myself. I thank all those who have participated in any way in this
;       software.                
;                                
;  - leftside backtracking       
;          consists of tracking a solution with pseudo positions represented
;          by lists (arrays). Suits very nicely languages like LISP which
;          have a native support for lists.
;          Using inverted lists (leftside add) has made the algorithm much
;          faster, since less complex calculations have to be performed in
;          LISP. This makes little difference in ASM, mostly easier syntax.
;                                
;  - half lists                  
;          the solutions to the queens' problem is totally symmetrical. Thus,
;          the algorithm will calculate half of the problem. The second
;          half is easier to calculate, since there's no need to monitor
;          the end of the calculation especially. The fist list will be
;          created depending on the state of the square, if the number is
;          odd or even. We should start with the square / 2 as the first
;          element anyway. The second must be 1 in case square is even, or
;          square / 2 if odd. (The proof of all this is absolutely trivial.)
;                                                                       
;  - pointers displacement
;          this idea has divided a lot the time of execution and is very
;          simple. Since I represented a list in assembler by a simple string,
;          (cons item (list ...)) is equal to:
;               - allocating a new memory block
;               - writing the item to the block
;               - copying the list to the right of the item
;               - deallocating the previous block
;             ...simply too long!
;          ...has been successfully replaced by displacing the list
;          pointer: in this case decrementing the pointer, then writing
;          the item to the new address is exactly the same thing! Thus no
;          recursive routines to allow adding items to lists have been made.
;          This makes a major difference in speed, for example, to get the
;          first solution with normal arrays for a square of 20 took about
;          8 secs on a average Pentium and less than 2 with the new method.
;                 
; history:        
; Scheme versions: some people and myself...(university of Geneva)
;       end November 1995:
;       - first ordinary lisp (scheme) source
;       - first ordinary working scheme source (backtracking)
;       - leftside add, doubles method instead of lists (lisp), half
;         solutions, discussions on efficiency.
;       - failure to approach the total results function
;         tries of rotating, translating...etc... with lists, some
;         solutions missing...failure to make a faster method.
;       ...meanwhile some PCs worked hard to calculate solutions for 12
;       - first source in ASM, since after 48 hours of calculation,
;         the solution has not been found for 15 queens even with a
;       "super-fast" optimised Scheme method.
;       - first version in ASM...first working version in asm, almost as
;         skeleton of this source, but 16bit.
;       December 1995:
;       01.12.95 : working version in ASM implementing all the powerful
;                  speed optimisation, 32bit version.
;       01.12.95 : (late at night) pointers displacement method
;       02.12.95 : calculation for 15 and 16 queens, pretty fast and easy!
;       - ln(x) function (x is solutions' numbers) grows like kx*ln(x).?!
;       - some other failures to find something concrete.
;         (c) some heads from the facult‚ de Math et Info
;       ...new ASM version updates:
;       04.12.95 : written convert_decimal function to convert string
;                  into 32bit integers
;       05.12.95 : convert to upper-case routine
;       05.12.95 : added new 'm' option to suppress messages
;       05.12.95 : added new efficient routine for parameters' reading
;       06.12.95 : corrected strings read bug: backspace did not destroy 
;                  properly, thus numbers were incorrect.                
;       06.12.95 : added a possibility to start at any point, 'P' option!
;                                                                        
; # in future versions:
;       þ full 3D for solutions' output
;         including shading, free rotation via mouse and/or key moves
;         DOS4GW implemenation for 3D.
;       þ Gravis Ultrasound support (probably sound blaster too:)
;       þ Pentium optimized version
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
                                                                         
                                                                         
.model tiny             ;smallest possible mode -> allow not to bother for
.stack                  ;stack is present:)                              
.code                   ;stacks or memory                                
.386                    ;since solution grow faster than e^x hige numbers
		 	;have to be treated, 32 bit registers mostly used
			;see Scheme (LISP) source for more detail on the 
			;evolution of the solutions' function.           

shrarray macro                          ;pseudo translator to the right
	add     bx,cs:[fill_counter]    ;and to the left
	dec     cs:[displaced_array]    ;= simple memory address displacer
endm

shlarray macro
	inc     cs:[displaced_array]
	dec     cs:[fill_counter]
endm

pushx macro r1, r2, r3, r4, r5, r6, r7, r8      ;that's a usefull macro
	ifnb <r1>                               ;stolen from the source
	push r1                                 ;of a 3D vector engine...
	pushx r2, r3, r4, r5, r6, r7, r8        ;pushx + 8 registers
	endif
endm

popx macro r1, r2, r3, r4, r5, r6, r7, r8
	ifnb <r1>
	pop r1  
	popx r2, r3, r4, r5, r6, r7, r8
	endif
endm

affiche macro message                           ;uses newing proc
	mov     bx,OFFSET message               ;for writing text on screen
	call    newing
endm

org 0000h

total_counter   dd     0              ;total counter of solutions, 2^32 max

        push    cs
        pop     es
        affiche entry_string           ;write some junk text on screen

        call    read_parameters        ;read command line parameters
        cmp     cs:[square],-1         ;is square still illegal
        jne     init_read              ;then ask for it

        affiche entry_junk             ;some text

        mov     bx,offset cs:[search_string]
        call    read_string            ;read string from keyboard
        jc      init_exit              ;if escape, exit
   init_read:
        mov     si,offset cs:[search_string]
        call    convert_decimal        ;translate a max 2 digits string to
        mov     cs:[square],dl
        affiche calculating_for        ;a 16 bit value
        call    write_decimal          ;write_decimal prints a 32 bit value
        call    initialize_array       ;initialize the array for processing
        jc      init_exit
	mov     dx,offset entry_time
	call    td_gettime             ;td_gettime routine, part of asmwiz
	call    main_rotate            ;main calculus
	mov     dx,offset exit_time
	call    td_gettime             ;td_gettime routine, parts from asmwiz
	affiche sentry_time
	affiche entry_time
	affiche sexit_time
	affiche exit_time
        affiche passage_msg
     init_exit:
        xor     ax,ax
        mov     ah,0Ch                 ;clear the buffer
        int     21h                    ;function 0Ch int 21h
	mov     ah,4Ch                 ;terminate the program: no registers
	int     21h                    ;saved or restored, don't care

;±± initialize array  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: either creates a half list depending on the odd? or even? state
;          of the square
;          or if P parameter encounted, prompts for the total to start with
;          and for the values in the list.
;          
; entry  : cs:[square], cs:[prompt]
; exit   : updated array
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
initialize_array proc
        cmp     cs:[prompt],1           ;did we encounter P option?
        jne     ia_normal               ;no, then create generic list
        affiche actual_counter          ;show the counter prompt
        mov     bx,offset search_string ;bx=target string
        mov     cs:[read_limit],11      ;set the limit to 9.9...*10^10
        call    read_string             ;read the string
        jc      ia_carry_out            ;exit on escape
        mov     si,offset search_string ;required for convert, si: str offset
        call    convert_decimal         ;convert to 32 bit decimal
        mov     cs:[total_counter],edx  ;total counter updated
        and     dl,1                    ;and dl with 00000001
        cmp     dl,1                    ;is it odd?
        je      ia_carry                ;if yes, it's illegal
        xor     cx,cx                   ;zero cx
        mov     cl,cs:[square]          ;cl=max items
        cmp     cl,0                    ;is the square 0
        je      ia_normal               ;then do as usual for zero
        mov     ch,1                    ;first asked item
   ia_roll:
        push    cx                      ;keep cx
        affiche enter_value             ;show message for item input
        xor     edx,edx                 ;zero edx
        mov     dl,ch                   ;edx=ch
        call    write_decimal           ;show on screen
        mov     ah,2                    ;show message :
        mov     dl,':'
        int     21h
        mov     dl,' '
        int     21h
        mov     cs:[read_limit],3       ;read limit to max 3 (99)
        mov     bx,offset search_string ;bx points to target offset
        call    read_string             ;read the string
        jc      ia_carry_exit           ;on error, exit
        mov     si,offset search_string ;si to target offset
        call    convert_decimal         ;convert to decimal 32 bit
        pop     cx                      ;restore cx
        jc      ia_carry                ;on error, exit
        cmp     dl,cs:[square]          ;what about addable item?
        ja      ia_carry                ;bigger than square?
        cmp     dl,0
        je      ia_carry                ;equal to zero? , then exit
        mov     cs:[current_left],dl    ;current left will be added
        call    cons                    ;add item
        inc     ch                      ;next item
        dec     cl                      ;decrement total counter
        jnz     ia_roll                 ;restart if not zero

        call    verify_list             ;verify the list
        jnc     ia_carry_ok             ;is it a solution?
        affiche illegal_result          ;nope, show message
        stc                             ;set carry
        ret                             ;exit
   ia_carry_ok:

        affiche warning                 ;show warning
        mov     dl,cs:[show_all]        ;preserve show_all
        push    dx
        mov     cs:[show_all],1
        call    affiche_array           ;show result array      
        pop     dx
        mov     cs:[show_all],dl        ;restore show_all
        mov     edx,cs:[total_counter]
        sub     edx,2                   ;last solution will be reverified
        mov     cs:[total_counter],edx
        clc                             ;remove carry
        ret                             ;return
   ia_carry_exit:
        pop     cx                      ;restore counter
   ia_carry_out:
        stc                             ;set carry
        ret                             ;return
   ia_carry:
        affiche illegal_params          ;show message
        stc                             ;set carry
        ret                             ;return
                                        
   ia_normal:                           ;--- normal processor
        mov     al,cs:[square]          ;ax contains square
        cbw                             ;convert byte to word
	mov     dl,2                    ;ax / dl (could be also done with shr)
        div     dl                      ;ax / 2, remainder in ah
	inc     al                      ;increment array value
	push    ax                      ;keep ax for remainder
	mov     cs:[current_left],al    ;item to add
	call    cons                    ;update the array
	pop     ax                      ;remainder in ah
	cmp     ah,0                    ;if zero, perfectly half with
	jne     no_carry                ; (square square)
	mov     cs:[current_left],1     ;else (square 1) is half
        mov     al,1
   no_carry:
	call    cons                    ;update array
        clc                             ;remove carry flag
        ret                             ;return with success
initialize_array endp

;±± read_parameters ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: creates a string from the command line parameter for square number
;          gets other options, currently:
;          M : show all results
; entry  : none
; exit   : updated strings or variables
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
read_parameters proc
        pushx   ax,bx,cx,dx,si
        cld                             ;clear direction flag
        xor     cx,cx                   ;zero cx
        mov     cl,ds:128               ;read length of command line in cx
        or      cl,cl                   ;no parameters?
        je      no_params               ;then exit
        mov     si,129                  ;first byte of command line
      read_params:
        lodsb                           ;addressed by ds:[si], next param
        cmp     al,' '                  ;is it a space?
        je      next_param              ;then ignore
        call    conv_maj                ;convert to uppercase
   ;--------------------------- all messages (begin)
        cmp     al,'M'                  ;is it M?
        jne     not_messages            ;nope, next
        mov     cs:[show_all],0         ;set show_all
        jmp     next_param              ;next parameter
   ;--------------------------- all messages (end)
     not_messages:
   ;--------------------------- get chess size (begin)
        cmp     al,'0'                  ;is the char integer
        jb      not_square              ;nope, next
        cmp     al,'9'                  ;is the char integer
        ja      not_square              ;nope, next
        mov     di,offset search_string ;target string's offset in [di]
      next_counter:
        cmp     al,' '                  ;is it a space
        je      out_convert             ;then end
        mov     es:[di],al              ;write the char to string
        mov     al,0                    ;zero al
        inc     di                      ;set the end of string
        mov     es:[di],al              ;to zero
        lodsb                           ;next character
        dec     cx                      ;decrement counter
        jz      out_convert             ;if zero, no more params
        jmp     next_counter            ;otherwise next char
      out_convert:                      ;ended writing,
        cmp     cx,0                    ;is counter at zero
        jne     out_nomatter            ;if not, don't worry
        inc     cx                      ;increment if for loop
      out_nomatter:                     ;
        pushx   ds,si,di,es,cx          ;save regs
        push    cs                      ;ds=cs
        pop     ds
        mov     si,offset search_string ;si, offset of target string
        call    convert_decimal         ;convert to decimal
        jc      out_counter             ;on error, next
        cmp     dl,99                   ;is it bigger than 99?
        ja      out_counter             ;exit then
        mov     cs:[square],dl          ;else square=counter
        popx    cx,es,di,si,ds          ;restore regs
        jmp     next_param              ;next parameter
      out_counter:                      
        affiche invalid_count           ;invalid counter
        popx    cx,es,di,si,ds          ;restore regs
        jmp     next_param              ;next parameter
   ;--------------------------- get chess size (end)
   not_square:
        cmp     al,'P'
        jne     rp_not_prompt
        mov     cs:[prompt],1
        jmp     next_param
   rp_not_prompt:

   rp_error:
        affiche invalid_param           ;invalid parameter
        mov     dl,al                   ;write the char to screen
        mov     ah,2
        int     21h
        affiche passage_msg

      rp_next_error:                    ;skip spaces
        lodsb                           ;next char
        dec     cx                      ;decrement counter
        jz      next_param_error        ;if zero, finished
        cmp     al,' '                  ;if space
        jne     rp_next_error           ;then out
        jmp     next_param              ;else next
      next_param_error:
        inc     cx                      ;increment for loop
        jmp     next_param              ;next parameter
   @read_params:                        ;trick for longer jump
        jmp     read_params             ;next parameter
   next_param:
        loop    @read_params            ;next command line char
 no_params:
        push    cs                      ;ds=cs
        pop     ds
        popx    si,dx,cx,bx,ax          ;restore regs
        ret                             ;return successfully or not
read_parameters endp

;±± conv_maj ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: convert a char to uppercase
; entry  : al=char
; exit   : al=uppercase char
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
conv_maj proc
        cmp     al,'a'                  ;is the char less than 'a'
        jb      cm_no_conv              ;then no conversion
        cmp     al,'z'                  ;is the car bigger then 'z'
        ja      cm_no_conv              ;the no conversion
        sub     al,'a'-'A'              ;otherwise, convert
   cm_no_conv:                          ;this is just TOTALLY trivial...
        ret                             
conv_maj endp                           

;±± verify_list       ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: checks a list for duplicate numbers and matching diagonals
; note   : have to check the last added item only, since list has been
;          checked before
; entry  : none
; exit   : carry flag set   : list is inacceptable
;          carry flag clear : list is ok
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
verify_list proc
        cmp     cs:[fill_counter],1             ;the list is correct if it's
	jbe     vl_exit                         ;length is of 1 by definition
        mov     si,cs:[displaced_array]         ;si : offset of the array
        inc     si
	mov     cx,cs:[fill_counter]            ;cx : number of items
        dec     cx                              ;decrease not to check the
	mov     dh,0                            ;very first item, dh to zero
   vl_diag:       
	inc     dh                              ;incremented the column
        lodsb                                   ;al=item from list
	cmp     al,cs:[current_left]            ;if equal to the last item
	je      vl_error                        ;added, incorrect
        mov     dl,cs:[current_left]            ;check for the same diagonal
	add     dl,dh                           ;by adding the displacement
	sub     dl,al                           ;and substracting the item
	jz      vl_error                        ;if zero, incorrect
	mov     dl,cs:[current_left]            ;now the opposite diagonal
	sub     dl,dh                           ;substract the displacement
	sub     dl,al                           ;check if equal
	jz      vl_error                        ;if zero, incorrect
	loop    vl_diag                         ;restart for the next item
   vl_exit:                                     ;till all processed
	clc                                     ;clear carry
	ret                                     ;return
   vl_error:                                    ;error, then
	stc                                     ;set carry
	ret                                     ;return
verify_list endp

;±± cons ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: update the pseudo list with an item
; entry  : cs:[current_left], item to put
; exit   : changed displaceed array, incremented counter
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
cons proc
	inc     cs:[fill_counter]               ;increment the added counter
	shrarray                                ;pseudo move array to right
	mov     al,cs:[current_left]            ;al=item to add (decimal)
	mov     bx,cs:[displaced_array]         ;bx=displaced pointer
	mov     es:[bx],al                      ;write the item to the 
	ret                                     ;displaced address and return
cons endp

;±± backtrace algorithm ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: check and update the list till something decent found
; entry  : none
; exit   : none
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
backtrack proc
  bk_retrack:
	mov     bx,cs:[displaced_array]         ;bx=displaced pointer
	mov     al,es:[bx]                      ;al=last item added
	cmp     al,cs:[square]                  ;is it maximum?
	jne     bk_no_retrack                   ;if not, increment it
	shlarray                                ;remove it
	jmp     bk_retrack                      ;restart
bk_no_retrack:
	inc     al                              ;increment the item
	mov     cs:[current_left],al            ;put it to the add variable
	shlarray                                ;pseudo cut list
	call    cons                            ;update list on leftside
	ret                                     ;return
backtrack endp

;±± main rotation algorithm ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: do the job
; entry  : none
; exit   : none
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
main_rotate proc
	affiche passage_msg                     ;skip a line
	cmp     cs:[square],0                   ;cheat for 1 and 0
	je      mr_exit
	cmp     cs:[square],1
	jne     mr_entry
	inc     cs:[total_counter]              ;as final
	jmp     mr_exit
     mr_entry:
	cmp     cs:[fill_counter],0             ;have we reached the end?
	je      mr_exit                         ;if yes, exit
    mr_not_max:
	call    verify_list                     ;check the list
	jc      mr_invalid                      ;invalid, jump
        cbw                                     ;convert byte to word
	mov     al,cs:[square]                  ;since square < 99, ax= 00|al
	cmp     cs:[fill_counter],ax            ;is ax=list's length
	ja      mr_invalid                      ;is it not, jump
	je      mr_solution                     ;otherwise, a solution!,jump
	mov     cs:[current_left],1             ;next item to add: 1 (trivial)
	call    cons                            ;update the pseudo list
	jmp     mr_entry                        ;rotate the whole thing
   mr_invalid:                                  ;# list is invalid
	call    backtrack                       ;backtrack to a valid array
	jmp     mr_entry                        ;restart
   mr_solution:                                 ;# solution found 
	add     cs:[total_counter],2            ;solutions have mirrors, add 2
        call    affiche_array                   ;write the result
        jc      mr_fast_exit                    ;if yes, exit
	call    backtrack                       ;else backtrace
	jmp     mr_entry                        ;rotate
     mr_exit:                                   ;# finished
	affiche result_msg                      ;solutions found
	mov     edx,cs:[total_counter]          ;edx=solutions' counter
	call    write_decimal                   ;output to screen
	affiche passage_msg                     ;skip a line
	ret                                     ;return
     mr_fast_exit:                              ;# escape pressed
	affiche aborted_msg                     ;aborted message
	mov     edx,cs:[total_counter]          ;edx=till here solutions
	call    write_decimal                   ;write the value
        affiche passage_msg                     ;skip a line
        mov     cs:[show_all],1
        mov     ah,0Ch
        int     21h
        call    affiche_array
	ret                                     ;return
main_rotate endp

;±± write_decimal ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: output a decimal value to the screen              
;   note : routine fully portable for 32 and 16 bit
;          simply replace 32 to 16 bit registers
; entry  : edx, 32 bit integer
; exit   : output to screen
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
write_decimal   proc
	pushx   eax,ecx,edx,esi          ;preseve registers
	mov     eax,edx                  ;eax is my value
	mov     esi,10                   ;will divide by 10 using esi
	xor     ecx,ecx                  ;count of digits placed on stack
   non_zero:
	xor     edx,edx                  ;set upper word of N to 0
	div     esi                      ;calculate N/10 and (N mod 10)
	push    edx                      ;push one digit onto the stack
	inc     ecx                      ;one more digit added
	or      eax,eax                  ;N = 0 yet?
	jne     non_zero                 ;nope, continue
   write_digit_loop:
	pop     edx                      ;get the digits in reverse order
	push    edx                      ;save registers used
	cmp     dl,10                    ;is this nibble <10?
	jae     hex_letter               ;no, convert to a letter
	add     dl,"0"                   ;yes, convert to a digit
	jmp     write_digit              ;now write this character
   hex_letter:
	add     dl,"A"-10                ;convert to hex letter
   write_digit:
	 pushx  eax,edx                  ;preseve registers
	 mov    ah,2                     ;write char to screen
	 int    21h                      ;function 2h of int 21       
	 popx   edx,eax                  ;restore registers
	 pop    edx                      ;restore old value of edx
	 loop   write_digit_loop         ;restart with the whole thing
   end_decimal:                          ;# finished
	 popx   esi,edx,ecx,eax          ;restore registers
	 ret                             ;return
write_decimal   endp

;±± affiche_array ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: write any found array to the screen
; entry  : none
; exit   : screen output
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
affiche_array proc
        xor     ax,ax                    ;ax to zero
	mov     ah,1                     ;function 1h int 16h
	int     16h                      ;check for key in the buffer
        jz      afa_exit                 ;if empty, don't bother
        cmp     al,1Bh                   ;if ESCAPE, quit
	je      afa_quit
        mov     ah,0Ch                   ;clear the buffer
	int     21h                      ;function 0Ch int 21h
   aa_show:
	mov     dl,'('                   ;if a key has been pressed, write
	mov     ah,2                     ;a solution on the screen, otherwise
	int     21h                      ;useless to lose time
	mov     edx,cs:[total_counter]   ;edx=total counter
	call    write_decimal            ;write the number
	mov     dl,')'                   ;parenthesis
	int     21h
	mov     dl,' '                   ;space
	int     21h
	mov     bx,cs:[displaced_array]  ;get the displaced address of the
	mov     cx,cs:[fill_counter]     ;array, loop will be length times
        add     bx,cs:[fill_counter]
   aa_next:
        dec     bx
	pushx   ecx,edx                  ;preserve vital regs
        xor     edx,edx                  ;zero edx
	mov     dl,es:[bx]               ;get the first item
	call    write_decimal            ;write it to screen
	popx    edx,ecx                  ;restore vital regs
	mov     dl,' '                   ;space
	mov     ah,2
	int     21h
	loop    aa_next                  ;loop if not finished
        affiche passage_msg              ;next line
        clc
        ret
   afa_exit:                             ;# exit
        cmp     cs:[show_all],1
        je      aa_show
	clc
	ret                              ;return
   afa_quit:
	stc
	ret
affiche_array endp

;±± read a string ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: read a string from the keyboard
; entry  : bx=offset of target string, cs:[read_limit] set to maxlength
; exit   : string in search_string
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
read_string proc
	pushx   ax,bx,cx,dx             ;save vital regs
	mov     cs:[search_counter],0   ;items counter to zero
    rs_next_char:                       ;char to reverse order
	xor     ax,ax                   ;zero ax
	mov     ah,0Ch                  ;clear buffer
	int     21h                     ;0Ch int 21h
	xor     ax,ax                   ;get next key
	int     16h                     ;function 00h int 16h
	cmp     al,0Dh                  ;enter?
	je      rs_end_saisie           ;, finished
	cmp     al,8                    ;backspace?
	je      rs_erase                ;, process
	cmp     al,1Bh                  ;escape, finished
	je      rs_end_esc
	cmp     al,'0'                  ;other than numeric forbidden 
	jb      rs_next_char            ;for reines
	cmp     al,'9'
	ja      rs_next_char            ;loop

	inc     cs:[search_counter]     ;key is valid, increment the counter
        mov     cl,cs:[read_limit]
        cmp     cs:[search_counter],cl   ;max of 2, if you ever get a 
	je      rs_end_beep             ;solution for more than 100, please
					;send me a mail
	push    ax                      ;store the character at
	mov     es:[bx],al              ;es:[bx] = pointer to the string
        mov     al,0
        mov     es:[bx+1],al
	pop     ax
        inc     bx                      ;the purpose is to get inverted 
	mov     ah,2                    ;string
	mov     dl,al                   ;write the char on the screen
	int     21h
	jmp     rs_next_char            ;next char
    rs_erase:                           ;# backspace
	cmp     cs:[search_counter],0   ;are we at the very beginning
	je      rs_next_char            ;then do nothing
	pushx   ax,bx,dx                ;save regs
	mov     ah,3                    ;get the current cursor position
	mov     bh,0                    ;for screen page 0
	int     10h                     ;bh=page, 3h int 10h, out dx=posit.
	mov     ah,2                    ;set the cursor position
	dec     dl                      ;decrement the column
	int     10h                     ;dl=column, dh=row, 2h int 10h
	mov     ah,2                    ;output a space via int 21h
	mov     dl,' '                  ;dl=char
	int     21h                     ;2h int 21h
	mov     ah,3                    ;get the current cursor position
	mov     bh,0                    ;for screen page 0
	int     10h                     ;bh=page, 3h int 10h, out dx=posit.
	mov     ah,2                    ;set the cursor position
	dec     dl                      ;decrement the column
	int     10h                     ;dl=column, dh=row, 2h int 10h
	popx    dx,bx,ax                ;restore vital regs
	dec     cs:[search_counter]     ;decrement the counter
        dec     bx                      ;decrement the pointer
        mov     cl,0
        mov     es:[bx],cl
	jmp     rs_next_char            ;next char
    rs_end_beep:                        ;invalid action
	dec     cs:[search_counter]     ;next char
	jmp     rs_next_char
    rs_end_saisie:                      ;finished
        cmp     cs:[search_counter],0
        je      rs_end_esc
        clc                             ;clear carry flag
    rs_end:                             ;exit
	popx    dx,cx,bx,ax             ;restore vital regs
	ret
    rs_end_esc:                         ;set carry flag if ESCAPE pressed
	stc                             ;finish
	jmp     rs_end
read_string endp

;±± newing routine±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: write a text to the screen
; entry  : bx=offset to the string 
; exit   : none
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
newing proc
	pushx   ax,bx,dx                ;save regs
   newing_next:
	mov     dl,es:[bx]              ;dl=char
	cmp     dl,0                    ;is zero
	je      newing_exit             ;,exit
	inc     bx                      ;next pointer
	mov     ah,2                    ;write to screen
	int     21h     
	jmp     newing_next             ;next char
   newing_exit:
	popx    dx,bx,ax                ;restore regs
	ret                             ;return
newing endp

;±± time   routine±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: get time as ASCIIZ in DS:DX
; entry  : DS:DX
; exit   : none
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
td_gettime    proc     
	      pushx     ax,bx,cx,dx,si,ds ;save regs
	      mov       ax,cs             ;
	      mov       ds,ax             ;ds=cs
	      mov       si,dx             ;si=dx
	      mov       ah,2Ch            ;get the time
	      int       21h               ;
	      mov       hrmin,cx          ;save hour and minute
	      mov       cs:[seconds],dh   ;save seconds
	      mov       cs:[decimals],dl  ;save decimals
	      mov       bl,":"            ;assume ":" for time seperator
	      pop       ds                ;restore user's DS
	      mov       ax,cs:hrmin       ;ax=hour|minute
	      mov       cl,al             ;al,cl=hours,minute
	      mov       al,ah             
	      call      conv2dec2         ;convert to ASCIIZ
	      mov       [si],bl           ;separator
	      inc       si                ;update address
	      mov       al,cl             ;al=hours
	      call      conv2dec2         ;convert to ASCIIZ
	      mov       al,':'            ;separator
	      mov       [si],al           ;write
	      inc       si                ;update address
	      mov       al,cs:[seconds]   ;seconds
	      call      conv2dec2         ;convert
	      mov       al,''''           ;separator
	      mov       [si],al           ;write
	      inc       si                ;update address
	      mov       al,cs:[decimals]  ;hundredth of sec
	      call      conv2dec2         ;convert and write
	      mov byte ptr   [si],0       ;terminate the string
	      popx   si,dx,cx,bx,ax       ;retore regs
	      ret
td_gettime    endp

;±± time sub-routine ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: convert any digit into two-char with 0 if needed
; entry  : si = target address for the double
; exit   : si = new address
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
conv2dec2     proc
	      aam                       ;ascii adjust for multiplication
	      add            ax,"00"    ;add
	      xchg           al,ah      ;exchange high and low byte
	      mov            [si],ax    ;invert result to target
	      add            si,2       ;update pointer
	      ret                       ;return
conv2dec2     endp
         
;± convert a ASCIIZ string to a 32 bit number ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: convert a ASCIIZ string to a 32 bit unsigned integer
;          (c) Daniel Doubrovkine, 04.12.95
; entry  : ds:[si] : address of the ASCIIZ string
; exit   : edx     : 32 bit value, no carry
;          if error: edx=-1, carry flag set
; note   : the limit id not considered, false results come out from
;        : more than 2^32 (about 10^10)
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
convert_decimal proc
        xor     cx,cx                   ;reset the counter to zero
        cld                             ;direction flag forward
   cd_nend:
        lodsb                           ;get first char in ASCIIZ string
        inc     cx                      ;addressed by ds:[si], inrement count
        cmp     al,0                    ;is it the end of the ASCIIZ string?
        jne     cd_nend                 ;if not continue to count
        dec     cx                      ;remove the 0 from count
        sub     si,2                    ;point to last char in string
        mov     ebx,1                   ;set the multiplicator to 10^0
        xor     edx,edx                 ;set the count to zero
        push    edx                     ;store the count value
        std                             ;set the direction flag to backwards
    cd_next:
        xor     eax,eax                 ;clear eax
        lodsb                           ;next char in al
        cmp     al,'9'                  ;check for non-integer expressions
        ja      cd_error                ;if error, exit
        cmp     al,'0'                  ;check for non-integer expressions
        jb      cd_error                ;if error, exit
        sub     al,'0'                  ;convert to decimal
        mul     ebx                     ;* 10^n 32bit multiplicator
        pop     edx                     ;restore counter
        add     edx,eax                 ;add new value to counter
        push    edx                     ;store the counter again
        mov     edx,ebx                 ;edx=new value to multiplier   
        mov     eax,10d                 ;eax=10                         
        mul     edx                     ;edx*eax -> edx:eax
        mov     ebx,eax                 ;new multiplier, high 32bit value is
                                        ;not taken in consideration, sorry,
                                        ;but too complicated to make bigger
                                        ;than 2^32, very approx 10^10
        loop    cd_next                 ;get next char if not finished
        pop     edx                     ;restore the counter to edx
        clc                             ;remove carry flag, everything ok
        cld                             ;direction flag must be cleared, VITAL
        ret                             ;returns edx, the integer value
    cd_error:
        pop     edx                     ;restore counter value
        mov     edx,-1                  ;make it -1
        stc
        cld                             ;set carry flag
        ret                             ;direction flag must be cleared, VITAL
convert_decimal endp

show_all        db      1
hrmin           dw      ?                      ;hour maintaince
pre_array       db      100 dup (0)            ;pre array for displacement
array           db      0                      ;initial array pointer
post_array      db      100 dup (0)            ;post array for displacement
search_counter  db      0                      ;counter for string read
search_string   db      100 dup (0)            ;string read
fill_counter    dw      0                      ;total items
current_left    db      1                      ;item to add
square          db      -1                      ;8 bit square
displaced_array dw      offset array           ;initial displacement address
entry_string    db      'Backtracking Queens - (c) Daniel Doubrovkine - 1995 - uniGE.ch - 100% ASM!',10,13
                db      'SUPER FAST! (v. 1.13.00 06/12/95) email welcome: dblock@infomaniak.ch',10,13,0
entry_junk      db      10,13,'This little program calculates all the possibilities to place queens on a',10,13
                db      'chess board without one atacking another.',10,13
                db      'REINES uses backtracking methods, combined to a very efficient technique which',10,13
                db      'consists of moving memory pointers rather than translating lists.',10,13
                db      'Note: Only half of the solutions will be shown since other are symetric.',10,13
                db      'Options:',10,13
                db      '      M: suppress results'' output (second symetric half) (faster calculation)',10,13
                db      '      P: start at any point! (You will be prompted for initial values.)',10,13
                db      '      n: any integer number < 99 for chess board size',10,13,10
                db      '[ESC aborts] Please the chess board size: ',0
calculating_for db      10,13,'Press a key to see the latest result. [ESC] Aborts after the next solution.'
                db      10,13,'Calculating for a chess board of ',0
result_msg      db      'This is the total number of solutions: ',0
passage_msg     db      10,13,0
aborted_msg     db      'Aborted by user at solution no. ',0
sentry_time     db      'Real calculation entry time: ',0
sexit_time      db      10,13,'Real calculation exit  time: ',0
entry_time      db      20 dup (0)
exit_time       db      20 dup (0)
seconds         db      0
decimals        db      0
illegal_params  db      10,10,13,'Invalid parameter specified!',10,13,0
invalid_param   db      10,13,'Invalid parameter specified: ',0
invalid_count   db      10,13,'Invalid counter for chess board size!',10,13,0
read_limit      db      3
prompt          db      0
actual_counter  db      10,13,'Please enter the last result (positive even): ',0
enter_value     db      10,13,'Enter value for item: ',0
warning         db      10,10,13,'Okay, the following list and total have been taken in consideration.',10,13
                db      'Calculation will start with it, but be carefull, if the initial list and/or the',10,13
                db      'initial total are incorrect, then the result will not mean anything!',10,13
                db      'Backtracking will start with: ',0
illegal_result  db      10,13,'The values you have entered contain duplicate or illegal items and cannot be',10,13
                db      'a solution for the queens'' algorithm.',10,13,0

end
