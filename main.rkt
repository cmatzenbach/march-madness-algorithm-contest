#lang racket
(require csv-reading)

;; Globals
(define off-eff (csv->list (open-input-file "data/offensive-efficiency.csv")))
(define def-eff(csv->list (open-input-file "data/defensive-efficiency.csv")))
(define adj-eff (csv->list (open-input-file "data/adjusted-efficiency-margin.csv")))

;; Data Interaction
(define (return-matching-row lst data)
  (ormap (lambda (row)
           (and (member data row) row)) lst))

(define (get-rank stat team)
  (let ([data (return-matching-row stat team)])
    (car data)))

(define make-bbdata-csv-reader
  (make-csv-reader-maker
   '((separator-chars #\|)
    (strip-leading-whitespace? . #t)
    (strip-trailing-whitespace? . #f))))

(define next-row
  (make-bbdata-csv-reader (open-input-file "data/offensive-efficiency.csv")))

;; Scoring
(define (compare-teams team1 team2)
  (cond
    [(> (compute-score team1) (compute-score team2)) (print team1)]
    [(< (compute-score team1) (compute-score team2)) (print team2)]
    [(= (compute-score team1) (compute-score team2)) (print "Tie!")]))

(define (compute-score team)
  (/ (+ (string->number (get-rank off-eff team)) (string->number (get-rank def-eff team)) (string->number (get-rank adj-eff team))) 3))


;; Testing
(compare-teams "Ohio State" "North Carolina")
