#lang scheme

;; Leer Archivo
(let ((p (open-input-file "crossword_1.txt")))
  (let f ((x (read p)))
    (if (eof-object? x)  ;; si  es final de archivo......
        (begin
          (close-input-port p) ;; cerrar archivo
          '())
     
        (if (equal? x  'b) ;; si no es final de archivo....
            (display 'wuju)
    
        (f(read p)) ;; seguimos llamando a la funcion de forma recursiva
           )
                  
        

        )))