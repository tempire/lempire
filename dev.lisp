; Load all packages for dev environment

(ql:quickload '(clsql hunchentoot css-lite parenscript cl-who))

(let ((dir "/Users/glen/Projects/lisp/lempire/"))
  (progn
    (load (concatenate 'string dir "package.lisp"))
    (load (concatenate 'string dir "schema.lisp"))
    (load (concatenate 'string dir "lempire.lisp"))
    (load (concatenate 'string dir "root.lisp"))
    (load (concatenate 'string dir "photos.lisp"))
    (load (concatenate 'string dir "blogs.lisp"))))

(in-package :lempire)
(start (make-instance 'acceptor :port 8080))

(clsql-sys:start-sql-recording)
(clsql:locally-enable-sql-reader-syntax)
