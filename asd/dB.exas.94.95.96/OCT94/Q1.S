; ASD Examen ecrit, session d'octobre 1994                             
; (c) Daniel Doubrovkine - 1996 - All Rights Reserved:)                
;                          e-mail welcome: dblock@infomaniak.ch        
; Question 1                                                           

; concat a list with a number (insert a number at the end of a list)
(define (concat x y)
  (if (null? x) y
      (cons (car x) (concat (cdr x) y))))

;infix recursive converter
(define (outfix l operator)
  (cond 

    ;if we have a number on the very left, then we have a correct expression

    ((number? (car l))
     (if 
    
       ;if the list contains only one element, then return it simply

       (eq? (cdr l) '()) 
         (list (car l))

       ;else concat the leftmost number with the result of the recursion
       ;without it

         (concat (list (car l) operator) (outfix (cdr l) operator)))
    )

    ; if we have a list instead of a number

    ;-------------------------------- this is question b) changes
    ((list? (car l))
     (if 

       ;if the infix list contains nothing after the list to explore 
       ;(the list is the last element)

       (eq? (cdr l) '())

        ;if the list is the last element then return what results from the 
        ;recursion

        (list (infixe (car l)))

        ;else concat what results of the recursion with the operator and with
        ;what comes of the simple recursion on the remainder of the list 

        (concat (list (infixe (car l)))
	     (cons operator (outfix (cdr l) operator)))
     )
    )
    ;-----------------------------------------------------------

    ; otherwise we have an error!
    (else 
     (write "-> error in expression (mauvaise operande): ")
     ;return a ? instead of a valid result
     (list '?)
    )
  )
)

(define (infixe l)
  (cond
 
    ;if the first element is a number, that means that the expression is false

    ((number? (car l)) (write "-> first element is not an operator (mauvaise operateur)"))
    (else 
    
      ;otherwise proceed with the exploration
      (outfix (cdr l) (car l))
    )
  )
)



