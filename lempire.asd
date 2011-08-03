;;;; lempire.asd

(asdf:defsystem #:lempire
  :serial t
  :depends-on (#:hunchentoot #:cl-who #:parenscript #:clsql #:css-lite)
  :components ((:file "package")
               (:file "lempire")
               (:file "root")
               (:file "schema")))
