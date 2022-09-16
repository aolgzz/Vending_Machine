#|

    vending.rkt (clean.rkt)

    Created by Arturo Olivares on 9/15/2022.
    Copyright © 2022 Arturo Olivares. All rights reserved.

|#

#lang racket

(define arch (open-input-file "backend.txt"))
(define transactions (read arch))

(close-input-port arch)

(define matriz (map cadr transactions))

;(define n-list (list)) Lista vacía

(define a (open-output-file "recibo.txt" #:exists 'replace))

(define (suma-filas matrix)
  (cond
    [(empty? matrix) (printf"No hay más transacciones")]
    [else
     (cond
       [(empty? (car matrix)) (writeln "No se insertaron monedas" a)]
       ;Imprime con formato la suma de cada uno de los elementos de la matriz:
       ;[else (printf "Sum: ~a\n" (apply +(car matrix)))(suma-filas(cdr matrix))])]))
       ;Imprime las sumas de las filas todas pegadas en manera de lista
       ;[else (print (list(apply +(car matrix))))(suma-filas(cdr matrix))])]))
       ;Imprime las sumas de las filas todas pegadas
       ;[else (print (apply +(car matrix)))(suma-filas(cdr matrix))])]))
       ;Escribe en cada linea de un archivo la suma de cada de una de las filas
       ;[else (writeln (apply +(car matrix)) a)(suma-filas(cdr matrix))])]))
       ;Escribe las sumas de las filas separadas por espacios en blancos
       [else (write (apply +(car matrix)) a)(write-char #\space a)(suma-filas(cdr matrix))])]))

(suma-filas matriz)

;(transactions)

(define (validar-tokens tokens transactions)
  (cond
    [(empty? transactions) (printf "--No hay más transacciones--\n\n")]
    [else
     (if (member (car (car transactions)) tokens)
         (printf "Producto seleccionado válido\n");((validar-monedas (map car caja) transacciones))
         (printf "Producto seleccionado NO válido\n"))
     (validar-tokens tokens (rest transactions))]))

;(validar-tokens (map car transactions) transactions)


#|
     (if (member (car (car transactions)) tokens)
         (compra);((validar-monedas (map car caja) transacciones))
         (declined))
     (validar-tokens tokens (rest transactions))]))

|#






(close-output-port a)


