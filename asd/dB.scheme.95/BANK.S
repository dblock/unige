;±± Daniel Doubrovkine (c) 1995 - uniGE - may distribute freely ±±±±±±±±±±±±±

;list of accepted coins and paper money
(define (_value_item n) 
  (list-ref (list 100000 50000 10000 5000 2000 1000 500 100 50 20 10 5 0) n))

;'banquier' function, calls bank and reads the keyboard.
(define (banquier)
  (Writeln "Daniel Doubrovkine (c) uniGE 1995 - email: dblock@infomaniak.ch")
  (Display "Combien avez vous?  ")
  (bank (round (* (read) 100)) 0))

;bank routine:
; - check if the end of the list is reached.
; - if not, use the list item to output the result as wanted, leave the rest
;   for the next iteration.
; - call itself again with the next list item and less money.

(define (bank _money _list_count)

  (cond 
    ((= (_value_item _list_count) 0) 
	  (if (> _money 0) (Writeln "Reste: " _money " cts.")))

  ((<> (_value_item _list_count) 0)

    (cond
      ((< _list_count 6)
       (writeln (truncate (/ _money (_value_item _list_count)))
		" billet(s) de " (/ (_value_item _list_count) 100)" F."))
      ((< _list_count 8)
       (writeln (truncate (/ _money (_value_item _list_count)))
		" piŠce(s) de " (/ (_value_item _list_count) 100) " F"))
      ((< _list_count 12)
       (writeln (truncate (/ _money (_value_item _list_count)))
		" piŠce(s) de " (_value_item _list_count) " cts."))
     )

  (bank (- _money (* (_value_item _list_count)
		     (truncate (/ _money (_value_item _list_count)))))
	(+ _list_count 1))
)))


