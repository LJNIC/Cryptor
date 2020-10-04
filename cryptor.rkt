(= state 0)
(= n 0)
(= timer 0)

(func create-unit (x y type)
    (map-mk (list 'x x 'y y 'type type)))

(= units (list (create-unit 6 6 'base) (create-unit 7 9 'base)))
(= goals (list (vec-mk 4 4) (vec-mk 8 8)))
(= walls (list (vec-mk 3 3) (vec-mk 10 4)))

(func clear? (vec)
    (let w (reduce 
        (fn (val it) (if (vec-equal it vec) nil val))
        't
        walls))

    (let u (reduce 
        (fn (val it) (if (vec-equal it vec) nil val))
        't
        units))
    
    (and u w (not (is (get (map-get vec 'x) (map-get vec 'y)) " "))))

(func move-unit (unit vec)
    (let pos (vec-add unit vec))
    (if (clear? pos) 
        (do 
            (map-set unit 'x (map-get pos 'x))
            (map-set unit 'y (map-get pos 'y)))
        unit))

(func move-units (vec)
    (map (fn (el) (move-unit el vec)) units))

(func menu ()
    (color 5)
    (put 4 5 "CRYPTOR")
    (color 14)
    (put 5 10 "press")
    (put 5 11 "enter")
    (color 14)
    (put 3 6 ".........")
    (color 5)
    (put (+ 3 (% n 9)) 6 ".")
    (++ timer)
    (if (is (% timer 3) 0) (++ n)))

(func game ()
    ; Draw ground and walls
    (color 14)
    (fill 2 2 (- width 4) (- height 4) "c")
    (each (fn (wall)
        (put (map-get wall 'x) (map-get wall 'y) "b")
    ) walls)

    ; Draw goals
    (color 10)
    (each (fn (goal)
        (put (map-get goal 'x) (map-get goal 'y) "X")
    ) goals)

    ; Draw units
    (color 5)
    (each (fn (unit)
        (put (map-get unit 'x) (map-get unit 'y) "X")
    ) units)

    ; Check goals
    (let count 0)
    (each (fn (unit)
        (each (fn (goal)
            (if (vec-equal unit goal) (++ count))
        ) goals)
    ) units)
    (if (is count (len units)) (quit)))

(func step ()
    (fill 0 0 width height " ")
    (if (is state 0) (menu)
        (is state 1) (game)))

(func keydown (k)
    (if (is state 0) (if (is k "return") (= state 1))
        (is state 1) (if (is k "up") (move-units (vec-mk 0 -1))
                         (is k "down") (move-units (vec-mk 0 1))
                         (is k "right") (move-units (vec-mk 1 0))
                         (is k "left") (move-units (vec-mk -1 0)))))