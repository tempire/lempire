(in-package #:lempire)

(setf *message-log-pathname* "/tmp/message.log")
(setf *access-log-pathname* "/tmp/access.log")

(setf *dispatch-table*
  (list
    (create-regex-dispatcher "^/css"    'css)
    (create-regex-dispatcher "^/"       'root:index)
    (create-regex-dispatcher "^/blogs"  'blogs:index)
    (create-regex-dispatcher "^/photos" 'photos:index)))

; schema
(clsql:connect
  (list (namestring (asdf:system-relative-pathname :lempire "nempire.db")))
  :database-type :sqlite3)

;(clsql:locally-enable-sql-reader-syntax)

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
                     :ref   "/main.css"))
            (:body ,@body))))

(defun css ()
  (setf (content-type* *reply*) "text/css")
  (css-lite:css
    (("body")
     (:width "70%" :margin "0 auto" :font-family "sans-serif"
      :border "1px solid #ccc"
      :border-top "none"))
    (("h1")
     (:font-size "140%" :text-align "center"))
    (("h2")
     (:color "#000" :background-color "#cef" :margin "0 auto" :padding "4px 0"))
    (("#header")
     (:background-coloro "#cef" :padding "8px")
     )
    (("#header .logo")
     (:display "block" :margin "0 auto"))
    (("#header .strapline")
     (:display "block" :text-align "center" :font-size "80%" :font-style "italic"))))
