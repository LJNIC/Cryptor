; Vector utilities 
(= add-vec (fn (v1 v2)
    (cons (+ (car v1) (car v2)) (+ (cdr v1) (cdr v2)))
))

(= vec-equal (fn (v1 v2)
    (and (is (car v1) (car v2)) (is (cdr v1) (cdr v2)))
))