;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;first real prog in scheme...calculates Viete square roots ...
;Daniel Doubrovkine - Universit‚ de GenŠve - 02/11/95
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

(writeln "(VIETE) - Daniel Doubrovkine - uniGE - 1995 - All Rights Reserved")
(writeln "          simply call (viete), email welcome: dblock@infomaniak.ch")

;±± silly definitions ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(writeln "Compiling general definitions.")

;call to the viete_calculus function with 3 read calls to read a,b c.
(define (viete)
    (writeln "ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ")
    (writeln "        [Daniel Doubrovkine][UNIGE] Root Calculation (c) Mr. Viete 1593     ")
    (writeln "                 make whatever you like out of this!    (02.11.95)          ")
    (writeln "ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ")
    (writeln "Please enter numeric coefficients for (a xı + b x + c = 0) ENTER to validate.")
    (viete_calculus (read) (read) (read))
)

;(get-char) in a normal language just for a try for inline assembly
(define (presskey) 
  ;push ax        0x50
  ;xor ax,ax      0x33 0xC0 
  ;int 0x16       0xCD 0x16
  ;pop ax         0x58
  ;retf           0xCB
  (display " ")   ;fixup for define bug...since without this, presskey 
		  ;bahaves very strangely.
  (%EXECUTE '(PCS-INLINE-BLOCK 7 (#h50 #h33 #hc0 #hCD #h16 #h58 #hCB)))
  ;note for the future: an assembler routine should return to scheme by a
  ;retf...thus 0xCB should be the last byte in the sequence.
  ;registers have actually no reason to be stored...but it's safer anyway.
)

;determ in R
(define (det a b c) (- (Expt b 2) (* 4 a c))) 
;positive determ for complex calculations
(define (complex_det a b c) (/ (- 0 (det a b c)) (* 4 (expt a 2))))
;both real solutions
(define (x1 a b c) (/ (+ (- 0 b) (Sqrt (det a b c))) (* 2 a)))
(define (x2 a b c) (/ (- (- 0 b) (Sqrt (det a b c))) (* 2 a)))
;complex solutions: one is ...+iûdet and the other is ...-iûdet
(define (compleXc a b c) 
  (display "   x1:= ")
  (display (/ (- 0 b) (* 2 a)))
  (display "+i*")
  (display (Sqrt (complex_det a b c)))
  (writeln " (" (- 0 b) "/" (* 2 a) "+iû" (complex_det a b c) ")")

  (display "   x2:= ")
  (display (/ (- 0 b) (* 2 a)))
  (display "-i*")
  (display (Sqrt (complex_det a b c)))
  (writeln " (" (- 0 b) "/" (* 2 a) "-iû" (complex_det a b c) ")")
)

;verify for the correct type of constants and call the main function
(define (viete_calculus a b c)
  (cond
    ((and (= a 0) (= b 0) (= c 0)) (Writeln "Undefined function, nothing to do."))
    ((and (= a 0) (= b 0) (<> c 0)) (Writeln "Undefined function, inequality in constants."))
    ((cond
       ((and (number? a) (number? b) (number? c)) (viete_real_calculus a b c))
       ((not (and (number? a) (number? b) (number? c))) (writeln "Invalid input."))
     ))))

;±± main-group functions ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(writeln "Compiling main-group function.")
;main calculation function
(define (viete_real_calculus a b c)
  (init-graph)                   ;init graphics mode and set the required limits
  (set-world! (cons (left_limit a b c) (top_limit a b c)) 
	      (cons (right_limit a b c) (bottom_limit a b c)))
  (split-screen 20)		 ;make the text port larger than 3
  (display "Init Function: 0==")
  ;write the formula entirely to the screen truncating zeros and ones
  ;treat the a parameter 
  (cond
    ((or (< a -1) (> a 1)) (display a) (display "xı"))
    ((= a -1) (display "-xı"))
    ((or (and (> a -1) (< a 0)) (and (> a 0) (< a 1))) (display a) (display "xı"))
    ((= a 1) (display "xı"))
  )
  ;treat the b parameter
  (cond
    ((< b 0) (display "-"))
    ((and (<> a 0) (> b 0)) (display "+"))
  )

  (cond
    ((> b 1) (display b) (display "x"))
    ((< b -1) (display (- 0 b)) (display "x"))
    ((= b -1) (display "x"))
    ((and (> b 0) (< b 1)) (display b) (display "x"))
    ((and (> b -1) (< b 0)) (display (- 0 b)) (display "x"))
    ((= b 1) (display "x"))
  )
  ;treat the c parameter
  (cond
    ((> c 0) (display "+"))
  )

  (cond
     ((<> c 0) (writeln c))
  )
  
  ;we now have a nice formula on the screen:)
  ;find roots
  ;check if a is zero -> avoid division by zero message
  (cond
   ((= a 0) (newline) (writeln "This function is too simple!"))
   ((<> a 0) (display "Determinant equals -> ")
             (writeln (det a b c))))
  ;find solutions for the equation
  (cond 
    ((= a 0) (writeln "  -> x:=" (/ (- 0 c) b)))
    ((< (det a b c) 0) (writeln "2 Complex Solutions -> ") (compleXc a b c))
    ((> (det a b c) 0) (writeln "2 Real Solutions -> x1:= " (x1 a b c) " x2:= " (x2 a b c)))
    ((= (det a b c) 0) (writeln "1 Real Solution -> x1:= " (x1 a b c)))
  )

    ;recalculate and output parabol base and plot limits
    (newline)
    (cond 
      ((<> a 0) (writeln "Base of parabol at: x:=" (base_x a b c) " y:=" (base_y a b c)))
    )
    (writeln "Respectif plot limits: ")
    (writeln " top:    " (top_limit a b c))
    (writeln " left:   " (left_limit a b c))
    (writeln " right:  " (right_limit a b c))
    (writeln " bottom: " (bottom_limit a b c))
    (writeln "Press any key to exit as plot has been completed...")
    ;plot the function on the screen
       (draw_function a b c)

)

;±± function plotting (second and first degree) ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(writeln "Compiling plot functions.")
;this function calculates y=f(x) for a known x and f: 2nd or 1st degree
;polynomial we've been looking roots for.
(define (funct x_value a b c) (+ (* a (* x_value x_value)) (* b x_value) c))

(define (draw_function a b c)
  (set-color 8)
  ;initialize orthogonal vectors (base)
  (line (cons (left_limit a b c) 0) (cons (right_limit a b c) 0))
  (line (cons 0 (top_limit a b c)) (cons 0 (bottom_limit a b c)))
  (set-color 15)
  ;starting point for the plot
  (move-to (cons (left_limit a b c) (funct (left_limit a b c) a b c)))
  ;call the pseudo-for routine...while emulation by an iterated function
  (cond 
    ((<> a 0) (pseudo_for (left_limit a b c) (right_limit a b c) step a b c))
    ((= a 0) (line-to (cons (right_limit a b c) (funct (right_limit a b c) a b c))))
  )
  (presskey)
  (close-graph)
  ;end the graph mode after getting a key
)

;draw the polynomial function by reiterating from left_limit to right_limit:
;which is a pseudo C routine for(begin@=0;begin@<=end@;begin++){} function
(define (pseudo_for begin@ end@ increment a b c)
  ;line-to is nicer, putpixel can avoid overprinting the text
  (line-to (cons begin@ (funct begin@ a b c)))
  ;(if (<> (get-pixel (cons begin@ (funct begin@ a b c))) 7)
  ;(put-pixel (cons begin@ (funct begin@ a b c)) 15))
  (if (< begin@ end@)
      (pseudo_for (+ begin@ increment) end@ increment a b c)
  )
)

;functions for calculating the bases of the parabol
;the derived square function at the desired point is nil
(define (base_x a b c) (/ (- 0 b) (* 2 a)))
(define (base_y a b c) (funct (base_x a b c) a b c))

;definitions for screen limits for function plotting, based
;on the calculation of the base parabol point through the usual derive method.
;all four limits are extended for convenience.
;all four limits depend also from the degree of the function
(define (left_limit a b c) 
  (cond
  ((<> a 0) (- (- (base_x a b c) (abs(base_y a b c))) extent))
  ((= a 0) (- 0 (- (/ (- 0 c) b)) 10))
))

(define (right_limit a b c) 
  (cond
  ((<> a 0) (+ (+ (base_x a b c) (abs(base_y a b c))) extent))
  ((= a 0) (+ (/ (- 0 c) b)) 10)
))

;top and bottom conditioned limits are necessary because of the difference
;between the parabol orient.
(define (top_limit a b c)
  (cond
  ((> a 0) (+ (+ (base_y a b c) (* 2 (abs(base_y a b c)))) extent))
  ((< a 0) (+ (base_y a b c) 1))
  ((= a 0) (+ (/ (- 0 c) b) 10))
  ))

(define (bottom_limit a b c) 
  (cond
    ((> a 0) (- (base_y a b c) extent))
    ((< a 0) (- (base_y a b c) (* 2 (abs(base_y a b c))) extent))
    ((= a 0) (- 0 (+ (/ (- 0 c) b)) 10))
  )
)

(define extent 1)       ;default extention for graphic's limits
(define step .001)      ;default reiteration step for function plotting

(writeln "Done compiling...please use (viete) function.")


