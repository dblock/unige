(define (concat x y)
  (if (null? x) y
      (cons (car x) (concat (cdr x) y))))

(define (outfix l operator)
  (cond 
    ((number? (car l))
   (if 
    (eq? (cdr l) '()) 
         (list (car l))
         (concat (list (car l) operator) (outfix (cdr l) operator))
   ))
   (else 
     (write "-> error in expression (mauvaise operande): ")
     (list '?)
   )
  )
)

(define (infixe l)
  (cond
    ((number? (car l)) (write "-> first element is not an operator (mauvaise operateur)"))
    (else 
      (outfix (cdr l) (car l))
    )
  )
)
