(require "url.arc")
(require "markdown.arc")
(require "lib/patch.arc")
(require "lib/util.arc")
(require "lib/git.arc")
(require "lib/gh.arc")
(require "lib/toe/toe.arc")

(conf
  (sitename* "Arc-users.jp (Devel)" prod "Arc-users.jp")
  (wikirepo* "git://github.com/arc-users-jp/arc-users.jp-wiki.git")
  (wikidir*  "/tmp/arc-users-jp-wiki")
  (ga*       nil prod "UA-35127763-1")
  (port*     8090)
  )

(def pagelist (base (o parent ""))
  (rem nil (map [let x (subst "" ".md" _)
                  (aif (dir-exists:+ base "/" x)
                       (list upcase1.x (pagelist it (+ parent "/" x)))
                       (list upcase1.x (url (parent x))))]
                (dir base))))

(defmemo wikifile (s)
  (file-exists:+ wikidir* "/pages/" (check urldecode.s ~empty "home") ".md"))

(defmemo wikititle (s)
  (string:intersperse " > " (map upcase1 (tokens urldecode.s #\/))))

(deflayout wikipage sitename*

  ((<div 'class "navbar navbar-fixed-top"
     (<div 'class "navbar-inner"
       (<div 'class "container")
         (<a 'class "brand" 'href "/" sitename*)
         (<ul 'class "nav"
           (<li 'class "dropdown"
             (<a 'class "dropdown-toggle" 'data-toggle "dropdown" 'href "#"
                 "ページ一覧" (caret))
             (dropdown:pagelist:+ wikidir* "/pages"))))))

  ((<div 'class "container"
     (<span "テキストは"
            (<a 'href "http://creativecommons.org/licenses/by-sa/3.0/deed.ja"
                "クリエイティブ・コモンズ 表示-継承ライセンス")
             "の下で利用可能です。")
     (<span 'class "pull-right" "Powered by Arc"))
   (gh-ribbon 'arc-users-jp 'right))

  ('css (list "toe.min" "app.min")
   'js  (list "toe.min")
   'ga  ga*)

  )

(defp / ()
  (seeother "/home"))

(defp "/(.*)" (path)
  (aif (wikifile path)
       (wikipage 'title (wikititle path)
         (<div 'class "container"
           (<div 'class "span10 offset1"
                 (raw:markdown:filechars it))))
       (notfound)))

(defghhook /wiki/pull
  (git-pull wikidir*))

(git-clone wikirepo* wikidir*)
(git-pull wikidir*)
