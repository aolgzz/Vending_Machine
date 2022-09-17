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

(define a (open-output-file "recibo.txt" #:exists 'replace))

(define (suma-filas matrix)
  (cond
    [(empty? matrix) empty]
    [else
     (cond
       [(empty? (car matrix)) empty]
       [else (cons (apply +(car matrix)) (suma-filas(cdr matrix)))])]))

(define (truth-or-false matrix)
  (cond
    [(empty? matrix) empty]
    [else
      (cond
        [(empty? (car matrix)) empty]
        [else(cons (regexp-match #rx"Valid" (caar matrix))(truth-or-false(cdr matrix)))])]))
        ;[else (regexp-match #rx"Invalid" (caar matrix))])]))
        #|
        [else (cond
                [(equal? (regexp-match #rx"Invalid" (caar matrix)) #f)(cons "False"(truth-or-false(cdr matrix)))]
                [else (cons "True" (truth-or-false(cdr matrix)))])])]))|#

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

;(define in-ids(map car transactions))
;(define mac-ids(map car backend))
;(validar-tokens (map car transactions) (map car backend))
(define primera-parte(validar-tokens (map car transactions) (map car backend)))

(define inval-t-id (remove* (map car backend) (map car transactions)))
(define val-t-id(remove* inval-t-id (map car transactions)))


(define (hash-table ls ls2)
  (cond
    [(and (empty? ls2) (empty? ls))
     '()]
    [(empty? ls)
     '()]
    [else
        (cond
          [(member (car ls) (car ls2))
           ;(printf "Access granted")
           (member (car ls) (car ls2))]
          [else
           (hash-table ls (cdr ls2))])]))

(define (hash-table-aux ls ls2)
  ;((data-base ls backend))
  (if (empty? ls)
      empty
      (append (list (hash-table ls ls2))
              (hash-table-aux (cdr ls) ls2))))

;(hash-table-aux val-t-id backend)


(define (converter lst)
  (if (null? lst)
      '()
      (cons (list (car lst)) (converter (cdr lst)))))

(define (imprimir-recibo b e ls ls2 l3 l4)
  (if (<= b e)
      (begin
        (fprintf a "Transacción #~a\n
Item ID: ~a\n" b (caar ls))
        (if (equal? (regexp-match #rx"Valid"(caar ls)) '("Valid"))
            (fprintf a "Producto: ~a
Total a pagar: $~a.00
Cantidad recibida: $~a.00
Estado: Transacción realizada\n\n"(car l3)(car l4)(car ls2))
            (fprintf a "Producto: Unknown
Estado: Transacción no Realizada\n\n"))
        (imprimir-recibo (+ b 1) e (cdr ls)(cdr ls2) (cdr l3)(cdr l4)))
      (display "END")))

(define madworld(map caddr (hash-table-aux val-t-id backend)))
(define analog(map cadr (hash-table-aux val-t-id backend)))

(define (duplicate-until-reached lst num)
  (cond
    ((= num 0) '())
    (else
     (append lst (duplicate-until-reached lst (- num 1))))))

;(duplicate-until-reached madworld (length transactions))

(imprimir-recibo 
1 
(length transactions) 
(converter primera-parte) 
(suma-filas matriz)
(duplicate-until-reached madworld (length transactions))
(duplicate-until-reached analog (length transactions)))


;(map caddr (hash-table-aux val-t-id backend))
(define prima(map car backend))
(define primo(map car transactions))

(close-output-port a)
