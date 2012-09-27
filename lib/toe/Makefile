LICENSE='/*! LICENSE: https://raw.github.com/mgiken/toe/master/LICENSE */'

all: setup toe

# Setup dependencies vendor libraries ------------------------------------------

setup: jquery bootstrap font-awesome

jquery: ven/jquery/jquery-latest.js
ven/jquery/jquery-latest.js:
	mkdir -p ven/jquery
	curl -o ven/jquery/jquery-latest.js http://code.jquery.com/jquery-latest.js

bootstrap: ven/bootstrap
ven/bootstrap:
	git clone git://github.com/twitter/bootstrap.git ven/bootstrap

font-awesome: ven/font-awesome
ven/font-awesome:
	git clone git://github.com/FortAwesome/Font-Awesome.git ven/font-awesome

# Build Toe --------------------------------------------------------------------

toe: css_min js_min font

css:
	mkdir -p pub/css
	recess --compile res/less/toe.less >pub/css/toe.css

css_min: css
	recess --compress res/less/toe.less >pub/css/toe.min.css

js:
	mkdir -p pub/js pub/js/tmp
	echo ${LICENSE} >pub/js/tmp/license.js
	echo >>pub/js/tmp/license.js
	cp ven/jquery/jquery-latest.js pub/js/tmp/jquery.js
	cat ven/bootstrap/js/bootstrap-transition.js ven/bootstrap/js/bootstrap-alert.js ven/bootstrap/js/bootstrap-button.js ven/bootstrap/js/bootstrap-carousel.js ven/bootstrap/js/bootstrap-collapse.js ven/bootstrap/js/bootstrap-dropdown.js ven/bootstrap/js/bootstrap-modal.js ven/bootstrap/js/bootstrap-tooltip.js ven/bootstrap/js/bootstrap-popover.js ven/bootstrap/js/bootstrap-scrollspy.js ven/bootstrap/js/bootstrap-tab.js ven/bootstrap/js/bootstrap-typeahead.js ven/bootstrap/js/bootstrap-affix.js >pub/js/tmp/bootstrap.js
	coffee --compile --output pub/js/tmp res/coffee
	cat pub/js/tmp/license.js pub/js/tmp/jquery.js pub/js/tmp/bootstrap.js pub/js/tmp/jquery.taginput.js >pub/js/toe.js
	rm -rf pub/js/tmp

js_min: js
	echo -n ${LICENSE} >pub/js/license.js
	uglifyjs -nc pub/js/toe.js >pub/js/toe.min.tmp.js
	cat pub/js/license.js pub/js/toe.min.tmp.js >pub/js/toe.min.js
	rm -rf pub/js/license.js pub/js/toe.min.tmp.js

font: pub/font
pub/font:
	cp -r ven/font-awesome/font pub/

clean:
	rm -rf ven/* pub/*
