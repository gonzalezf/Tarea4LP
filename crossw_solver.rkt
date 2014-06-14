#lang scheme

;; Leer Archivo
(let ((p (open-input-file "crossword_1.txt")))
  (let f ((x (read p)))
    (if (eof-object? x)  ;; si  es final de archivo......
        (begin
          (close-input-port p) ;; cerrar archivo
          '())
     
   
  ;;      (if (equal? x  'b) ;; si no es final de archivo....
        (begin
          (display 'x )
            (display x) ;; nos muestra cada caracter del archivo
            (if (equal? x '*)
     
                (display 'funciona)
                (f(read p))
                )
           
           
            ;; seguimos llamando a la funcion de forma recursiva
            

           ))))
                  
        

(define (leercaracterporcaracter x)
  (if (null? x)
      #f  
      
      (begin ;; else....
      (display '(letraes))
      (display (car x) )
      (leercaracterporcaracter (cdr x))
     ))) ;; termina el begin
       
 (leercaracterporcaracter '(pr h))







;; aqui se define una funcion para mostrar una lista 
(define (list-display lis)
          (if (null? lis)
              #f
              (begin (display (car lis))
                     (list-display (cdr lis)))))

;; asi se debe probar!(list-display '(abc)) 

(let ((p (open-input-file "crossword_1.txt")))
  (let f ((x (read p))) ;; p = #<input-port:C:\Users\Felipe Gonzalez\Documents\Tarea4LP\crossword_1.txt>
    (if (eof-object? x)  ;; si  es final de archivo......
        (begin
          (close-input-port p) ;; cerrar archivo
          '())
     
        (begin
    
         (display x) ;; en este punto no estamos leyendo caracter por caracter, leemos todo el texto de una sola vez
         (f(read p)))
         )
          
        ))
                
       
;; probando si conseguimos leer caracter por caracter
(let ((p (open-input-file "words_1.txt")))
  (let f ((x (read p))) ;; p = #<input-port:C:\Users\Felipe Gonzalez\Documents\Tarea4LP\crossword_1.txt>
    (if (eof-object? x)  ;; si  es final de archivo......
        (begin
          (close-input-port p) ;; cerrar archivo
          '())
     
        (begin
          (display '(funciona))
         (display x) ;; en este punto no estamos leyendo caracter por caracter, leemos todo el texto de una sola vez
         (f(read p)))
         )
          
        ))
           

            

  
        
        