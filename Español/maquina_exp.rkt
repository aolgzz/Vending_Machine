#|

    maquina_exp.rkt

    Created by Arturo Olivares on 10/10/2022.
    Copyright © 2022 ITESM. All rights reserved.

|#

#lang racket

#|                                  LECTURA DE ARCHIVOS                                             |#
(define _arch_ (open-input-file "transactions.txt")) ; Matriz de transacciones
(define _arch2_ (open-input-file "backend.txt")) ; Interior de la máquina (productos)
(define _arch3_ (open-input-file "money_stacks.txt")) ; Interior de la máquina (dinero)
(define transactions (read _arch_))
(define inventory (read _arch2_))
(define cash-register(read _arch3_))

(close-input-port _arch_)
(close-input-port _arch2_)
(close-input-port _arch3_)

#|                                    AREA DE BACKEND                                               |#

; Sobreescribe un renglón especifico de un .txt
(define (overwriteln filename n new-elem)
  (let ([lst (with-input-from-file filename read)])
    (with-output-to-file filename #:exists 'truncate/replace
      (lambda () (pretty-write (list-set lst n new-elem))))))

; Lee un renglón específico de un .txt
(define (freadln filename n)
  (let ([lst (with-input-from-file filename read)])
    (list-ref lst n)))

; Reemplaza un elemento en una lista
(define replace (lambda (s pos lst fin-lst)
                  (cond
                    ((zero? pos)
                     (append (reverse (cons s fin-lst)) (rest lst)))
                    (else
                     (replace s (- pos 1) (rest lst) (cons (first lst) fin-lst))))))

; Devuelve el número de la fila en la que se encuentra un elemento de una matriz
(define (find-index matrix element)
  (cond
    [(empty? matrix) -1]
    [(member element (first matrix)) 0]
    [else (let ([index (find-index (rest matrix) element)])
            (if (equal? index -1)
                -1
                (+ 1 index)))]))

; pop: Se encarga de dispensar los productos cuando una transacción es exitosa.
;      También actualiza el archivo .txt donde se alojan los productos.
(define (pop product-id product-inventory filename)
  (let([pos (find-index product-inventory product-id)])
    (if(equal? pos -1)
       (void)
       (let ([slot (freadln filename pos)])
         (cond
           [(zero? (cadddr slot))
            (void)]
           [else
            (overwriteln filename pos (replace (- (cadddr slot )1) 3 slot '()))])))))

; Devuelve el estado en el que se encuentra un "slot" de uno de los productos de la máquina.
(define (product-slot-status id product-inventory filename)
  (let ([pos (find-index product-inventory id)])
    (let ([amount(cadddr(freadln filename pos))])
      (cond
        [(= amount 0 )'vacio]
        [(<= amount 3)'poco-inventario]))))

; En base a sus IDs muestra que productos están vacíos y cuales no
(define (no-prod? lst-ids product-inventory filename)
  (cond
    [(empty? lst-ids)'()]
    [else
     (cond
       [(equal? (product-slot-status (car lst-ids) product-inventory filename)'vacio)
        (cons #t
              (no-prod? (cdr lst-ids) product-inventory filename))]
       [else
        (cons #f
              (no-prod? (cdr lst-ids) product-inventory filename))])]))

; Escribe sobre el archivo que tendra el recibo letreros señalando que productos se agotaron o cuáles
; están por agotarse.
(define (fprintf-prod-slot-status lst-prod-ids lst-prod-names prod-inventory filename)
  (cond
    [(empty? lst-prod-ids)(void)]
    [(empty? lst-prod-names) (void)]
    [else
     (cond
       [(equal? (product-slot-status (car lst-prod-ids) prod-inventory filename)'vacio)
        (fprintf output "[ADVERTENCIA]: Se agotó el producto (~a - ~a)\n" (car lst-prod-ids)
                 (car lst-prod-names))
        (fprintf-prod-slot-status (cdr lst-prod-ids) (cdr lst-prod-names) prod-inventory filename)]
       [(equal? (product-slot-status (car lst-prod-ids) prod-inventory filename)'poco-inventario)
        (fprintf output "[ADVERTENCIA]: El producto (~a - ~a) está por agotarse\n" (car lst-prod-ids)
                 (car lst-prod-names))
        (fprintf-prod-slot-status (cdr lst-prod-ids) (cdr lst-prod-names) prod-inventory filename)]
       [else
        (void)
        (fprintf-prod-slot-status (cdr lst-prod-ids) (cdr lst-prod-names) prod-inventory filename)])]))

; Devuelve el número total que un elemento está presente en una lista.
(define occur (lambda (a s)
    (count (curry equal? a) s)))

#|
  Se le ingresa dos listas, la primera son los elementos que se desea buscar y la segunda es la lista
  sobre la que se quiere buscar. Ejemplo:
  > (repetitions '(1 2 3 42 2) '(1 2 3 4 42 42 42))
  > '(1 1 1 3 1)
|#
(define (repetitions keys list-to-analyze)
  (cond
    [(empty? keys) '()]
    [(empty? list-to-analyze) '()]
    [else
     (append (list(occur (car keys) list-to-analyze))(repetitions (cdr keys) list-to-analyze))]))

; add-coins: Se encarga de meter las monedas/billetes a la máquina cuando una transacción es exitosa.
;           También actualiza el archivo .txt donde se aloja el dinero
(define (add-coins lst-occurs start filename)
  (if (empty? lst-occurs)
      (void)
      (let([updated-amount(+ (cadr (freadln filename start)) (car lst-occurs))])
        (let([updated-slot(replace updated-amount 1 (freadln filename start)'())])
          (overwriteln filename start updated-slot)(add-coins (cdr lst-occurs) (+ start 1) filename)))))

; Versión alternativa al find-index. Mientras que find-index se usó para los productos, find-index-alt
; se usó para las monedas.
(define (find-index-alt matrix element)
  (cond
    [(empty? matrix) -1]
    [(equal? element (caar matrix)) 0]
    [else (let ([index (find-index-alt (cdr matrix) element)])
            (if (equal? index -1)
                -1
                (+ 1 index)))]))

; Devuelve el estado en el que se encuentra un "slot" de uno/a de los/as monedas/billetes de la máquina.
(define (coin-slot-status coin-den coin-inventory filename)
  (let ([pos (find-index-alt coin-inventory coin-den)])
    (let([amount(cadr(freadln filename pos))])
      (let ([limit(caddr(freadln filename pos))])
        (cond
          [(= amount 0)'vacio]
          [(= amount 10) 'casi-vacio]
          [(= amount (- limit 10))'casi-lleno]
          [(= amount limit) 'lleno])))))

; Escribe sobre el archivo que tendra el recibo letreros señalando que monedas/billetes se agotaron,
; cuáles están por agotarse, cuáles están por llenarse y cuales ya se llenaron.
(define (fprintf-coin-slot-status lst-coin-dens coin-inventory filename)
  (cond
    [(empty? lst-coin-dens)(void)]
    [else
     (cond
       [(equal? (coin-slot-status (car lst-coin-dens) coin-inventory filename)'vacio)
        (fprintf output "[ADVERTENCIA]: Ya no hay monedas de $~a en la caja\n" (car lst-coin-dens))
        (fprintf-coin-slot-status (cdr lst-coin-dens) coin-inventory filename)]
       [(equal? (coin-slot-status (car lst-coin-dens) coin-inventory filename)'casi-vacio)
        (fprintf output "[ADVERTENCIA]: Casi no quedan monedas de $~a en la caja\n" (car lst-coin-dens))
        (fprintf-coin-slot-status (cdr lst-coin-dens) coin-inventory filename)]
       [(equal? (coin-slot-status (car lst-coin-dens) coin-inventory filename) 'casi-lleno)
        (fprintf output "[ADVERTENCIA]: La pila de monedas de $~a en la caja está por llenarse\n"
                 (car lst-coin-dens))
        (fprintf-coin-slot-status (cdr lst-coin-dens) coin-inventory filename)]
       [(equal? (coin-slot-status (car lst-coin-dens) coin-inventory filename) 'lleno)
        (fprintf output"[ADVERTENCIA]: La pila de monedas de $~a en la caja está a su máxima capacidad\n"
                 (car lst-coin-dens))
        (fprintf-coin-slot-status (cdr lst-coin-dens) coin-inventory filename)]
       [else
        (void)
        (fprintf-coin-slot-status (cdr lst-coin-dens) coin-inventory filename)])]))

; Le añade recursividad a la función: member?
(define (loop Lst Mat)
  (cond
    [(empty? Lst) '()]
    [else
     (append
      (list (member? (car Lst) Mat))
      (loop (cdr Lst) Mat))]))

; En base a una lista de llaves, determina y marca que filas de una matriz son inválidas.
(define (member? Key Mat)
  (cond
    [(empty? Mat) '("Ignore" 0 "Ignore" 0)]
    [(equal? Key (caar Mat)) (car Mat)]
    [else (member? Key (cdr Mat))]))

; En base a sus IDs muestra que denominaciones de dinero están vacías y cuales no
(define (no-coins? lst-coin-dens coin-inventory filename)
  (cond
    [(empty? lst-coin-dens)'()]
    [else
     (cond
       [(equal? (coin-slot-status (car lst-coin-dens) coin-inventory filename)'vacio)
        (cons #t
              (no-coins? (cdr lst-coin-dens) coin-inventory filename))]
       [else ;(fprintf output "Si hay monedas de ~a\n" (car lst-coin-dens))
        (cons #f
              (no-coins? (cdr lst-coin-dens) coin-inventory filename))])]))

; En base a sus IDs muestra que denominaciones de dinero están llenas y cuáles no
(define (full-coins? lst-coin-dens coin-inventory filename)
  (cond
    [(empty? lst-coin-dens)'()]
    [else
     (cond
       [(equal? (coin-slot-status (car lst-coin-dens) coin-inventory filename)'lleno)
        (cons #t
              (full-coins? (cdr lst-coin-dens) coin-inventory filename))]
       [else
        (cons #f
              (full-coins? (cdr lst-coin-dens) coin-inventory filename))])]))

; Inspecciona si todos los elementos cumplen con una condición (función auxiliar)
(define (all-slots? lst)
  (andmap (lambda (x) (equal? x #t)) lst))

; remove-coins: Se encarga de sacar las monedas/billetes a la máquina cuando una transacción es exitosa.
;               También actualiza el archivo .txt donde se aloja el dinero
(define (remove-coins lst-occurs start filename)
  (if (empty? lst-occurs)
      (void)
      (let([updated-amount(- (cadr (freadln filename start)) (car lst-occurs))])
        (let([updated-slot(replace updated-amount 1 (freadln filename start)'())])
          (overwriteln filename start updated-slot)(remove-coins (cdr lst-occurs) (+ start 1) filename)))))

; Se encarga de dar el cambio en base a una cantidad y la lista de denominaciones para ver con que va
; a devolver el cambio.
(define (change amount denominations)
  (cond
    [(= amount 0) empty]
    [(empty? denominations) empty]
    [else
     (cond
       [(>= amount (car denominations))
        (cons (car denominations) (change (- amount (car denominations)) denominations))]
       [else
        (change amount (cdr denominations))])]))

(define (percentage lst-coin-dens coin-inventory filename)
  (cond
    [(empty? lst-coin-dens)'()]
    [else
     (let ([pos (find-index-alt coin-inventory (car lst-coin-dens))])
       (let([amount(cadr(freadln filename pos))])
         (let ([limit(caddr(freadln filename pos))])
           (append(list(quotient(* amount 100)limit))
            (percentage (cdr lst-coin-dens) coin-inventory filename)))))]))

#|                                   FIN AREA BACKEND                                               |#

#|                                   AREA DEL AUTÓMATA                                              |#

; Pieza fundamental en el funcionamiento de la máquina, se encarga de determinar el estado al que
; llevan las transacciones. En otras palabras, se encarga del procesamiento del pago de monedas y
; billetes
(define (FSM lst precio lst2 suma)
  (cond
    [(empty? lst)
     ;(printf"Estoy en el estado: ~a\n" suma)
     (cond
       [(> suma precio) (cons 'Dar-cambio suma)]
       [(= suma precio) (cons 'No-cambio suma)]
       [else (cons 'Dinero-insuficiente suma)])]
    [;(printf"Estoy en el estado: ~a\n" suma)
     (if (member (first lst) lst2)
         (FSM (rest lst) precio lst2 (+ suma (first lst)))
         'Moneda-extraña-ingresada)]
    [else (FSM (rest lst) precio lst2 suma)]))

#|                               FIN DEL AREA DEL AUTÓMATA                                          |#

#|                                   AREA  DE FRONTEND                                              |#

; Toda está area se encarga de reflejar el cambio del inventario de la máquina (backend) en un recibo
; donde se marcan todas y cada una de las transacciones

(define output (open-output-file "recibo.txt" #:exists 'replace))
(define auxiliar(open-output-file "auxiliar.txt" #:exists 'replace))
(fprintf auxiliar "(")

(define (frontend-body start end ls ls2 ls3 ls4 ls5 ls6 q0)
  (cond
    [(all-slots? (full-coins? ls6 cash-register "money_stacks.txt"))

     (fprintf output ".        𝚅𝙴𝙽𝙳𝙸𝙽𝙶 𝙼𝙰𝙲𝙷𝙸𝙽𝙴 𝚃𝙴𝙼𝙿𝙾𝚁𝙰𝚁𝙸𝙻𝚈 𝙾𝚄𝚃 𝙾𝙵 𝚂𝙴𝚁𝚅𝙸𝙲𝙴
.                     𝙲𝙾𝙸𝙽 𝙱𝙾𝚇 𝙸𝚂 𝙵𝚄𝙻𝙻
.       𝙿𝙻𝙴𝙰𝚂𝙴, 𝚆𝙰𝙸𝚃 𝙵𝙾𝚁 𝙰𝙽 𝙾𝙿𝙴𝚁𝙰𝚃𝙾𝚁 𝚃𝙾 𝙴𝙼𝙿𝚃𝚈 𝚃𝙷𝙴 𝙱𝙾𝚇
.                𝚂𝙾𝚁𝚁𝚈 𝙵𝙾𝚁 𝚃𝙷𝙴 𝙸𝙽𝙲𝙾𝙽𝚅𝙴𝙽𝙸𝙴𝙽𝙲𝙴   \n\n")]
    [(all-slots? (no-prod? (map car inventory) inventory "backend.txt"))
     (fprintf output ".        𝚅𝙴𝙽𝙳𝙸𝙽𝙶 𝙼𝙰𝙲𝙷𝙸𝙽𝙴 𝚃𝙴𝙼𝙿𝙾𝚁𝙰𝚁𝙸𝙻𝚈 𝙾𝚄𝚃 𝙾𝙵 𝚂𝙴𝚁𝚅𝙸𝙲𝙴
.          𝙰𝙻𝙻 𝙼𝙰𝙲𝙷𝙸𝙽𝙴 𝙿𝚁𝙾𝙳𝚄𝙲𝚃𝚂 𝙰𝚁𝙴 𝙾𝚄𝚃 𝙾𝙵 𝚂𝚃𝙾𝙲𝙺
.    𝙿𝙻𝙴𝙰𝚂𝙴, 𝚆𝙰𝙸𝚃 𝙵𝙾𝚁 𝙰𝙽 𝙾𝙿𝙴𝚁𝙰𝚃𝙾𝚁 𝚃𝙾 𝚁𝙴𝙵𝙸𝙻𝙻 𝚃𝙷𝙴 𝙼𝙰𝙲𝙷𝙸𝙽𝙴
.                𝚂𝙾𝚁𝚁𝚈 𝙵𝙾𝚁 𝚃𝙷𝙴 𝙸𝙽𝙲𝙾𝙽𝚅𝙴𝙽𝙸𝙴𝙽𝙲𝙴   \n\n")]
    [else
     (if (<= start end)
         (begin
           (fprintf output "𝚃𝚛𝚊𝚗𝚜𝚊𝚌𝚌𝚒ó𝚗 #~a\n\n𝙸𝚝𝚎𝚖 𝙸𝙳: ~a " start (car ls))
           (cond
             [(equal? (car ls2) #f)
              (fprintf output "(Invalid ID)\nProducto: Unknown\nEstado: Transacción no realizada\n\n")]
             [else (fprintf output "(Valid ID)\nProducto: ~a\n" (car ls3))
                   (cond
                     [(equal? (product-slot-status (car ls3) inventory "backend.txt") 'vacio)
                      (fprintf output "AGOTADO\nEstado: Transacción no realizada\n\n")]
                     [else
                      (cond
                        [(equal? (FSM (car ls4) (car ls5) ls6 q0) 'Moneda-extraña-ingresada)
                         (fprintf output "--Monedas inválidas--\nEstado: Transacción no realizada\n\n")]
                        [(equal? (car(FSM (car ls4) (car ls5) ls6 q0)) 'Dinero-insuficiente)
                         (fprintf output "--Monedas aceptadas--
Total a pagar: $~a
Cantidad recibida: $~a
No se ingresó suficiente dinero
Estado: Transacción no realizada\n\n" (car ls5)(cdr (FSM (car ls4) (car ls5) ls6 q0)))]
                        [(equal? (car(FSM (car ls4) (car ls5) ls6 q0)) 'Dar-cambio)
                         (fprintf output "--Monedas aceptadas--
Total a pagar: $~a
Cantidad recibida: $~a
Cambio: $~a\n" (car ls5)(cdr (FSM (car ls4) (car ls5) ls6 q0))
               (-(cdr (FSM (car ls4) (car ls5) ls6 q0))(car ls5)))
                         (cond
                           [(<= (apply + (percentage ls6 cash-register "money_stacks.txt"))
                                (* 5 (length (percentage ls6 cash-register "money_stacks.txt"))))
                            (fprintf output "No es posible devolver cambio\nEstado: Transacción no realizada\n\n")]
                           [else(pop (car ls3) inventory "backend.txt")
                                (fprintf auxiliar "~a "(car ls5))
                                (printf "Cantidad de monedas que ingresaron: ~a"(repetitions ls6 (car ls4)))(display"\n")
                                (add-coins (repetitions ls6 (car ls4)) 0 "money_stacks.txt")
                                (printf "Cantidad de monedas que salieron: ~a"(repetitions ls6 (change (-(cdr (FSM (car ls4) (car ls5) ls6 q0))(car ls5)) (sort ls6 >))))(display"\n")
                                ;(remove-coins (repetitions (sort ls6 >) (car ls4)) 0 "money_stacks.txt")
                                (remove-coins (repetitions ls6 (change (-(cdr (FSM (car ls4) (car ls5) ls6 q0))(car ls5)) (sort ls6 >))) 0 "money_stacks.txt")
                                (fprintf output "Estado: Transacción realizada\n\n")])
                         ]
                        [(equal? (car(FSM (car ls4) (car ls5) ls6 q0)) 'No-cambio)
                         (fprintf output "--Monedas aceptadas--
Total a pagar: $~a
Cantidad recibida: $~a
Pago exacto\n"(car ls5)(cdr (FSM (car ls4) (car ls5) ls6 q0)))
                         (cond
                           [(>= (apply + (percentage ls6 cash-register "money_stacks.txt"))
                                (* 95 (length (percentage ls6 cash-register "money_stacks.txt"))))
                            (fprintf output "No es posible recibir más monedas\nEstado: Transacción no realizada\n\n")]
                           [else(pop (car ls3) inventory "backend.txt")
                                (fprintf auxiliar "~a "(car ls5))
                                (printf "Cantidad de monedas que ingresaron: ~a"(repetitions ls6 (car ls4)))(display"\n")
                                (add-coins (repetitions ls6 (car ls4)) 0 "money_stacks.txt")
                                (fprintf output "Estado: Transacción realizada\n\n")])
                         ]) ])])
           (frontend-body (+ start 1) end (cdr ls) (cdr ls2) (cdr ls3) (cdr ls4) (cdr ls5) ls6 q0))
         (display "RECIBO IMPRESO") ) ]))
; Pie de página del recibo
(define (frontend-footer revenue)
  (fprintf output
           "**********************************************************************************
Ingresos totales: $~a\n"revenue)
  (fprintf-prod-slot-status (map car inventory) (map caddr inventory) inventory "backend.txt")
  (fprintf-coin-slot-status (map car cash-register) cash-register "money_stacks.txt")
  (fprintf output "**********************************************************************************"))

;Cabecera del recibo
(fprintf output"
╭╮╭━╮              ╭━━╮                            ╭━━━╮
┃┃┃╭╯        ╭╮    ┃╭╮┃                            ┃╭━╮┃
┃╰╯╯ ╭╮╭━╮╭╮ ╰╯╭━━╮┃╰╯╰╮╭━━╮╭╮╭╮╭━━╮╭━╮╭━━╮╭━━╮╭━━╮┃┃ ╰╯╭━━╮
┃╭╮┃ ┣┫┃╭╯┣┫ ╭╮┃╭╮┃┃╭━╮┃┃┃━┫┃╰╯┃┃┃━┫┃╭╯┃╭╮┃┃╭╮┃┃┃━┫┃┃ ╭╮┃╭╮┃
┃┃┃╰╮┃┃┃┃ ┃┃ ┃┃┃╰╯┃┃╰━╯┃┃┃━┫╰╮╭╯┃┃━┫┃┃ ┃╭╮┃┃╰╯┃┃┃━┫┃╰━╯┃┃╰╯┃╭╮
╰╯╰━╯╰╯╰╯ ╰╯ ┃┃╰━━╯╰━━━╯╰━━╯ ╰╯ ╰━━╯╰╯ ╰╯╰╯╰━╮┃╰━━╯╰━━━╯╰━━╯╰╯
.           ╭╯┃                            ╭━╯┃
.           ╰━╯                            ╰━━╯\n
**************************************************************\n\n")
; Cuerpo del recibo
(frontend-body
 1 ;desde 1 [start]
 (length transactions); hasta el número total de transacciones [end]
 (map car transactions); ID transacciones [ls]
 (map (lambda (id) (member id (map car inventory))) (map car transactions)); Valid/Invalid IDs [ls2]
 (map caddr (loop (map car transactions) inventory));nombre productos (válidos) [ls3]
 (map cadr transactions); monedas insertadas en cada transacción [ls4]
 (map cadr (loop (map car transactions) inventory));lista_de_estados_aceptores_1 - precios de los productos [ls5]
 (map car cash-register);denominaciones válidas para la máquina [ls6]
 0 ;estado inicial [q0]
)

(fprintf auxiliar ")")
(close-output-port auxiliar)

(define _arch5_ (open-input-file "auxiliar.txt"))
(define revenue (read _arch5_))
(frontend-footer (apply + revenue))

(close-input-port _arch5_)
(close-output-port output)
(delete-file "auxiliar.txt")

#|                               FIN DEL AREA DEL FRONTEND                                          |#

