all: assets

assets: img css_min

img:
	optipng -o7 pub/img/*.png

css:
	recess --compile --inlineImages res/less/app.less >pub/css/app.css

css_min: css
	recess --compress --inlineImages res/less/app.less >pub/css/app.min.css
