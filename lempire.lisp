(in-package #:lempire)

(setf *message-log-pathname*  "/tmp/message.log")
(setf *access-log-pathname*   "/tmp/access.log")

(setf *dispatch-table*
  (list
    (create-regex-dispatcher "^/$"            'root:index)
    (create-regex-dispatcher "^/blogs"        'blogs:index)
    (create-regex-dispatcher "^/photos$"      'photos:index)
    (create-regex-dispatcher "^/photos/\\d+"  'photos:photo)
    (create-regex-dispatcher "^/photos/.+"    'photos:photoset)
    (create-folder-dispatcher-and-handler "/images/" #p"/Users/glen/Projects/lisp/lempire/images/")
    (create-folder-dispatcher-and-handler "/css/" #p"/Users/glen/Projects/lisp/lempire/css/")))

; schema
(clsql:connect
  (list (namestring (asdf:system-relative-pathname :lempire "nempire.db")))
  :database-type :sqlite3)

(defun url-parts ()
  (rest (split "/" (first (split "\\?" (hunchentoot:request-uri*))))))

(defmacro standard-header ()
  `(htm
     (:div :id "header"
      (:img :class "profile" :src "/images/profile_top.png" :alt "Picture of Glen")
      (:a :class "home" :href "/" :alt "Home")
      (:ul :class "toc"
       (:li (:a :href "/blogs" "Blog"))
       (:li (:a :href "/blogs/tag/tech" "Tech"))
       (:li (:a :href "/photos" "Photos"))))))

(defmacro standard-footer ()
  `(htm
     (:div :id "footer"
      (:ul
       (:li (:a :href "http://facebook.co/tempire" "Facebook"))
       (:li (:a :href "http://flickr.com/photos/tempire" "Flickr"))
       (:li (:a :href "http://twitter.com/tempiretech" "Twitter"))
       (:li (:a :href "http://google.com/profiles/glen.hinkle" "Google+"))
       (:li (:a :href "http://zombiedolphin.com" "Zombie Dolphin"))
       (:li (:a :href "http://careers.stackoverflow.com/glen" "Resume"))
       (:li (:a :href "http://github.com/tempire" "Githubs"))
       (:li (:a :href "http://search.cpan.org/~tempire" "CPAN"))
       (:li (:a :href "http://mojocasts.com" "Mojocasts"))))))

(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent 0)
     (:html :xmlns "http://www.w3.org/1999/xhtml"
      :xml\:lang "en"
      :lang "en"
      (:head
       (:meta :http-equiv "Content-Type"
        :content    "text/html;charset=utf-8")
       (:title ,title)
       (:link :type  "text/css"
        :rel   "stylesheet"
        :media "screen"
        :href   "/css/main.css"))
      (:body
       (standard-header)
       (:div :id "main"
        (:div :id "box-top")
        (:div :id "content"
         (:div :class "fb_status"
          (:span :class "load statii" :content "status")
          (:span :class "time_since")
          (:span :class "source"))
         ,@body)
         (:div :id "box-bottom"))
        (standard-footer)))))
