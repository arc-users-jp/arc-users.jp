; GitHub Ribbons ---------------------------------------------------------------
; https://github.com/blog/273-github-ribbons

(= gh-ribbon-colors* (obj red    "aa0000" green "007200" darkblue "121621"
                          orange "ff7600" gray  "6d6d6d" white    "ffffff"))

(def gh-ribbon (id (o direction 'left) (o color 'red))
  (<a 'href (+ "https://github.com/" id) 'title "Fork me on GitHub"
    (<img 'style (+ "position:absolute;top:0;" direction ":0;border:0;")
          'src   (+ "https://s3.amazonaws.com/github/ribbons/forkme_"
                    direction "_" color "_" gh-ribbon-colors*.color ".png")
          'alt   "Fork me on GitHub")))

; GitHub Post-Receive Hooks ----------------------------------------------------
; https://help.github.com/articles/post-receive-hooks

; GitHub's post-request IP
(= gh-ips* '("207.97.227.253" "50.57.128.197" "108.171.174.178"))

(mac defghhook (path . body)
  `(defop (post ,path json) ()
     (if (in ctx!req!ip ,@gh-ips*)
         (let payload (fromjson arg!payload)
           ,@body
           "done")
         (badreq))))
