#lang scheme
;Arroja la lista de palabras. Cada palabra se comporta como un string!
(define lista-palabras (car(cdr (call-with-input-file "words_1.txt" read))))
(display lista-palabras)

(define crucigrama (car (cdr(call-with-input-file "crossword_1.txt" read))))
(define list_of_crucigrama '())

(define (convertir-a-string l) (if (null? l) (begin
                                               (set! list_of_crucigrama (append list_of_crucigrama (symbol->string (car(car(l)))))) (convertir-a-string))
                                               l))

(symbol->string (car (car crucigrama)))
(convertir-a-string crucigrama)