;TP 4 : Les reines
;   ... par Stancu Mihai Radu 

; L' algorithme qu'on utilise pour pour resoudre ce probleme est l'algorithme 
;du "back-tracking". L'essentiel de ce algorithme est d'essayer toutes les 
;possibilit‚s d'un certain pas et de reculer d'un par si on n'a plus de 
;possibilit‚s. Un modul g‚n‚ral de "back-tracking" peut-etre le suivant:
;           k:=1
;           (init k)
;           while (k<>0) do begin
;             repeat
;               if (succ?) and (valid?) then
;                   if (k=n) then begin
;                               (print)
;                               k:= k-1                        
;                               end
;                             else 
;                               begin
;                               k:=k+1
;                               (init k)
;                               end {else}
;                    else st[k]:=(succ st[k])
;               until not (succ?)
;               k:= k-1
;               end.
;
;  o—  k    est la position dans la liste (st)
;     (succ?) est une fonction bouleene qui retourne #T ssi il y a un 
;             successeur dans la liste … la position k
;     (valid?) est une fonction bouleene qui retourne #T ssi le succeseur
;             est valid 
;     (init k) initialise la liste … la position k
;     (print) est la procedure d'affichage


;en notre cas on a:
;     (succ?) == (<= y 	n)
;     (valid?) == (valid? list k no-el)
;     (print) == (print list k)
;     (init) == (y -> 1)
;     cont est un compteur qui … la fin sera egal avec le nombre des solutions


(define (reines n)

  (define (print list k) ; procedure d'affichage
    (cond ((> k 0) 
	   (print (cdr list) (- k 1))
	 ;  (display k)
;	    (display "," )
	   (display (car list))(display " ") 
;	    (print (cdr list) (- k 1))
	  )
    )
  )

  (define (valid? list y k no-el)
    (if (= no-el 0) 
	#t
	(cond ((= y (car list)) ())
	      ((= (- k no-el) (- (car list) y)) ())
	      ((= (- no-el k) (- (car list) y)) ())
	      (else (valid? (cdr list) y k (- no-el 1)))
	)
    )
  )

  (define (back-tracking list y k cont)
   ; (writeln list y k)
    (if (<> k 0)
	(if (<= y n)
	    (cond ((valid? list y k (- k 1)) 
		   (cond 
		      ((< k n) (back-tracking (cons y list) 1 (+ k 1) cont))
		      (else 
			(display "(")
			(display (+ 1 cont))
			(display ") ")
			(print (cons y list) n) (writeln) (back-tracking (cdr list)
					    (+ 1 (car list)) (- k 1) (1+ cont)))
		   ))
		  (else (back-tracking list (+ 1 y) k cont))
	    )
	    (back-tracking (cdr list) (+ 1 (car list)) (- k 1) cont)
	)
	(writeln cont)
    )
  )

(back-tracking (cons 0 0) 1 1 0)

); end reines






