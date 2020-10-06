(= title "Cryptor")
(= width 15)
(= height 15)

(func create-unit (x y type)
    (map-mk (list 'x x 'y y 'type type)))

(= level-1 (map-mk (list
    'units (list (create-unit 3 7 'base))
    'goals (list (vec-mk 7 7)))))
(= level-2 (map-mk (list
    'units (list (create-unit 3 9 'base) (create-unit 3 5 'base))
    'goals (list (vec-mk 7 9) (vec-mk 7 5)))))
(= level-3 (map-mk (list
    'units (list (create-unit 3 8 'base) (create-unit 5 5 'base))
    'goals (list (vec-mk 9 8) (vec-mk 9 5))
    'walls (list (vec-mk 7 4) (vec-mk 7 5) (vec-mk 7 6)))))

(= levels (list level-1 level-2 level-3))

(func load-sprites (index data)
    (let i (* index 7 7)) ; start from "a" offset
    (each (fn (it)
        (poke (+ 0x4040 i) it)
        (++ i)
    ) data))

(load-sprites 1 '(
    ; b
    0 1 1 1 1 1 0
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    0 1 1 1 1 1 0
    ; c
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    0 0 0 1 0 0 0
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
))

