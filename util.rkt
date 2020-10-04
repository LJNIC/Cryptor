(= macro (mac (sym params . body) (list '= sym (cons 'mac (cons params body)))))
(macro func (sym params . body) (list '= sym (cons 'fn (cons params body))))
(macro when (x . body) (list 'if x (cons 'do body)))
(macro ++ (x n) (list '= x (list '+ x (or n 1))))
(macro -- (x n) (list '= x (list '- x (or n 1))))
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

(func nth (i lst)
    (if (is i 0)
        (car lst)
        (nth (- i 1) (cdr lst))))