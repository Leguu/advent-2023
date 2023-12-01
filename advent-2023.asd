(defparameter *files*
  (mapcar
   (lambda (pathname) (pathname-name pathname))
   (uiop:directory* "./*.lisp")))

(defparameter *components* (mapcar (lambda (filename) `(:file ,filename))
                                   *files*))

(asdf:defsystem "advent-2023"
  :depends-on (:arrow-macros :f-underscore :cl-ppcre)
  :components #.*components*)
