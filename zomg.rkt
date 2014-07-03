#lang scheme
;Arroja la lista de palabras. Cada palabra se comporta como un string!
(define lista-palabras (car(cdr (call-with-input-file "words_1.txt" read))))
(display "Palabras:")
(newline)
lista-palabras
(newline)


;Tenemos el crucigrama como un arreglo!
(define crucigrama (car (cdr(call-with-input-file "crossword_1.txt" read))))
(define (convertir-a-string l) (if (null? l) l (cons (symbol->string (car (car l))) (convertir-a-string (cdr l)))))
(define crucigrama-string (convertir-a-string crucigrama))
(define (convert-to-list-of-chars l) (if (null? l) 
                                         '() 
                                         (cons (string->list(car l)) (convert-to-list-of-chars (cdr l)))
                                         ))
(set! crucigrama (convert-to-list-of-chars crucigrama-string))
(display "Crucigrama:")
(newline)
crucigrama

;Obtiene una sublista con los elementos
;desde la posicion a hasta b. Incluye ambos extremos
(define (sublist l a b)
  (cond
    ((not (pair? l))
     l)
    ((and (> a 0) (>= b 0))
     (sublist (cdr l) (- a 1) (- b 1)))
    ((and (<= a 0) (>= b 0))
    (cons (car l) (sublist (cdr l) (- a 1) (- b 1))))
    ((< b 0)
    '())
    ))
      
;Modifica la lista reemplazando el elemento en la posicion x
;por c
(define (modify-list l x c)
  (cond
    ((= x 0)
     (cons c (modify-list (cdr l) (- x 1) c)))
    ((null? l)
     '())
    (else
     (cons (car l) (modify-list (cdr l) (- x 1) c)))))

;Obtener el caracter en la posicion (x, y) en el crucigrama.
;Comienza desde 0.
(define (get-at l x y)
  (sublist (car (sublist l y y)) x x))

;Reemplaza el caracter en la posicion (x, y) en el crucigrama
; por c
(define (set-at l x y c)
  (modify-list l y (modify-list (car (sublist l y y)) x c)))

;Busca las posiciones en donde existan letras
;partiendo desde la posicion (a, b)
(define (get-letter-positions l a b max-a max-b)
  (cond
    ((or (>= b max-b) (null? l))
     '())
    
    ((>= a max-a)
     (get-letter-positions l 0 (+ b 1) max-a max-b))
    ((not (or (char=? (car(get-at l a b)) #\*) (char=? (car (get-at l a b)) #\-)))
       (cons (cons a b) (get-letter-positions l (+ a 1) b max-a max-b)))
    (else
     (get-letter-positions l (+ a 1) b max-a max-b))))
     

;Retorna el numero de casillas vecinas horizontales disponibles desde la posicion (x, y)
(define (casillas-horizontales l x y max-x)
  (cond
    ((>= (+ x 1) max-x)
     0)
    ((not (char=? (car (get-at l (+ x 1) y)) #\-))
     (+ (casillas-horizontales l (+ x 1) y max-x) 1))
     (else
      0)))
;Retorna el numero de casilla vecinas verticales disponibles desde la posicion (x, y)
(define (casillas-verticales l x y max-y)
  (cond
    ((>= (+ y 1) max-y)
     0)
    ((not (char=? (car (get-at l x (+ y 1))) #\-))
     (+ (casillas-verticales l x (+ y 1) max-y) 1))
     (else
      0)))

;Retorna true si la palabra cabe de forma horizontal
;Chequea que coincida la primera letra y que tenga el mismo tamaño
(define (try-word-horizontal l word x y)
  (if (and (> (string-length word) 0) (string? word))
  (let ((word-len (string-length word)))
    (cond
      ((>= x (length(car l)))
       #t)
      ((and (or (char=? (string-ref word 0) (car (get-at l x y))) (char=? #\* (car (get-at l x y)))) (= word-len (+ 1 (casillas-horizontales l x y (length (car l))))))
      (try-word-horizontal l (substring word 1) (+ x 1) y))
      (else
      #f)))
  #t))

;Retorna true si la palabra cabe de forma vertical
;Chequea que conicida la primera letra y que tenga el mismo tamaño
(define (try-word-vertical l word x y)
  (if (and (> (string-length word) 0) (string? word))
  (let ((word-len (string-length word)))
    (cond
      ((>= y (length l))
       #t)
      ((and (or (char=? (string-ref word 0) (car (get-at l x y))) (char=? #\* (car (get-at l x y)))) (= word-len (+ 1 (casillas-verticales l x y (length l)))))
      (try-word-vertical l (substring word 1) x (+ y 1)))
      (else
      #f)))
  #t))

;Escribe la palabra de forma horizontal desde la posicion x y
(define (write-word-horizontal l w x y total)
 (if (and (and (< x (length (car l))) (string? w)) (> total 0))
   (write-word-horizontal (set-at l x y (string-ref w 0)) (substring w 1) (+ 1 x) y (- total 1))
   l))

;Escribe la palabra de forma vertical desde la posicion x y
(define (write-word-vertical l w x y total)
 (if (and (and (< x (length (car l))) (string? w)) (> total 0))
   (write-word-vertical (set-at l x y (string-ref w 0)) (substring w 1) x (+ 1 y) (- total 1))
   l))

;Probar todas las palabras en una misma posicion, retorna el crucigrama modificado
(define (try-all-words cru wrds x y)
  (if(not (null? wrds))
      (let ((word (car wrds)))
        (cond
          ((try-word-vertical cru word x y)
           (try-all-words (write-word-vertical cru word x y (string-length word)) (cdr wrds) x y))
          ((try-word-horizontal cru word x y)
           (try-all-words (write-word-horizontal cru word x y (string-length word)) (cdr wrds) x y))
          (else
           (try-all-words cru (cdr wrds) x y))))
      cru))

;Resuelve el crucigrama
(define (solve-the-crossword cru pos wrds)
  (if (null? pos)
      cru
      (cond
        ((eqv? cru (try-all-words cru wrds (car(car pos)) (cdr(car pos))))
            (begin
              (display "No se pudo colocar ninguna palabra en una posicion")
              (newline)
              cru))
        (else
         (solve-the-crossword (try-all-words cru wrds (car(car pos)) (cdr(car pos))) (cdr pos) wrds)))))
  

;Testeos ETC
(newline)
;(set-at crucigrama 0 1 #\r)
(define start-positions (get-letter-positions crucigrama 0 0 (length (car crucigrama)) (length crucigrama)))
(display "Posiciones Iniciales:\n")
start-positions
(newline)
;(try-all-words crucigrama lista-palabras 9 0)
(solve-the-crossword crucigrama start-positions lista-palabras)