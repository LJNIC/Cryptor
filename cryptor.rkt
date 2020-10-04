(= state 0)
(= n 0)
(= timer 0)

(= units (list (cons 6 6) (cons 7 9)))
(= goals (list (cons 4 4) (cons 8 8)))
(= walls (list (cons 3 3) (cons 10 4)))

(func clear? (vec)
    (let w (reduce 
        (fn (val it) (if (vec-equal it vec) nil val))
        't
        walls))

    (let u (reduce 
        (fn (val it) (if (vec-equal it vec) nil val))
        't
        units))
    
    (and u w)
)

(func move-unit (unit vec)
    (let pos (add-vec unit vec))
    (if (clear? pos) pos unit)
)

(func move-units (vec)
    (map (fn (el) (move-unit el vec)) units)
)

(func menu ()
    (color 5)
    (put 4 5 "CRYPTOR")
    (color 14)
    (put 5 8 "Press")
    (put 5 9 "Enter")
    (color 14)
    (put 3 6 ".........")
    (color 5)
    (put (+ 3 (% n 9)) 6 ".")
    (++ timer)
    (if (is (% timer 3) 0) (++ n))
)

(func game ()
    ; Draw ground and walls
    (color 14)
    (fill 2 2 (- width 4) (- height 4) "c")
    (each (fn (wall)
        (put (car wall) (cdr wall) "b")
    ) walls)

    ; Draw goals
    (color 10)
    (each (fn (goal)
        (put (car goal) (cdr goal) "X")
    ) goals)

    ; Draw units
    (color 5)
    (each (fn (unit)
        (put (car unit) (cdr unit) "X")
    ) units)

    ; Check goals
    (let count 0)
    (each (fn (unit)
        (each (fn (goal)
            (if (vec-equal unit goal) (++ count))
        ) goals)
    ) units)
    (if (is count (len units)) (quit))
)

(= step (fn ()
    (fill 0 0 width height " ")
    (if (is state 0) (menu)
        (is state 1) (game))
))

(= keydown (fn (k)
    (if (is state 0) (if (is k "return") (= state 1))
        (is state 1) (if (is k "up") (= units (move-units (cons 0 -1)))
                         (is k "down") (= units (move-units (cons 0 1)))
                         (is k "right") (= units (move-units (cons 1 0)))
                         (is k "left") (= units (move-units (cons -1 0)))))
))