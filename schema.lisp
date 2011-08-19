(in-package #:lempire-schema)

;tables
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
       :accessor id
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

(def-view-class blogs ()
    ((id
       :accessor id 
       :db-kind :key
       :db-constraints :not-null
       :type integer
       :initarg :id)
     (title
       :accessor title 
       :db-constraints :not-null
       :type (string 100)
       :initarg :title)
     (subtitle
       :accessor subtitle
       :type (string 255)
       :initarg :subtitle)
     (content
       :accessor content
       :db-constraints :not-null
       :type (string 255)
       :initarg :content)
     (created-time
       :accessor created-time
       :db-constraints :not-null
       :type integer
       :initarg :created-time)
     (timestamp
       :accessor timestamp
       :type (string 100)
       :initarg :timestamp)
     (location
       :accessor location
       :type (string 100)
       :initarg :location)
     (tags
       :accessor tags
       :db-kind :join
       :db-info (:join-class blog-tags
                 :home-key id
                 :foreign-key blog
                 :set t)))
    (:base-table blogs))

(def-view-class blog-tags ()
    ((id
       :db-kind :key
       :db-constraints :not-null
       :type integer
       :initarg :id)
     (name
       :db-constraints :not-null
       :accessor name
       :name (string 50)
       :initarg :title)
     (blog
       :accessor blog
       :type (string 255)
       :initarg :blog))
    (:base-table blog_tags))

; enable [fieldname]/clsql functional syntax
(clsql:locally-enable-sql-reader-syntax)

(defmacro one-value (query)
  `(first (first ,query)))

(defmacro make-db-plist (query)
  `(multiple-value-bind (results fields)
    ,query
    (loop for value in results collect
      (loop for name in fields append (list
        (make-keyword name) (pop value))))))

(defun make-keyword (name)
  (intern (string-upcase name) :keyword))

(defun photoset-id-from-name (name)
  (parse-integer
    (one-value
      (select [id] :from [photosets] :where [= [slot-value 'photosets 'title] name]))))

; photoset id from name or id
(defun photoset-id (identifier)
  (when (integerp identifier) (return-from photoset-id identifier))
  (if (parse-integer identifier :junk-allowed t)
    (parse-integer identifier)
    (photoset-id-from-name identifier)))

; all photos from photoset
(defun photoset-photos (identifier)
  (make-db-plist
    (select [id] [medium] [square] :from [photos] :where [= [slot-value 'photos 'photoset]
                                                            (photoset-id identifier)])))

; one photo
(defun photo (id)
  (let ((plist
       (first (make-db-plist (select [id] [medium] [square] [idx] [photoset] [description] :from [photos] :where [= [slot-value 'photos 'id] id])))))
    (append plist `(:set ,(photoset (getf plist :photoset))))))

; faces of glen photoset
(defun faces-of-glen-photos ()
  (photoset-photos "72157618164628634"))

(defun photoset-count ()
  (one-value (select [count [*]] :from [photosets])))

; combined defeneric w/ defmethods
(defgeneric url-title (thing)
            (:documentation "Title formatted for a URL")
            (:method ((set photosets)) (title set))
            (:method ((set blogs))     (title set)))

; separate defgeneric and defmethods
(defgeneric photo-count (set)
            (:documentation "Number of photos in photoset"))

(defmethod photo-count ((set photosets))
  (one-value (select [count [*]] :from [photos] :where
          [= [slot-value 'photos 'photoset] ])))

(defmethod primary_photo :around ((set photosets))
  (first (make-db-plist (select [id] [square] [region]
                         :from [photos]
                         :where [= [slot-value 'photos 'id] (slot-value set 'primary_photo)]))))

(defun photoset (photoset)
  (let ((set (first (first (select 'photosets :where [= [slot-value 'photosets 'id] (photoset-id photoset)])))))
    `(
      :id ,(id set)
      :photo-count ,(photo-count set)
      :url-title ,(url-title set)
      :title ,(title set)
      :region ,(getf (primary_photo set) :region)
      :square ,(getf (primary_photo set) :square))))

(defun photosets ()
  (loop for set in (select 'photosets) collect `(
                                                 :id ,(id (first set))
                                                 :photo-count ,(photo-count (first set))
                                                 :url-title ,(url-title (first set))
                                                 :title ,(title (first set))
                                                 :region ,(getf (primary_photo (first set)) :region)
                                                 :square ,(getf (primary_photo (first set)) :square))))

; TODO
; date month_name
; date year

(defun latest-blog-post ()
  (let ((post (one-value (select 'blogs :where [and
                          [= [slot-value 'blogs 'id] [slot-value 'blog-tags 'blog]]
                          [<> [slot-value 'blog-tags 'name] "hidden"]]
          :group-by [slot-value 'blogs 'id]
          :order-by '([created-time] :desc)
          :limit 1))))
    (list
      :title (title post)
      :timestamp (timestamp post))))

(defun blog-post-tags (blog-id)
  :documentation "List of tag names associated with blog-id"
  (loop for name in (select [name] :from [blog-tags] :where [= [slot-value 'blog-tags 'blog] blog-id])
        append name))

(defun personal-blog-posts ()
  (loop for (post . nil) in (select 'blogs
                                     :where [and
                                              [= [slot-value 'blogs 'id] [slot-value 'blog-tags 'blog]]
                                              [= [slot-value 'blog-tags 'name] "personal"]
                                              [<> [slot-value 'blog-tags 'name] "hidden"]]
                                     :group-by [slot-value 'blogs 'id]
                                     :order-by '([created-time] :desc))
        collect (list
                  :id (id post)
                  :title (title post)
                  :url-title (url-title post)
                  :subtitle (subtitle post)
                  :snippet (title post)
                  :tags (blog-post-tags (id post)))))

; leaving [fieldname]/clsql functional syntax enabled
; causes problem in dev mode
(clsql:disable-sql-reader-syntax)
