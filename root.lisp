(in-package #:root)

; action
(defun index ()
  (lempire:standard-page (:title "root page")
    (:html
     (:body
      (:div :class "photos mini-thumbnails home"
       (show-latest-photo "Houston Correlation")
       (show-square-photos "Houston Correlation"))))))

; data model shortcut
(defmacro photoset-photos (photoset-name)
  `(lempire-schema:photoset-photos ,photoset-name))

; large photo
(def-internal-macro show-latest-photo (photoset-name)
  `(htm
     (:img :src (getf (first (photoset-photos ,photoset-name)) :medium))))

; square photos
(def-internal-macro show-square-photos (photoset-name)
  `(htm
     (loop for photo in (rest (photoset-photos ,photoset-name)) do
           (htm (:div :class "photo" :id (getf photo :id)
                 (:img :src (getf photo :square)))))))
