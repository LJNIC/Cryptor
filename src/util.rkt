(= macro (mac (sym params . body) (list '= sym (cons 'mac (cons params body)))))

(macro func (sym params . body) (list '= sym (cons 'fn (cons params body))))

(macro when (x . body) (list 'if x (cons 'do body)))

(macro ++ (x n) (list '= x (list '+ x (or n 1))))
(macro -- (x n) (list '= x (list '- x (or n 1))))
(func > (a b) (not (<= a b)))
(func >= (a b) (not (< a b)))
(func abs (x) 
    (if (< x 0) (* -1 x) x))

(func each (f lst) 
    (while lst 
        (f (car lst)) 
        (= lst (cdr lst))))

(func len (lst) (let n 0) (while lst (= lst (cdr lst)) (++ n)) n)
(func empty? (lst) (not (car lst)))
(func empty () (list))
(func void () nil)

(func map (f lst)
    (if (empty? lst) 
        (empty)
        (cons (f (car lst)) (map f (cdr lst)))))

(func reduce (f val coll)
    (if (empty? coll)
        val
        (reduce f (f val (car coll)) (cdr coll))))

(func nth (lst i)
    (if (is i 0)
        (car lst)
        (nth (cdr lst) (- i 1))))

(func append (lst-a lst-b)
    (if (empty? lst-a)
        lst-b
        (cons (car lst-a) (append (cdr lst-a) lst-b))))

(func get (m index)
    (if (empty? m) nil
        (is (car (car m)) index) (cdr (car m))
        (get (cdr m) index)))

(func set (m index value)
    (if (empty? m) nil
        (is (car (car m)) index) (setcdr (car m) value)
        (set (cdr m) index value)))

(func map-mk-helper (lst ac)
    (if (empty? lst) ac
        (map-mk-helper (cdr (cdr lst)) (cons (cons (car lst) (car (cdr lst))) ac))))

(func table (lst) (map-mk-helper lst (empty)))

(func copy (m ac)
    (if (empty? m) ac
        (copy (cdr m) (cons (cons (car (car m)) (cdr (car m))) ac))))
