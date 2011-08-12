(in-package #:photos)

(defun url-photo-id ()
  (hunchentoot:url-decode (second (lempire:url-parts))))

(defun index ()
  (lempire:standard-page
    (:title (conc (write-to-string (lempire-schema:photoset-count)) " Phased albums"))
    (:div :id "photosets" :class "thumbnails photos"
     (loop for set in (lempire-schema:photosets) do
       (htm
         (:div :id (getf set :id) :class "photo"
          (:a :href (conc "/photos/" (getf set :url-title))
           (:div :class "label" (str (getf set :photo-count)))
           (:img :src (getf set :square) :alt "Primary photo")
           (:div :class "title" (str (getf set :title)))
           (:div :class "date" (str "Month, Year"))
           (:div :class "region" (str (getf set :region))))))))))

(defun photoset ()
    (let ((set (lempire-schema:photoset (url-photo-id))))
      (lempire:standard-page (:title (getf set :title))
        (:div :id (getf set :url-title) :class "photoset thumbnails slide photos"
         (:div :class "toolbar"
          (:h1 (getf set :title))
          (:ul :class "horizontal-list"
           (:li (:span :class "location" (getf set :region)))
           (:li (:span :class "time" "date/time"))
           (:li (:span :class "time_since" "time_since"))
           (:li (:span :class "count" (str (conc (write-to-string (getf set :photo-count)) " Photos")))))
          (:div
           (loop for photo in (lempire-schema:photoset-photos (getf set :id)) do
                 (htm
                   (:a
                    :href (conc "/photos/" (getf photo :id))
                    :class "slide"
                    (:img :src (getf photo :square)))))))))))

(defun photo ()
  (let* ((photo (lempire-schema:photo (url-photo-id)))
         (set (getf photo :set)))
    (lempire:standard-page (:title (url-photo-id))
      (:div :id (getf photo :id) :class "photo wide slide"
       (:span :class "pagetitle hidden" (getf set :title))
       (:h1 (:a :class "title" :href (conc "/photos/" (getf set :url-title)) :title (getf set :id) (getf set :title)))
       (:div :class "nav")
       (:ul :class "horizontal-list"
        (:li (:span :class "location" (getf set :region)))
        (:li (:span :class "time" "date/time"))
        (:li (:span :class "time_since" "time_since"))
        (:li (:span :class "count" (conc (write-to-string (getf photo :idx)) " of " (write-to-string (getf set :photo-count))))))
       (:div :class "photos"
        (:a
         :href (conc "/photos/" (getf photo :id))
         :class "slide"
         (:img :src (getf photo :medium) :alt (getf photo :description))))))))
