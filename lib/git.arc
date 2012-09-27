(require "sh.arc")

(mac exec args
  `(trim:tostring:system:string ,@args))

(mac exec-quiet args
  `(system:string ,@args " >/dev/null 2>&1"))

(def git-clone (repo path)
  (unless (dir-exists path)
    (exec-quiet "git clone" (escshargs repo path))))

(def git-pull (path)
  (exec-quiet "cd" (escshargs path) ";git pull"))
