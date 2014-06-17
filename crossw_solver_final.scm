#lang scheme
;;version final de la tarea...!

;; se le pasa como parametro el archivo que debe leer ejemplo "words_1.txt", retorna una lista
(define leer_archivo
  (lambda(x)
    (let ((p (open-input-file x)))
      (let leer ((x (read p)))
        (cond (eof-object? x)
              (close-input-port p)
              (cons x (leer (read x)))
        )

       
      )
    )
  )
)
;; Obtiene una palabra del archivo words!
(define  (getwords nombrearchivo lista) 
    
  (set! lista  (car(cdr(leer_archivo nombrearchivo ))))
   (list-ref lista  2)
    )
  

(define lista1 (list))
(getwords "words_1.txt" lista1)  

  
