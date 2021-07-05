(= state 'menu)
(= level 1)
(= turns 0)
(= scores '())

(= units '())
(= goals '())
(= walls '())

; Loads a level from the levels defined in config.rkt
(func load-level ()
    (= turns 0)
    (let l (nth levels (- level 1)))
    (= units '())

    ; Copy all units from the level into the current game units
    ; We have to do this so that units can be reset
    (each (fn (unit)
        (= units (cons (copy unit (empty)) units))
    ) (get l 'units))

    (= goals (get l 'goals))
    (= walls (get l 'walls)))

; Load the first level
(load-level)

; ================================================================
;                          GAME STATES 
; ================================================================

; Menu state function
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

; Level transition state function
(func trans-enter ()
    (= n 0)
    (= trans-timer 0)
    (= blink-timer 1))
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
    (when (>= trans-timer 45) 
        (load-level)
        (state-trans 'game)))

; Win state function
(func win-enter ()
    (= scores (cons turns scores))
    (= win-timer 0)
    (= win-blink 0))
(func win ()
    (game)
    (++ win-timer)
    (when (is (% win-timer 5) 0) (= win-blink 2))

    (when (> win-blink 0)
        (-- win-blink)
        (color 14)
        (each (fn (goal)
            (put (get goal 'x) (get goal 'y) (if (is (get goal 'type) 'base) "X" "#"))
        ) goals))

    (when (> win-timer 20)
        (++ level)
        (if (> level (len levels))
            (state-trans 'report)
            (state-trans 'trans))))

(func has-won? ()
    (let count 0)
    (each (fn (unit)
        (each (fn (goal)
            (if (and (vec-equal unit goal) (is (get unit 'type) (get goal 'type)))
                (++ count))
        ) goals)
    ) units)

    (is count (len units)))

(func update-rook (rook)
    (when (not (vec-equal rook (get rook 'future-pos)))
        (let direction (vec-norm (vec-sub (get rook 'future-pos) rook)))
        (let new-pos (vec-add rook direction))
        (vec-set rook (get new-pos 'x) (get new-pos 'y))))

; Normal game state function
(func game-enter ()
    (= accept-arrow turn)
    (= has-won-already? nil))
(func game ()
    ; Draw ground and walls
    (color 14)
    (fill 2 2 (- width 4) (- height 4) "\"")
    (color 15)
    (each (fn (wall)
        (put (get wall 'x) (get wall 'y) "!")
    ) walls)

    (color 14)
    (put 10 1 "R$%")

    ; Draw goals
    (each (fn (goal)
        (let type (get goal 'type))
        (put (get goal 'x) (get goal 'y) (if (is 'base type) "X" "#"))
    ) goals)

    (color 5)
    (put 2 1 turns)

    ; Draw units
    (each (fn (unit)
        (let type (get unit 'type))
        (color 5)

        (when (is type 'rook)
            (color 2)
            (update-rook unit))

        (each (fn (goal) 
            (when (and (is (get unit 'type) (get goal 'type)) (vec-equal unit goal))
                (color 1))
        ) goals)

        (put 
            (get unit 'x) 
            (get unit 'y) 
            (if (is 'base type) "X" "#"))
    ) units)

    (when (not has-won-already?)
        (when (has-won?)
            (= has-won-already? 't)
            (state-trans 'win))))

(func report ()
    )

(= editor-pos (vec 5 5))
(= editor-tile 'wall)
(= editor-tiles (table 'wall "!"))
(func editor-enter ()
    (= accept-arrow (fn (dir) (= editor-pos (vec-add editor-pos dir)))))
(func editor ()
    (game)
    (color 1)
    (put (get editor-pos 'x) (get editor-pos 'y) (get editor-tiles editor-tile)))

(= states (table
    'menu menu 'game game 'trans trans 'win win 'report report 'editor editor
    ))
(= state-transitions (table 'menu void 'game game-enter 'trans trans-enter 'win win-enter 'report void 'editor editor-enter))
(func state-trans (next-state) 
      ((get state-transitions next-state))
      (= state next-state))

; MAIN GAME LOOP
(func step ()
    (fill 0 0 width height " ")
    ((get states state)))

; ================================================================
;                           TURN LOGIC
; ================================================================

; checks if a position is clear of any walls or units
(func clear? (pos)
    (let wall-exists (reduce 
        (fn (val it) (if (vec-equal it pos) nil val))
        't
        walls))

    (let unit-exists (reduce 
        (fn (val it) (if (vec-equal it pos) nil val))
        't
        units))

    (let x (get pos 'x))
    (let y (get pos 'y))
    (let inside-grid (and (> x 1) (< x 13) (> y 1) (< y 13)))
    
    (and wall-exists unit-exists inside-grid))

; Moves the basic unit (one tile at a time)
(func move-base (unit dir)
    (let pos (vec-add unit dir))
    (if (clear? pos) 
        (vec-set unit (get pos 'x) (get pos 'y))
        unit))

; Moves the rook unit (like a rook in chess)
(func move-rook (unit dir)
    (let pos (vec-add unit dir))
    (let count 0)
    (while (clear? pos)
        (do 
            (= pos (vec-add pos dir))
            (++ count)))

    (= pos (vec-add (vec-mul dir count) unit))
    (set unit 'future-pos pos))

; Utility for moving any unit type
(func move-unit (unit dir)
    (if (is 'base (get unit 'type)) (move-base unit dir)
        (is 'rook (get unit 'type)) (move-rook unit dir)))

; Moves all units in the direction
(func move-units (dir)
    (map (fn (el) (move-unit el dir)) units))

; Checks if all rook movements are complete
(func animations-done? ()
    (reduce 
        (fn (val next) 
            (let type (get next 'type))
            (if (is type 'rook)
                (and val (vec-equal next (get next 'future-pos)))
                val))
        't
        units))

; Executes a turn in the game given a direction
(func turn (dir)
    (when (animations-done?) 
        (move-units dir)
        (++ turns)))

; INPUT HANDLER
(func keydown (k)
    (if (and (is state 'menu) (is k "return")) 
        (state-trans 'trans))
        (or (is state 'game) (is state 'editor)) 
        (if 
            (is k "up") (accept-arrow (vec 0 -1))
            (is k "down") (accept-arrow (vec 0 1))
            (is k "right") (accept-arrow (vec 1 0))
            (is k "left") (accept-arrow (vec -1 0))
            (is k "r") (load-level)
            (is k "n") (do (++ level) (load-level))
            (is k "e") (state-trans 'editor)))
