; Common Lisp - IA.TP1.29.10.97 - Daniel Doubrovkine - doubrov5@cuimail.unige.ch

(defun fifth-element (x) 
  (car (cddddr x)))

					; ex 2
					; (car (cddr '(a b x)))
					; (caar (cdr (car (cdr '(a (b (x)))))))
					; (car (cdr (caar '(((a x) b)))))
					; (caaar (cdr '(a ((x)))))
					; (cdr (car (cddr '(a b (c . x)))))
					; (/ (- (- 0 b) (sqrt  (- (* b b) (* 4 a c)))) (* 2 a))

(defun racines (a b c)
  (list 
   (/ (- (- b) (sqrt  (- (* b b) (* 4 a c)))) (* 2 a))
   (/ (+ (- b) (sqrt  (- (* b b) (* 4 a c)))) (* 2 a)))
  )

(defun power (x y)
  (cond
   ((> y 0) (* x (power x (- y 1))))
   ((< y 0) (/ 1 (power x (- y))))
   ((= y 0) 1)
   )
  )
  

(defun lraise (slist n)
  (defun lraise-local (slist)
  (cond 
   ((null slist) ())
   ((atom (car slist)) (append (list (power (car slist) n)) (lraise-local (cdr slist))))
   ((listp (car slist)) (append (list (lraise-local (car slist))) (lraise-local (cdr slist))))
   )
  )
  (lraise-local slist)
  )

(defun carres (slist)
  (lraise slist 2)
  )

(defun inverse (slist)
  (cond 
   ((null slist) ())
   ((atom (car slist)) (append (inverse (cdr slist)) (list (car slist))))
   ((listp (car slist)) (append (inverse (cdr slist)) (list (inverse (car slist)))))
   )
  )

(defun nieme (slist n)
  (cond
   ((= n 1) (car slist))
   ((> n 1) (nieme (cdr slist) (- n 1)))
   ((< n 0) nil)
   )
  )
			
