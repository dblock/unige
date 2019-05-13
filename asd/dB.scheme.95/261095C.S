(define (compare num1 num2)
  (if (= num1 num2)
      (writeln num1 "=" num2)
      (writeln num2 "<>" num1))
)

(define (roulette num)
  (compare num (random 10))
)
