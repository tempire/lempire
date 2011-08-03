; models

(defpackage #:lempire-schema
  (:use #:cl #:clsql)
  (:documentation "db schema")
  (:export :faces-of-glen-photos :photoset-photos))

(defpackage #:lempire
  (:use #:cl #:hunchentoot #:cl-who #:parenscript :lempire-schema)
  (:export :standard-page))

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
  (:export :index))
