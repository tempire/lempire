(in-package #:blogs)

(defun index ()
  (lempire:standard-page (:title "Phased blog")
    (:ul :id "blogs"
     (loop for post in (lempire-schema:personal-blog-posts) do
      (htm
        (:li :id (getf post :url-title) :class "blog snippet"
         (:a :name (concatenate 'string "id" (write-to-string (getf post :id))))
         (:a :name (getf post :url-title))
         (:h2
          (:a :class "more" :href (concatenate 'string "/blogs/" (getf post :url-title)) (str (getf post :title))))
         (:div :class "tags"
          (loop for tag in (getf post :tags) do
                (htm (:span :class "tag" (str (getf post :name))))))
         (:h3 :class "subtitle" (str (getf post :subtitle)))
         (:h3 :class "time" :title "")
         (:div :class "content snippet"
          (str (getf post :snippet))
          (:a :class "more" :href (concatenate 'string "/blogs/" (getf post :url-title)) "More"))))))))
