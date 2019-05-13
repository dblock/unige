(define (point-fixe function ivalue precision)
  (define (pf_aux last_value)
    (if (> (abs (- last_value (function last_value))) precision)
        (pf_aux (function last_value))
     	last_value)
  )
  (pf_aux ivalue)
)

(define (deriv function)
  (lambda (x dx) (/ (- (function (+ x dx)) (function x)) dx))
)

(define (n-deriv function n)
  (if (= n 0)
   function
   (lambda (x dx) (deriv (n-deriv function (- n 1)) x dx))

  )
)


(lambda (x dx) (deriv (lambda (x dx) function) x dx))) x dx))
