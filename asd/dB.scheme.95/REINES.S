;±± Reines (v. 1.0) - Daniel Doubrovkine - uniGE.ch ±±±±±±±±±±±±±±±±±±±±±±±±±
;--- write acknoledgements to the screen
(writeln "(reines) [v.1.00 / 26.11.95] - Daniel Doubrovkine - uniGE.ch")
(writeln "                   email welcome: dblock@infomaniak.ch")
(writeln "                   backtracking method used, distribute freely.")

;±±±±±±±±±± (reines) : the director ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: read an integer value from user
;          call the required calculation
; entry: none
;  exit: none
; local definitions:
;    (integer_read input defvalue max)   : read a numeric value
;    (check_and_rotate_sub liste square) : reines backtrack calculation
;        (draw_frame)  	                 : draw the chess board frame
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

(define enum 0) ;define a counter for solutions
(define (reines)
 ;±±±±±±±±±± (integer_read) ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
 ; purpose: read a delimited positive numeric value
 ; entry: string (input), default value (defvalue), maximum limit (max)
 ;  exit: acceptable numeric value
 ; local definitions: none
 ;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  (define (integer_read input defvalue max)
   (cond 
    ;---- is the entry numeric at all?
    ((not (number? (string->number input))) 
     ;---- if not, rotate the integer_read function
     (display "Non-numeric value, positive integer required: ")
     (integer_read (read-line) defvalue max))
    ;---- is the entry positive? (> 0)
    ;     is the entry in the desired limit (<= max)
    ;     is the entry integer? (ceiling = floor)
    ;	  return the input value
    ((and (> (string->number input) 0) 
          (<= (string->number input) max)
	  (= (ceiling (string->number input)) (floor (string->number input))))
     (string->number input))
    ;---- emptry string? return default value
    ((eq? (string->number input) ()) 
     (writeln "Default value used: " defvalue) defvalue)
    ;---- value > maximum? rotate the integer_read function
    ((> (string->number input) max) 
     (display "The grouth of (reines) is simply vertical! Don't even think about it: ");
     (integer_read (read-line) defvalue max))
    ;---- any other kind of error? rotate the (integer_read) function.
    (else
      (display "Positive integer required: ")
      (integer_read (read-line) defvalue max)
)))

 ;±±±±±±±±±± (check_and_rotate_sub) ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
 ; purpose: preset all necessary for calculation
 ; entry: liste, chess board size (square)
 ;  exit: none
 ; local definitions:
 ;              (draw_frame)    : draw a chess board frame
 ;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  (define (check_and_rotate_sub liste square)
  ;±±±±±±±±±± (draw_frame) ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  ; purpose: draw a chess board frame
  ; entry: none
  ;  exit: none
  ; local definitions: none
  ;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
   (define (draw_frame)
    ;--- set color to bright white
    (set-color 15)
    ;--- draw the frame rectangle
    (rectangle (cons (- (/ (- 1280 824) 2) 5)
	      (- (/ (- 1024 824) 2) 5))
        (cons (+ (* square (/ 824 square)) (/ (- 1280 824) 2) 5)
	      (+ (* square (/ 824 square)) (/ (- 1024 824) 2) 5))))
  ;== body of check_and_rotate_sub ==========================================
    ; initialize the graph mode only if square = 1 or > 3
    ; otherwise, no solutions will be found and it's useless
    (cond ((or (> square 3) (= square 1))
                        ;--- initialize graph
                        (init-graph)
                        ;--- set orthogonal limits
                        (set-world! '(0 . 1024) '(1280 . 0))
                        ;--- draw a proper chess board of square size
                        (chess_board square)
                        ;--- make the split of one line
	                (split-screen 1)
                        ;--- write acknodgements
	                (out-text-xy '(10 . 1000) "Daniel Doubrovkine (c) - uniGE.ch - 1995 - email: dblock@infomaniak.ch")
                        ;--- draw the frame around the chess board
             		(draw_frame)
  ;== execution of the backtrack ==========================================
	   (cond
           ;if the square of 1, then do not calculate, just draw
           ;note: the algorithm is absolutely capable of calculating for (1)
           ;      but big part of code has been removed using this exception
           ;note: set! is used for convenience, not for any required purpose
           ;      for this TP.
	     ((= square 1) (set! enum 1) 
		(chess_list (list 1) 0 square)
  		(presskey (list 1))
	     )
           ;if the square is odd, then we should simply call the backtrack
           ;with the very half of the list, since solutions are symetrical, at
           ;    ((/ square 2) (/ square 2)
                ((odd? square) (check_and_rotate
                       (concat (concat () 
				 (ceiling (/ square 2)))
			         (ceiling (/ square 2)))
			       square))
           ;if the square is even, then the middle calculus will be at
           ;the very middle of the first parameter: (/ square 2)
           ;we increment by 1 to start from the second half.
                ((even? square)
                 (check_and_rotate (concat () (+ (/ square 2) 1)) square))
	   )
                        ;close the graph mode as finished
	                (close-graph))
          ;reentrance for the first condition:
          ;no graph mode has been set, calculation will give 0 solutions
          ;anyway, but it prooves the capability of the algorithm.
          (else
            (check_and_rotate (cons 1 ()) square)))
    ;output the result to the screen
    (writeln "(reines) successfully terminated, " enum " solution(s) found.")
  )
  ;=== the body of (reines) ================================================
  ;set the counter to zero
  (set! enum 0)
  ;ask the user for a numeric value
  (display "Please enter the chess board size: ")
  ;call check_and_rotate_sub with the read parameter
  (check_and_rotate_sub () (integer_read (read-line) 8 30))
)

;±±±±±±±±±± list updaters ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;           (concat list item): append an item to a list	 -> list
;           (remove list)     : remove the last item in the list -> list
;           (last_item list)  : return the last item in the list -> integer
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (concat list1 item)
  ;use the predefined append function
  (append list1 (list item)))

(define (remove list1)
  (if (= (length list1) 1)
      ()
      ;create a new list recursively without the last item
      (cons (car list1) (remove (cdr list1)))
))

(define (last_item list1)
  ;get the last item via predefined list-ref function
  (list-ref list1 (- (length list1) 1)))

;±±±±±±±±±± (is_valid)±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: return true if queens do not attack each-other
; entry: list
; exit: #T / #F
; local definitions: none
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; actually we check the last item only (car liste) (c.f. list item adding)
; since the verification has been completely done for the previous lists
(define (is_valid? liste)
  ;single lists are always true
  (cond ((= (length liste) 1) #T)
	;check the duplicate
	((= (car liste) (last_item liste)) #F)
	;check the diagonal
        ((= (abs (- (last_item liste) (car liste)))
   	    (abs (- (length liste) 1))) #F)
	;else roll with a smaller list
	(else (is_valid? (remove liste)))))

;±±±±±±±±±± backtracking chess method ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: backtrack, check validity
; entry: list, square
; exit: none
; local definitions: 
;        (backtrack)  : get the new list
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (check_and_rotate liste square)
 ;±± (backtrack) ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
 ; purpose: backtrack for the next valid solution
 ; entry: list
 ; exit: new list
 ; local definitions: none
 ;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  (define (backtrack liste)
    ;if empty list, simply return
    (if (null? liste) ()
	;else if last item at maximum, then backtrack to a valid solution
	(if (>= (car liste) square) (backtrack (cdr liste))
   	    ;else if last item still incrementable, add a 1 to the left of list
	    (cons (+ (car liste) 1) (cdr liste)))))
;===== the body of (check_and_rotate) =======================================
  ;---- draw the chess position if list is totally valid
  (cond 
    ;------- check if backtrack has completed all possible solutions, exit then
    ((null? liste) ())
    ;------- if list is valid
    ((is_valid? liste)
     ;if list is at maximum length
	 (cond ((= (length liste) square) 
		;--- draw/clear the chess board
		(chess_board square)
		;--- draw the queens on the chess board
		(chess_list liste 0 square)
		;--- update the counter
		(set! enum (+ enum 1))
		;--- wait for a key
		(presskey liste)
		;--- draw/clear the chess board
		(chess_board square)
		;--- write the symetric solution
		(chess_list (reverse liste) 0 square)
		;--- update the counter
		(set! enum (+ enum 1))
		;--- wait for a key
		(presskey liste)))
     ;--- roll the check function with a new item added to the left
     (check_and_rotate (cons 1 liste) square))
    ;------- if list is invalid or complete, backtrack, then roll
    (else (check_and_rotate (backtrack liste) square))
))

;comments less full since facultatif part
;±±±±±±±±±± draw the chess board ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: backtrack for the next valid solution
; entry: square
; exit: none
; local definitions: (blop) : draws a blop...a queen
;                    (draw_board) : draws the queens, recursion maintaining
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (chess_board square)
  ;-------- draw the chess board square unit with a simple recursion
  ;         blop means nothing at all, I just could not figure a name for it
  (define (blop horizontal vertical)
  (set-fill-style 'solid (if (eq? (even? vertical) (even? horizontal)) 15 0))
   (bar (cons (+ (* (- horizontal 1) (/ 824 square)) (/ (- 1280 824) 2))
	      (+ (* (- vertical 1) (/ 824 square))  (/ (- 1024 824) 2)))
        (cons (+ (* horizontal (/ 824 square)) (/ (- 1280 824) 2))
	      (+ (* vertical (/ 824 square)) (/ (- 1024 824) 2))))
  (if (< vertical square)
      (blop horizontal (+ vertical 1))))
  ;-------- draw a chess boart itself of a certain size
  (define (draw_board horizontal)
   (blop horizontal 1)
   (if (< horizontal square)
   (draw_board (+ horizontal 1))))
  ;============= body: draw the chess board
  (draw_board 1)
)

;±±±±±±±±±± draw the queens position ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; purpose: draw a correct position on the board
; entry: square
; exit: none
; local definitions: none
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (chess_list liste num square)
  ;--------- draw a queen on a defined square
  (define (queen horizontal vertical square)
    (define (center)
       (cons (+ (* (+ horizontal 0.5) (/ 824 square)) (/ (- 1280 824) 2)) 
	     (+ (* (- vertical 0.5) (/ 824 square)) (/ (- 1024 824) 2))))
    (define (radius)
       (/ (- (+ (* (+ horizontal 1) (/ 824 square)) (/ (- 1280 824) 2))
             (+ (* horizontal (/ 824 square)) (/ (- 1280 824) 2))) 3))
    (set-color 4)
    (set-fill-style 'solid 1)
    (fill-ellipse (center) (cons (radius) (radius)))
  )
  ;--------------- draw a "queen"
  (queen num (list-ref liste num) square)
  (if (< (+ num 1) (length liste)) (chess_list liste (+ num 1) square))
)

;----- (get-char) in a human language, does not look for a key in the buffer
;                 like (read-char) (int 0x16.01) but forces to press a key
;may fail sometimes at compile due to a undocumented scheme bug
(define (presskey liste) 
  ;xor ax,ax      0x33 0xC0 
  ;int 0x16       0xCD 0x16
  ;retn           0xCB
  (display liste)
  (display " - (hit a key)")
  (gc)
  (compile (%EXECUTE '(PCS-INLINE-BLOCK 5 (#h33 #hC0 #hCD #h16 #hCB))))
  (newline)
)

;UEH: user error handler. This is a try for trapping errors in Scheme.
;very usefull in this case to get the user's CTRL-BREAK to abort the calculation,
;since the number of solutions grows even faster than the e^x function.
;for more detail cf. Scheeme manual
(set! (access *user-error-handler* user-global-environment)
  (lambda (error-num error-msg irritant sys-error-handler)
       (close-graph)    ;close graph mode (avoids lots of typing)
	(newline)
        (writeln "þ       break::User Error Handler (v 1.0) (from Scheme Manual)")
      	      (cond
		   ((eq? error-num 100) ;ctrl - Q pressed
		    (writeln "þ         UEH::(reines) calculus aborted by user.")
		    (sys-error-handler)
		    ;(scheme-reset)   ;scheme-reset failed to provide secure exit.
		   )
		   (else      
		    (writeln "þ         UEH::provoked by error")
		    (writeln "þ [irritator]::" irritant)
		    (writeln "þ  [debugger]::" error-msg)
   		    (writeln "þ         UEH::pipelining error " error-num " towards " sys-error-handler)
		    (sys-error-handler)
		  ))))

(writeln "Done compiling...(reines) to execute.")

