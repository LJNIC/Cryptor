(= title "Cryptor")
(= width 15)
(= height 15)

(func create-unit (x y type extra)
    (table (append (list 'x x 'y y 'type type) extra)))
(func create-rook (x y)
    (create-unit x y 'rook (list 'future-pos (vec-mk x y))))

(= level-1 (table (list
    'units (list (create-unit 3 7 'base))
    'goals (list (create-unit 7 7 'base)))))
(= level-2 (table (list
    'units (list (create-unit 3 9 'base) (create-unit 3 5 'base))
    'goals (list (create-unit 7 9 'base) (create-unit 7 5 'base)))))
(= level-3 (table (list
    'units (list (create-unit 3 8 'base) (create-unit 5 5 'base))
    'goals (list (create-unit 9 8 'base) (create-unit 9 5 'base))
    'walls (list (vec-mk 7 4) (vec-mk 7 5) (vec-mk 7 6)))))
(= level-4 (table (list
    'units (list (create-rook 3 7))
    'goals (list (create-rook 5 10))
    'walls (list (vec-mk 11 7) (vec-mk 10 3) (vec-mk 4 4) (vec-mk 5 11)))))
(= level-5 (table (list
    'units (list (create-rook 3 7))
    'goals (list (create-rook 9 10))
    'walls (list))))

(= levels (list level-1 level-2 level-3 level-4))

(func load-sprites (index data)
    (let i (* index 7 7)) ; start from "a" offset
    (each (fn (it)
        (poke (+ 0x4040 i) it)
        (++ i)
    ) data))

(load-sprites 1 '(
    ; !
    0 1 1 1 1 1 0
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    1 0 0 0 0 0 1
    0 1 1 1 1 1 0
    ; "
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    0 0 0 1 0 0 0
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    0 0 0 0 0 0 0
    ; #
    1 1 1 1 1 1 1
    1 0 1 0 1 0 1
    1 1 1 0 1 1 1
    1 0 0 0 0 0 1
    1 1 1 0 1 1 1
    1 0 1 0 1 0 1
    1 1 1 1 1 1 1
    ; $
    0 0 0 0 0 0 0
    0 0 0 0 0 0 1
    0 0 0 0 0 1 0
    0 0 0 1 1 1 1
    0 0 0 0 1 1 1
    0 0 0 0 0 1 0
    0 0 0 0 0 0 0
    ; %
    1 1 0 0 0 0 0
    0 0 1 0 0 0 0
    0 0 0 1 0 0 0
    1 0 0 1 0 0 0
    0 0 0 1 0 0 0
    0 0 1 0 0 0 0
    1 1 0 0 0 0 0
))
