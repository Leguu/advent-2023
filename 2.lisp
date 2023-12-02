(defpackage #:advent-2023/2
  (:use #:cl #:cl-ppcre)
  (:export :solution-part-one :solution-part-two))

(in-package #:advent-2023/2)

(defparameter *input* (list))

; A set is something like "3 blue, 2 red"
(defun set-string-to-numbers (set-string)
  (let* ((components (uiop:split-string set-string :separator '(#\,)))
         (red 0)
         (green 0)
         (blue 0))
    ; Stuff like "3 blue"
    (loop for component in components
          do (register-groups-bind ((#'parse-integer number) colour)
                 ("(\\d+) (\\w+)" component)
               (when (equal colour "red")
                 (setq red number))
               (when (equal colour "green")
                 (setq green number))
               (when (equal colour "blue")
                 (setq blue number))))
    (list red green blue)))

; Given an input line returns a set of RGB sets like ((1 2 3) (0 5 6))
(defun get-cubes (line)
  (let* ((cube-line (second (uiop:split-string line :separator '(#\:))))
         (sets (uiop:split-string cube-line :separator '(#\;)))
         (sets-with-components (mapcar 'set-string-to-numbers sets)))
    sets-with-components))

(defun read-input ()
  (let* ((lines (uiop:read-file-lines "2.input"))
         (cubes (mapcar 'get-cubes lines)))
    (setq *input* cubes)))

(defun is-impossible-one? (game)
  (loop for set in game
        never (destructuring-bind (red green blue) set
                (or (> red 12)
                    (> green 13)
                    (> blue 14)))))

(defun solution-part-one ()
  (read-input)
  (let ((result 0))
   (loop for game in *input*
         with id = 1
         do (when (is-impossible-one? game)
              (setq result (+ result id)))
            (incf id)
    result)))



(defmacro maximum-in-game (part)
  `(loop for set in game
         maximize ,part))
(defun minimum-power (game)
  (let ((max-red (maximum-in-game (first set)))
        (max-green (maximum-in-game (second set)))
        (max-blue (maximum-in-game (third set))))
    (* max-red max-green max-blue)))

(defun solution-part-two ()
  (read-input)
  (loop for game in *input*
        sum (minimum-power game)))
