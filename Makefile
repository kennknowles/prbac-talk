TALK=prbac-talk
XELATEX=/usr/texbin/xelatex

# Note: for image paths to work, pandoc must be run from this directory :-/

all: $(TALK).html 

$(TALK).html: $(TALK).md Makefile
	pandoc \
		--to=slidy \
		--standalone \
		--section-divs \
		--smart \
		--mathjax='js/vendor/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML' \
		--toc \
		--output="$(TALK).html" \
		$(TALK).md

