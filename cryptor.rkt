(= state 'menu)
(= level 1)
(= turns 0)

(= units '())
(= goals '())
(= walls '())

(func load-level ()
    (= turns 0)
    (let l (nth levels (- level 1)))
    (= units (map-get l 'units))
    (= goals (map-get l 'goals))
    (= walls (map-get l 'walls)))

(load-level)

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

(= n 0)
(= menu-timer 0)
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
    (++ menu-timer)
    (if (is (% menu-timer 3) 0) (++ n)))

(= n 0)
(= trans-timer 0)
(= blink-timer 1)
(func trans ()
    (color 5)
    (put 7 6 level)
    (color 14)
    (fill 6 7 3 1 ".")
    (color 5)
    (put (+ 6 (% n 3)) 7 ".")
    (++ blink-timer)
    (if (is (% blink-timer 5) 0) (++ n))

    (++ trans-timer)
    (if (>= trans-timer 45) (= state 'game)))

(func game ()
    ; Draw ground and walls
    (color 14)
    (fill 2 2 (- width 4) (- height 4) "\"")
    (each (fn (wall)
        (put (map-get wall 'x) (map-get wall 'y) "!")
    ) walls)

    ; Draw goals
    (color 10)
    (each (fn (goal)
        (put (map-get goal 'x) (map-get goal 'y) "X")
    ) goals)

    (color 5)
    (put 3 1 turns)

    ; Draw units
    (each (fn (unit)
        (color 5)
        (each (fn (goal) (if (vec-equal unit goal) (color 1))) goals)
        (put (map-get unit 'x) (map-get unit 'y) "X")
    ) units))


(= states (map-mk (list 'menu menu 'game game 'trans trans)))

(func step ()
    (fill 0 0 width height " ")
    ((map-get states state)))

(func turn (vec)
    (move-units vec)
    (++ turns)

    ; Check goals
    (let count 0)
    (each (fn (unit)
        (each (fn (goal)
            (if (vec-equal unit goal) (++ count))
        ) goals)
    ) units)

    (when (is count (len units)) 
        (++ level)
        (if (> level (len levels)) (quit))
        (load-level)
        (= n 0)
        (= trans-timer 0)
        (= blink-timer 0)
        (= state 'trans)))

(func keydown (k)
    (if (is state 'menu) (if (is k "return") (= state 'trans))
        (is state 'game) (if (is k "up") (turn (vec-mk 0 -1))
                            (is k "down") (turn (vec-mk 0 1))
                            (is k "right") (turn (vec-mk 1 0))
                            (is k "left") (turn (vec-mk -1 0)))))