(= title "Cryptor")
(= width 15)
(= height 15)

(func create-unit (x y type . extra)
    (table 'x x 'y y 'type type extra))
(func create-rook (x y)
    (table 'x x 'y y 'type 'rook 'future-pos (vec x y)))

(= level-1 (table 
    'units (list (create-unit 3 7 'base))
    'goals (list (create-unit 7 7 'base))))
(= level-2 (table 
    'units (list (create-unit 3 9 'base) (create-unit 3 5 'base))
    'goals (list (create-unit 7 9 'base) (create-unit 7 5 'base))))
(= level-3 (table 
    'units (list (create-unit 3 8 'base) (create-unit 5 5 'base))
    'goals (list (create-unit 9 8 'base) (create-unit 9 5 'base))
    'walls (list (vec 7 4) (vec 7 5) (vec 7 6))))
(= level-4 (table 
    'units (list (create-rook 3 7) (create-rook 4 2) (create-rook 5 5) (create-rook 7 5))
    'goals (list (create-rook 5 10))
    'walls (list (vec 11 7) (vec 10 3) (vec 4 4) (vec 5 11))))
(= level-5 (table 
    'units (list (create-rook 3 7) (create-unit 5 5 'base))
    'goals (list (create-rook 2 3) (create-unit 10 8 'base))
    'walls (list (vec 3 3) (vec 6 7) (vec 10 4) (vec 10 9))))
(= level-6 (table
    'units (list (create-rook 3 7) (create-rook 5 5))
    'goals (list (create-rook 9 10) (create-rook 4 7))
    'walls (list (vec 3 3) (vec 6 7) (vec 10 4) (vec 10 9))))
(= level-7 (table
    'units (list (create-rook 3 7) (create-rook 5 5))
    'goals (list (create-rook 9 10) (create-rook 4 7))
    'walls (list (vec 3 3) (vec 6 7) (vec 10 4) (vec 10 9))))
(print level-4)

(= levels (list level-1 level-2 level-3 level-4 level-5 level-6 level-7))

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

