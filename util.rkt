(= macro (mac (sym params . body) (list '= sym (cons 'mac (cons params body)))))
(macro func (sym params . body) (list '= sym (cons 'fn (cons params body))))
(macro when (x . body) (list 'if x (cons 'do body)))
(macro ++ (x n) (list '= x (list '+ x (or n 1))))
(macro -- (x n) (list '= x (list '- x (or n 1))))
(func > (a b) (not (<= a b)))
(func >= (a b) (not (< a b)))
(func each (f lst) (while lst (f (car lst)) (= lst (cdr lst))))
(func len (lst) (let n 0) (while lst (= lst (cdr lst)) (++ n)) n)
(func empty? (lst) (not (car lst)))
(func empty () (list))

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

(func map-get (m index)
    (if (empty? m) nil
        (is (car (car m)) index) (cdr (car m))
        (map-get (cdr m) index)))

(func map-set (m index value)
    (if (empty? m) nil
        (is (car (car m)) index) (setcdr (car m) value)
        (map-set (cdr m) index value)))

(func map-mk-helper (lst ac)
    (if (empty? lst) ac
        (map-mk-helper (cdr (cdr lst)) (cons (cons (car lst) (car (cdr lst))) ac))))

(func map-mk (lst) (map-mk-helper lst (empty)))