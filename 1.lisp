1 cannot be coerced to a character.
   [Condition of type SIMPLE-TYPE-ERROR]

Restarts:
 0: [RETRY] Retry SLY mREPL evaluation request.
 1: [*ABORT] Return to SLY's top level.
 2: [ABORT] abort thread (#<THREAD "sly-channel-1-mrepl-remote-1" RUNNING {1001A50133}>)

Backtrace:
 0: (SB-INT:SIMPLE-EVAL-IN-LEXENV (COERCE 1 (QUOTE CHARACTER)) #<NULL-LEXENV>)
 1: (EVAL (COERCE 1 (QUOTE CHARACTER))
     2: ((LAMBDA NIL :IN SLYNK-MREPL::MREPL-EVAL-1)
         --more--))
(defpackage #:advent-2023/1
  (:use #:cl)
  (:export :solution-part-one :solution-part-two))

(in-package #:advent-2023/1)

(defparameter *input* (list))

(defun load-input ()
  (let* ((lines (uiop:read-file-lines "1.input")))
    (setq *input* lines)))

(defun get-digits (line)
  (let* ((characters (coerce line 'list))
         (digits (remove-if-not 'digit-char-p characters)))
    digits))

(defun first-last (seq)
  (list (first seq) (first (last seq))))

(defun combine-digits (digits)
  (format nil "~{~A~}" digits))

(defun solution-part-one ()
  (load-input)
  (let* ((digits (mapcar 'get-digits *input*))
         (first-last-digits (mapcar 'first-last digits))
         (number-strings (mapcar 'combine-digits first-last-digits))
         (numbers (mapcar 'parse-integer number-strings)))
    (reduce '+ numbers)))

(defparameter *words* (make-hash-table :test 'equal))

(defun initialize-words ()
  (loop for values in '(("one" 1)
                        ("two" 2)
                        ("three" 3)
                        ("four" 4)
                        ("five" 5)
                        ("six" 6)
                        ("seven" 7)
                        ("eight" 8)
                        ("nine" 9))
        do (let ((str (first values))
                 (num (second values)))
               (setf (gethash (chars str) *words*) num))))

(defun words-candidates (word)
  (let* ((candidates (alexandria:hash-table-keys *words*))
         (candidates (mapcar 'chars candidates)))
    (remove-if-not (lambda (candidate)
                     (alexandria:starts-with-subseq word candidate))
                   candidates)))

(defun chars (str)
  (coerce str 'list))

; Returns a word if it exists, nil otherwise
(defun get-containing-word (characters)
  (let ((words (alexandria:hash-table-keys *words*)))
     (loop for word in words
           when (search (chars word) characters)
             return (chars word))))

(defmacro push-end (value list)
  `(setq ,list (append ,list (list ,value))))


(defmacro pop-until-not-a-word (list)
  `(loop while (get-containing-word ,list)
         do (pop ,list)))

; Like get-digits, but transforms words into numbers
(defun get-digits-words (line)
  (let* ((result (list))
         (characters (coerce line 'list))
         (current-word (list)))
    (loop for character in characters
          do
             (when (digit-char-p character)
                  (setq current-word (list))
                  (push character result))
             (when (alpha-char-p character)
                  (push-end character current-word))
             (let ((containing-word (get-containing-word current-word)))
               (when containing-word
                 (push (digit-char (gethash containing-word *words*)) result)
                 (pop-until-not-a-word current-word))))
    (reverse result)))

(defparameter *test-input* '("two1nine"
                             "eightwothree"
                             "abcone2threexyz"
                             "xtwone3four"
                             "4nineeightseven2"
                             "zoneight234"
                             "7pqrstsixteen"))
  

(defun solution-part-two ()
  (load-input)
  (initialize-words)
  (let* ((digits (mapcar 'get-digits-words *input*))
         (first-last-digits (mapcar 'first-last digits))
         (number-strings (mapcar 'combine-digits first-last-digits))
         (numbers (mapcar 'parse-integer number-strings)))
    (reduce '+ numbers)))