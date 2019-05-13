(define (comparer numero-sorti numero)
  (if (= numero-sorti numero)
      (display "gagn‚")
      (display "perdu")
      numero-sorti)

 (define (roulette numero)
   (comparer (random 37) numero-pari))

