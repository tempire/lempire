(in-package #:lempire-schema)

(def-view-class photos ()
   ((id
      :db-kind :key
      :db-constraints :not-null
      :type (string 20)
      :initarg :id
      :accessor id)
    (description
      :accessor description
      :type (string 255)
      :initarg :description)
    (lat
      :accessor lat
      :type (string 10)
      :initarg :lat)
    (lon
      :accessor lon
      :type (string 10)
      :initarg :lon)
    (region
      :accessor region
      :type (string 20)
      :initarg :region)
    (locality
      :accessor locality
      :type (string 20)
      :initarg :locality)
    (country
      :accessor country
      :type (string 20)
      :initarg :country)
    (square :accessor square
      :type (string 255)
      :initarg :square)
    (original_url
      :accessor original_url
      :type (string 255)
      :initarg :original_url)
    (taken
      :accessor taken
      :type (string 20)
      :initarg :taken)
    (isprimary
      :accessor isprimary
      :type (string 1)
      :initarg :isprimary)
    (small
      :accessor small
      :type (string 255)
      :initarg :small)
    (medium
      :accessor medium
      :type (string 255)
      :initarg :medium)
    (original
      :accessor original
      :type (string 255)
      :initarg :original)
    (thumbnail
      :accessor thumbnail
      :type (string 255)
      :initarg :thumbnail)
    (large
      :accessor large
      :type (string 255)
      :initarg :large)
    (is_glen
      :accessor is_glen
      :type (string 1)
      :initarg :is_glen)
    (idx
      :accessor idx
      :type integer
      :initarg :idx)
    (photoset
      :accessor photoset
      :type (string 20)
      :initarg :photoset))
   (:base-table photos))

(def-view-class photosets ()
    ((id
       :db-kind :key
       :db-constraints :not-null
       :type (string 20)
       :initarg :id)
     (title
       :accessor title
       :type (string 255)
       :initarg :title)
     (server
       :accessor server
       :type (string 10)
       :initarg :server)
     (farm
       :accessor farm
       :type integer
       :initarg :farm)
     (photos
       :accessor photos
       :type integer
       :initarg :photos)
     (videos
       :accessor videos
       :type integer
       :initarg :videos)
     (secret
       :accessor secret
       :type (string 20)
       :initarg :secret)
     (primary_photo
       :accessor primary_photo
       :type (string 20)
       :initarg :primary_photo)
     (idx
       :accessor idx
       :type integer
       :initarg :idx)
     (description
       :accessor description
       :type (string 255)
       :initarg :description)
     (timestamp
       :reader timestamp
       :type (string 20)))
    (:base-table photosets))

(clsql:locally-enable-sql-reader-syntax)

(defun photoset-id-from-name (name)
  (parse-integer
    (one-value
      (select [id] :from [photosets] :where [= [slot-value 'photosets 'title] name]))))

(defun photoset-id (identifier)
  (when (integerp identifier) (return-from photoset-id identifier))
  (if (parse-integer identifier :junk-allowed t)
    (parse-integer identifier)
    (photoset-id-from-name identifier)))

(defun photoset-photos (id)
  (loop for record in
        (select [id] [medium] [square] :from [photos] :where [= [slot-value 'photos 'photoset]
                                                                (photoset-id id)])
        collect `(
                  :id     ,(first record)
                  :medium ,(second record)
                  :square ,(third record))))

(defun faces-of-glen-photos ()
  (photoset-photos "72157618164628634"))

(defmacro one-value (query)
  `(first (first ,query)))

(clsql:disable-sql-reader-syntax)

;(clsql:disable-sql-reader-syntax)

;(defmacro standard-page ((&key title) &body body)
  ;`(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     ;(:html :xmlns "http://www.w3.org/1999/xhtml"
            ;:xml\:lang "en"
            ;:lang "en"
            ;(:head
              ;(:meta :http-equiv "Content-Type"
                     ;:content    "text/html;charset=utf-8")
              ;(:title ,title)
              ;(:link :type  "text/css"
                     ;:rel   "stylesheet"
                     ;:ref   "/main.css"))
            ;(:body ,@body))))

;(clsql:disconnect :database (clsql:find-database "../retro.db"))

;(clsql:connect "retro.db" :database-type :sqlite3)

; Creates table
;(clsql:drop-view-from-class 'employee)

; create clos instance
;(clsql:create-view-from-class 'photos)
;(clsql:create-view-from-class 'photosets)

;(defvar e1 (make-instance 'employee
  ;:id 1
  ;:fname "Glen Hinkle"
  ;:company 100))

;(clsql:update-records-from-instance e1)
