; Vector utilities 
(func vec (x y)
    (table 'x x 'y y))

(func vec-set (v x y)
    (set v 'x x)
    (set v 'y y))

(func vec-add (v1 v2)
    (vec (+ (get v1 'x) (get v2 'x)) (+ (get v1 'y) (get v2 'y))))

(func vec-sub (v1 v2)
    (vec (- (get v1 'x) (get v2 'x)) (- (get v1 'y) (get v2 'y))))

(func vec-mul (v m)
    (vec (* m (get v 'x)) (* m (get v 'y))))

(func vec-equal (v1 v2)
    (and (is (get v1 'x) (get v2 'x)) (is (get v1 'y) (get v2 'y))))

(func vec-norm (v)
    (let x (get v 'x))
    (let y (get v 'y))
    (vec
        (if (is x 0) x (/ x (abs x)))
        (if (is y 0) y (/ y (abs y)))))
    
