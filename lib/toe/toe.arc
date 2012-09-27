(push-pubdir "lib/toe/pub/")

; Icon -------------------------------------------------------------------------

; http://fortawesome.github.com/Font-Awesome/#roadmap
(= iconset* '(
  adjust align-center align-justify align-left align-right arrow-down arrow-left
  arrow-right arrow-up asterisk backward ban-circle bar-chart barcode beaker
  bell bold bolt book bookmark bookmark-empty briefcase bullhorn calendar camera
  camera-retro caret-down caret-left caret-right caret-up certificate check
  check-empty chevron-down chevron-left chevron-right chevron-up
  circle-arrow-down circle-arrow-left circle-arrow-right circle-arrow-up cloud
  cog cogs columns comment comment-alt comments comments-alt copy credit-card
  cut dashboard download download-alt edit eject envelope envelope-alt
  exclamation-sign external-link eye-close eye-open facebook facebook-sign
  facetime-video fast-backward fast-forward file film filter fire flag
  folder-close folder-open font forward fullscreen gift github github-sign glass
  globe google-plus google-plus-sign group hand-down hand-left hand-right
  hand-up hdd headphones heart heart-empty home inbox indent-left indent-right
  info-sign italic key leaf legal lemon link linkedin linkedin-sign list
  list-alt list-ol list-ul lock magic magnet map-marker minus minus-sign money
  move music off ok ok-circle ok-sign paper-clip paste pause pencil phone
  phone-sign picture pinterest pinterest-sign plane play play-circle plus
  plus-sign print pushpin qrcode question-sign random refresh remove
  remove-circle remove-sign reorder repeat resize-full resize-horizontal
  resize-small resize-vertical retweet road rss save screenshot search share
  share-alt shopping-cart sign-blank signal signin signout sitemap sort
  sort-down sort-up star star-empty star-half step-backward step-forward stop
  strikethrough table tag tags tasks text-height text-width th th-large th-list
  thumbs-down thumbs-up time tint trash trophy truck twitter twitter-sign
  umbrella underline undo unlock upload upload-alt user user-md volume-down
  volume-off volume-up warning-sign wrench zoom-in zoom-out))

(mac icon (name (o large))
  (unless (find testify.name iconset*)
    (err "Unknown icon" name))
  `(<i 'class ,(string "icon-" name (when large " icon-large")) ""))

(def caret ()
  (<b 'class "caret" ""))

; TODO
(def dropdown args
  (<ul 'class "dropdown-menu"
    (map (fn ((x y))
           (if (acons y)
               (<li 'class "dropdown-submenu"
                 (<a 'tabindex "-1" 'href "#" x)
                 (dropdown y t))
               (<li (<a 'tabindex "-1" 'href y x))))
         car.args)))
