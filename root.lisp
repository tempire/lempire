(in-package #:root)

; data model shortcut
(defmacro photoset-photos (photoset-name)
  `(lempire-schema:photoset-photos ,photoset-name))

; large photo
(defmacro show-latest-photo (photoset-name)
  `(htm
     (:img :src (getf (first (photoset-photos ,photoset-name)) :medium))))

; square photos
(defmacro show-square-photos (photoset-name)
  `(htm
     (loop for photo in (rest (photoset-photos ,photoset-name)) do
           (htm (:div :class "photo" :id (getf photo :id)
                 (:img :src (getf photo :square)))))))

; latest blog post
(defmacro show-latest-blog-post ()
  (let ((post (lempire-schema:latest-blog-post)))
  `(htm
     (:div :class "blog home"
      (:h3
       (:a :class "more" :href (concatenate 'string "/" ,(getf post :title))
        (str ,(getf post :title))))
      (:div :class "content"
       (str ,(getf post :timestamp))
       (:div :class "snippet"
        (str ,(getf post :title))))))))

; action
(defun index ()
  (lempire:standard-page (:title "root page")
    (:div :class "photos mini-thumbnails home"
     (show-latest-photo "Houston Correlation")
     (show-square-photos "Houston Correlation")
     (show-latest-blog-post))))
