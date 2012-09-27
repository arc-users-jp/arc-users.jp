; Monky patch ;-)

(= epona-env* (aif (env "EPONA_ENV") sym.it 'devel))

(mac conf args
  `(do ,@(map (fn ((k v . alt))
                `(= ,k ,(aif (assoc epona-env* pair.alt) cadr.it v)))
              args)))

(def page args
  (let (attrs nodes) parse-attrs-nodes.args
    (<html 'lang (attrs 'lang "ja")
      (<head
        (<meta 'charset "utf-8")
        (<title (attrs 'title "Untitled Page"))
        (apply inc-css attrs!css)
        (map [apply <meta _] attrs!meta)
        (<link 'rel "shortcut icon" 'href (asset "/favicon.ico"))
        (map [apply <link _] attrs!link)
        (apply inc-js attrs!js)
        (html5shim)
        (awhen attrs!ga (ga it)))
      (<body 'id attrs!id nodes))))

(mac deflayout (name tit head foot (o additional-attrs) (o sep " | "))
  `(def ,name args
    (let (attrs nodes) (parse-attrs-nodes args)
      (fill-table attrs (list ,@additional-attrs))
      (= attrs!title (aif attrs!title (+ it ,sep ,tit) ,tit))
      (page attrs
        (<header 'id "header"  ,@head)
        (<div    'id "content" nodes)
        (<footer 'id "footer"  ,@foot)))))

(= pubdirs* (list (+ appdir* "/pub/")))

(def push-pubdir (path)
  (push (if (begins path "/")
            path
            (+ appdir* "/" path))
        pubdirs*))

(defmemo file-exists-in-pubdir (file)
  (awhen (re-replace "\\.v\\d*\\." string.file ".")
    (car:flat:map [file-exists:+ _ it] pubdirs*)))
