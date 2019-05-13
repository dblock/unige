(define (faire-pile) '())

(define (push pile nombre)
  (if 
   (number? nombre)
   (cons nombre pile)
   (write "La pile ne peut contenir que des nombres...")
  )
)

(define (top pile)
  (car pile))

(define (pop pile)
  (cdr pile))

(define (division pile)
  (cons
   (quotient (top (pop pile)) (top pile))
   (cons
     (remainder (top (pop pile)) (top pile))
     (pop (pop pile))
     )
   )
)


(define (try n1 n2 n3 n4)
  (division (push (push (push (push (faire-pile) n1) n2) n3) n4))
)
