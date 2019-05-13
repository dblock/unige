; Examen d'ASD, session Octobre 1995 
; (c) Daniel Doubrovkine - dblock@infomaniak.ch - All Rights Reserved:)

; Question 2

; reecrire en scheme ce qui suit en pascal:

; type point=record
;         x, y: integer;
;         z: real;
;         end;

;      polygone = array[1..MaxSommets] of point;

;      enregistrement = record
;         donnee: ^polygone;
;         suivant: ^enregistrement;
;         end;
;   

; constructs a point, can be evaluated in x, y and z values
; must be called: ((point) x y z) where x,y,z are values
(define (point)
  (lambda (x y z) (list x y z))
)

;constructs a polygon of NbPoints size, can be evaluated in x, y and z values
;call (polygon Nb) to get an empty polygon (function)
;call ((polygon Nb) x y z) to get a filled polygon with x, y, z values for pts.
(define (polygon NbPoints)
  (cond 
     ((> NbPoints 1) 
      (lambda (x y z) 
	(cons ((point) x y z) ((polygon (- NbPoints 1)) x y z))))
     ((= NbPoints 1)
	(lambda (x y z) (list ((point) x y z))))
     (else
        (write "-> empty polygon ")
        (lambda (x y z) '()))
  ))

;constructs a _record_ array of a fixed length, used very much like polygon
;function, 
;to construct a series of 3 record where each contains a polygon of 5 pts, call
;((record 3 5) x y z) where x,y,z must be declared values
(define (record NbItems PolyPts)
  (cond
    ((> NbItems 1)
     (lambda (x y z)
       (cons ((polygon PolyPts) x y z) ((record (- NbItems 1) PolyPts) x y z))))
    ((= NbItems 1)
       (lambda (x y z) (list ((polygon PolyPts) x y z))))
    (else
      (write "-> empty record: ") 
      (lambda (x y z) '()))
  ))


