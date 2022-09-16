#|

    vending.rkt (clean.rkt)

    Created by Arturo Olivares on 9/15/2022.
    Copyright © 2022 Arturo Olivares. All rights reserved.

|#

#lang racket

(define arch (open-input-file "backend.txt"))
(define arch_2 (open-input-file "baseDatos.txt"))
(define transactions (read arch))
(define backend (read arch_2))

(close-input-port arch)
(close-input-port arch_2)

(define matriz (map cadr transactions))

;(define n-list (list)) ;Lista vacía

(define a (open-output-file "recibo.txt" #:exists 'replace))

(define (suma-filas matrix)
  (cond
    [(empty? matrix) (printf "--No hay más transacciones--\n")]
    [else
     (cond
       [(empty? (car matrix)) (writeln "No se insertaron monedas" a)]
       [else (write (apply +(car matrix)) a)(write-char #\space a)(suma-filas(cdr matrix))])]))


(suma-filas matriz)

(define (convert str)
    (cond
    [(symbol? str)(symbol->string str)]
    [else (number? str)(number->string str)]))

(define (validar-tokens input-ids machines-ids)
  (cond
    [(and (empty? machines-ids) (empty? input-ids))
     '()]
    [(empty? input-ids)
     '()]
    [else
     (if (member (car input-ids) machines-ids)
         (cons (string-append (convert(car input-ids)) ":Valid") (validar-tokens (cdr input-ids) machines-ids))
         (cons (string-append (convert(car input-ids)) ":Invalid") (validar-tokens (cdr input-ids) machines-ids)))]))

;(define in-ids(map car transactions))
;(define mac-ids(map car backend))
;(validar-tokens (map car transactions) (map car backend))
(define primera-parte(validar-tokens (map car transactions) (map car backend)))


(define (converter lst)
  (if (null? lst)
      '()
      (cons (list (car lst)) (converter (cdr lst)))))

(define (imprimir-recibo b e ls)
    (if (<= b e)
         (begin
             (fprintf a "Transacción #~a\n~a\n" b (caar ls))
             (imprimir-recibo (+ b 1) e (cdr ls)))(display "END")))

;(imprimir-recibo 1 (length transactions) (converter primera-parte))

(close-output-port a)




