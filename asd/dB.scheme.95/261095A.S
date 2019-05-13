(define (compare num1 num2)
  (if (= num1 num2)
      (writeln num1 "=" num2)
      (
	if (< num1 num2)
	(writeln num1 "<" num2)
	(writeln num1 ">" num2)
      )
  )
)

(define (roulette num)
  (compare num (random 10))
)
