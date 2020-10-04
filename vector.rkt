; Vector utilities 
(func add-vec (v1 v2)
    (cons (+ (car v1) (car v2)) (+ (cdr v1) (cdr v2))))

(func vec-equal (v1 v2)
    (and (is (car v1) (car v2)) (is (cdr v1) (cdr v2))))