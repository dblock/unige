(define (point-fixe function ivalue precision)
  (define (pf_aux last_value)
    (if (> (abs (- last_value (function last_value))) precision)
        (pf_aux (function last_value))
     	last_value)
  )
  (pf_aux ivalue)
)

(define (deriv function dx)
  (lambda (x) (/ (- (function (+ x dx)) (function x)) dx))
)

(define (n-deriv function dx n)
  (if (= n 0)
   function
   (deriv (n-deriv function dx (- n 1)) dx)
  )
)

