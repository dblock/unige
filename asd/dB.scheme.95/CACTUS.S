;± Cactus 1.0 - Daniel Doubrovkine - uniGE ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(writeln "CACTUS - awefully simple fractal - v. 1.0")
(writeln "         Daniel Doubrovkine - uniGE - 1995")
(writeln "         email welcome: dblock@infomaniak.ch")

;± cactus main function ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (cactus)
;± cactus main call ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (analyse_param query_list)
  (main (list-ref query_list 6)
        (list-ref query_list 5)
        (list-ref query_list 4)
        (list-ref query_list 3)
        (list-ref query_list 2)
        (list-ref query_list 1)
        (list-ref query_list 0)))
 (define myquery_list ())                       ;create an empty list
 (analyse_param (query_method myquery_list 7))  ;call main function
)

;± draw a triangle with a base <x,y> point, height, base and angle to height±
(define (triangle x y height base angle)
  (line (cons x y) (cons (right_x x height base angle)
			 (right_y y height base angle)))
  (line (cons x y) (cons (left_x x height base angle)
			 (left_y y height base angle)))
  (line (cons  (right_x x height base angle) (right_y y height base angle))
        (cons  (left_x x height base angle) (left_y y height base angle)))
)

;± calculations for new coordinates for an iteration ±±±±±±±±±±±±±±±±±±±±±±±±
(define (left_x x height base angle)
        (+ x (- (* (cos angle) height) (* (sin angle) (/ base 2)))))
(define (left_y y height base angle)
        (+ y (+ (* (sin angle) height) (* (cos angle) (/ base 2)))))
(define (right_x x height base angle)
        (+ x (+ (* (cos angle) height) (* (sin angle) (/ base 2)))))
(define (right_y y height base angle)
        (+ y (- (* (sin angle) height) (* (cos angle) (/ base 2)))))

;± radian conversion for degree values ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (torad angle)
  (define pi 3.14159265358979)
  (* (/ angle 180) pi)
)

;± main calculutation and drawing ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (main new_angle angle base height iters She Sba)
;± press a key in a comprehensive language ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (presskey)
        (%EXECUTE '(PCS-INLINE-BLOCK 5 (#h33 #hC0 #hCD #h16 #hCB))))
  (init-graph)
  (set-world! (cons -640 480) (cons 640 -480))
  (fractal 0 -300 height base She Sba (torad angle) iters new_angle)
  (presskey)
  (close-graph)
)

;± step calculation and drawing ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (fractal x y height base Sh Sb angle n new_angle)
  (cond ((> n 0) (fractal (right_x x height base angle)
                         (right_y y height base angle)
                         (* Sh height) (* Sb base) Sh Sb 
                         ;mathematically correct angle...not very nice:
                         ;(- angle (atan (/ base (* 2 height))) (/ angle 2))
                         (- angle (torad new_angle))
                         (- n 1)
		         new_angle)
                         (if (odd? (random 100))
                                (triangle x y height base angle))
                         (fractal (left_x x height base angle)
                         (left_y y height base angle)
                         (* Sh height) (* Sb base) Sh Sb 
                         ;mathematically correct angle, angle + 15ø is simply nicer.
                         ;(+ angle (atan (/ base (* 2 height))) (/ angle 2))
                         (+ angle (torad new_angle))
                         (- n 1)
			 new_angle)
)))
;--------------------- as asked part for the TP ends here -------------------

;± integer values query method, v. 1.0 (c) ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (query_method query_list query_limit)
  (define (query_read advised max) 
    (query_method 
      (concat query_list 
	      (list (integer_read (read-line) advised max))) 
      (- query_limit 1)
))

 (cond ((= query_limit 0) query_list)
  (else 
   (cond
     ((= query_limit 7) (display "Horizontal shrink    ([ENTER] for 0.8): ") 
	    (query_read 0.8 1))
     ((= query_limit 6) (display "Vertical shrink      ([ENTER] for 0.8): ")
	    (query_read 0.8 1))
     ((= query_limit 5) (display "Number of iterations: ([ENTER] for 10): ")
	    (query_read 10 50))
     ((= query_limit 4) (display "Triangle's height:   ([ENTER] for 180): ")
	    (query_read 180 1000))
     ((= query_limit 3) (display "Triangle's base len:  ([ENTER] for 10): ")
	    (query_read 10 1000))
     ((= query_limit 2) (display "Initial angle:       ([ENTER] for 90ø): ")
	    (query_read 90 360))
     ((= query_limit 1) (display "Rotation angle:      ([ENTER] for 15ø): ")
            (query_read 15 360))
))))

;± read positive delimited numeric value ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
(define (integer_read input defvalue max)
  (cond 
    ((and (number? (string->number input)) 
	  (> (string->number input) 0) 
          (<= (string->number input) max))
     (string->number input))
    ((eq? (string->number input) ()) defvalue)
    ((> (string->number input) max) (display "Out of bounds: ")
                                    (integer_read (read-line) defvalue max))
    (else
      (display "Positive integer (float) required: ")
      (integer_read (read-line) defvalue)
)))

(define (concat x y)			   ;list updater
  (if (null? x)
      y
      (cons (car x) (concat (cdr x) y))))

(writeln "Done compiling - (cactus) to run.")


