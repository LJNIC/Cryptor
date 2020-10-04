; Vector utilities 
(func vec-mk (x y)
    (map-mk (list 'x x 'y y)))

(func vec-add (v1 v2)
    (vec-mk (+ (map-get v1 'x) (map-get v2 'x)) (+ (map-get v1 'y) (map-get v2 'y))))

(func vec-equal (v1 v2)
    (and (is (map-get v1 'x) (map-get v2 'x)) (is (map-get v1 'y) (map-get v2 'y))))