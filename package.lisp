; main
(defpackage #:lempire
  (:use #:cl #:hunchentoot #:cl-who #:parenscript :cl-ppcre)
  (:export :standard-page :url-parts))

; models
(defpackage #:lempire-schema
  (:use #:cl #:clsql)
  (:documentation "db schema")
  (:export
   :faces-of-glen-photos :photoset-photos :photoset-count :photosets :photoset :photo
   :latest-blog-post :personal-blog-posts))

; controllers
(defpackage #:root
  (:use #:cl #:cl-who #:parenscript)
  (:documentation "root controller")
  (:export :index))

(defpackage #:blogs
  (:use #:cl #:cl-who #:parenscript)
  (:documentation "blog controller")
  (:export :index))

(defpackage #:photos
  (:use #:cl #:cl-who #:parenscript)
  (:documentation "photos controller")
  (:export :index :photoset :photo))
