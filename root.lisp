(in-package #:root)

; clsql bracket syntax
;(clsql:enable-sql-reader-syntax)

;(multiple-value-bind (value name)
  ;(clsql:select [*] :from [photosets] :where [= [id] "72157618164628634"])
  ;(first value))

(defun index ()
  (lempire:standard-page (:title "root page")
    (:html
     (:body
      (:div :class "photos mini-thumbnails home"
       (show-latest-photo "Houston Correlation")
       (show-square-photos "Houston Correlation"))))))

(def-internal-macro show-latest-photo (photoset-name)
  `(htm
     (:img :src (getf (first (lempire-schema:photoset-photos ,photoset-name)) :medium))))

(def-internal-macro show-square-photos (photoset-name)
  `(htm
     (loop for photo in (rest (lempire-schema:photoset-photos ,photoset-name)) do
           (htm (:div :class "photo" :id (getf photo :id)
                 (:img :src (getf photo :square)))))))
