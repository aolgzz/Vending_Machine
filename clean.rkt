#|

    vending.rkt (clean.rkt)

    Created by Arturo Olivares on 9/15/2022.
    Copyright © 2022 Arturo Olivares. All rights reserved.

|#

#lang racket

(define arch (open-input-file "transactions.txt"))
(define arch_2 (open-input-file "backend.txt")) ;Interior de la máquina
(define transactions (read arch))
(define backend (read arch_2))

(close-input-port arch)
(close-input-port arch_2)

(define matriz (map cadr transactions))
;(define matriz (map cadr (hash-table-aux val-t-id transactions)))

(define (suma-filas matrix)
  (cond
    [(empty? matrix) empty]
    [else
     (cond
       [(empty? (car matrix)) empty]
       [else (cons (apply +(car matrix)) (suma-filas(cdr matrix)))])]))
;(suma-filas matriz)

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
         (cons (string-append (convert(car input-ids)) " (Valid ID)") (validar-tokens (cdr input-ids) machines-ids))
         (cons (string-append (convert(car input-ids)) " (Invalid ID)") (validar-tokens (cdr input-ids) machines-ids)))]))

(define (loop Lst Mat)
  (cond
    [(empty? Lst) '()]
    [else
     (append
      (list (member? (car Lst) Mat))
      (loop (cdr Lst) Mat))]))

(define (member? Key Mat)
  (cond
    [(empty? Mat) '("Ignore" 0 "Ignore" 0)]
    [(equal? Key (caar Mat)) (car Mat)]
    [else (member? Key (cdr Mat))]))


(define u (loop (map car transactions) backend))
;(map caddr u)

(define primera-parte(validar-tokens (map car transactions) (map car backend)))

(define (converter lst)
  (if (null? lst)
      '()
      (cons (list (car lst)) (converter (cdr lst)))))

(define a (open-output-file "recibo.txt" #:exists 'replace))


(define (imprimir-recibo b e ls ls2 l3 l4)
  (if (<= b e)
      (begin
        (fprintf a "Transacción #~a\n
Item ID: ~a\n" b (caar ls))
        (cond
        [(equal? (regexp-match #rx"Valid"(caar ls)) '("Valid"))
          (fprintf a "Producto: ~a
Total a pagar: $~a.00
Cantidad recibida: $~a.00\n" (car l3)(car l4)(car ls2))
          (cond
            [(>= (car ls2)(car l4))(fprintf a "Cambio: $~a.00
Estado: Transacción realizada\n\n"(-(car ls2)(car l4)))]
            [else (fprintf a "No se ingresó suficiente dinero
Estado: Transacción no realizada\n\n")])]
        [else(fprintf a "Producto: Unknown
Estado: Transacción no realizada\n\n")])
        (imprimir-recibo (+ b 1) e (cdr ls)(cdr ls2) (cdr l3) (cdr l4)))
      (display "PRINTEND")))

(imprimir-recibo 
1 ;desde 1 [b]
(length transactions); hasta el número total de transacciones [e]
(converter primera-parte); Item IDs válidos/inválidos [ls]
(suma-filas matriz);total de $ ingresado (válidos) [ls2]
(map caddr u);nombre productos (válidos) [l3]
(map cadr u)); precios de productos (válidos) [l4]

(close-output-port a)


#|REPL Backup
(hash-table-aux val-t-id backend)
(define matriz2 (map cadr (hash-table-aux val-t-id transactions)))
;(define in-ids(map car transactions))
;(define mac-ids(map car backend))
;(validar-tokens (map car transactions) (map car backend))
(define inval-t-id (remove* (map car backend) (map car transactions)))
(define val-t-id(remove* inval-t-id (map car transactions)))
|#
