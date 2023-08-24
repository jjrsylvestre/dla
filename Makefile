SOURCES = \
  $(wildcard src/*.ptx) $(wildcard src/*.tex) \
  $(wildcard src/*/*.ptx) $(wildcard src/*/*.tex) \
  $(wildcard src/*/*/*.ptx) $(wildcard src/*/*/*.tex) \
  $(wildcard src/*/*/*/*.ptx) $(wildcard src/*/*/*/*.tex)
# I think that's as deep as things go...

BRANDLOGO=AUG-Colour.png
ROOTDOCNAME=book
SERVEPORT=8080
BUILDDIR=${XDG_RUNTIME_DIR}/pretext/DLA
#PRETEXT=/opt/pretext/pretext/pretext
PRETEXT=./pretext/pretext/pretext

HTML_TARGETS = two-semester-html one-semester-html
HTML_CLEAN_TARGETS = two-semester-html-clean one-semester-html-clean
IMAGE_TARGETS = two-semester-html-images one-semester-html-images
IMAGE_CLEAN_TARGETS = two-semester-html-images-clean one-semester-html-images-clean
LATEX_TARGETS = two-semester-latex one-semester-latex two-semester-print-latex one-semester-print-latex
.PHONY: ptx two-semester-html-all one-semester-html-all \
  $(HTML_TARGETS) $(HTML_CLEAN_TARGETS) \
  $(IMAGE_TARGETS) $(IMAGE_CLEAN_TARGETS) \
  $(LATEX_TARGETS) \
  clean ptx-clean html-images-clean \
  html-serve validate-xml \
  help list

list: help
help:
	@echo "= TARGETS =========================================================================================="
	@echo "> validate-xml                  : Check for XML syntax/format errors."
	@echo "                                  (Does not validate against PTX schema.)"
	@echo "> two-semester-html-all         : Perform all steps necessary to create HTML version of the book"
	@echo "                                  containing all chapters."
	@echo "> one-semester-html-all         : Perform all steps necessary to create HTML version of the book"
	@echo "                                  containing chapters for a one-semester course."
	@echo "                                  one-semester course."
	@echo "> two-semester-html             : Output HTML files containing all chapters."
	@echo "> one-semester-html             : Output HTML files containing chapters for a one-semester course."
	@echo "> two-semester-html-images      : Create SVG image files to accompany the html output for all"
	@echo "                                  chapters."
	@echo "> one-semester-html-images      : Create SVG image files to accompany the html output for chapters"
	@echo "                                  for a one-semester course."
	@echo "> html-serve                    : Fire up a simple Python web server to locally host the HTML"
	@echo "                                  output."
	@echo "> two-semester-latex            : Output LaTeX file containing chapters for a two-semester course."
	@echo "                                  (Electronic pdf version)"
	@echo "> two-semester-print-latex      : Output LaTeX file containing chapters for a two-semester course."
	@echo "                                  (Print pdf version)"
	@echo "> one-semester-latex            : Output LaTeX file containing chapters for a one-semester course."
	@echo "                                  (Electronic pdf version)"
	@echo "> one-semester-print-latex      : Output LaTeX file containing chapters for a one-semester course."
	@echo "                                  (Print pdf version)"
	@echo "> ptx                           : Only preprocess source to create a single XML file in PTX format"
	@echo "                                  containing all chapters."
	@echo "> clean                         : Remove all output files."
	@echo "> ptx-clean                     : Remove preprocessed PTX output."
	@echo "> two-semester-html-clean       : Remove all HTML output."
	@echo "> one-semester-html-clean       : Ditto."
	@echo "> two-semester-html-images-clean: Remove all accomanying SVG files."
	@echo "> one-semester-html-images-clean: Ditto."
	@echo "= PARAMETERS ======================================================================================="
	@echo "> BUILDDIR : Root directory for all output files."
	@echo "             [Default: $(BUILDDIR)]"
	@echo "> BRANDLOGO: Filename of institutional logo. Needs to exist in images/."
	@echo "             [Default: $(BRANDLOGO)]"
	@echo "> PRETEXT  : Path to pretext compilation script."
	@echo "             [Default: $(PRETEXT)]"
	@echo "> SERVEPORT: Local port on which to serve HTML output when using the html-serve target."
	@echo "             [Default: $(SERVEPORT)]"

two-semester-html-all: two-semester-html two-semester-html-images
one-semester-html-all: one-semester-html one-semester-html-images

clean: ptx-clean html-clean html-images-clean

ptx-clean:
	@-rm -f ${BUILDDIR}/ptx/*.ptx

ptx: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
$(HTML_TARGETS): %-html: ${BUILDDIR}/ptx/publication-%-html.xml ${BUILDDIR}/html/%/.sentinal
$(IMAGE_TARGETS): %-html-images: ${BUILDDIR}/ptx/publication-%-html.xml ${BUILDDIR}/html/%/images/.sentinal
$(LATEX_TARGETS): %-latex: ${BUILDDIR}/ptx/publication-%-latex.xml ${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex

$(HTML_CLEAN_TARGETS): %-html-clean:
	@-rm -f ${BUILDDIR}/html/${*}/.sentinal.*
	@-rm -f ${BUILDDIR}/html/${*}/*.html
	@-rm -f ${BUILDDIR}/html/${*}/knowl/*.html
$(IMAGE_CLEAN_TARGETS): %-html-images-clean:
	@-rm -f ${BUILDDIR}/html/${*}/images/.sentinal.*
	@-rm -f ${BUILDDIR}/html/${*}/images/*.svg

${BUILDDIR}/ptx/publication-%.xml: publication/%.xml $(wildcard publication/include.d/*.xml)
	@echo "Compiling publication file"
	@mkdir -p ${BUILDDIR}/ptx
	@xsltproc \
	  --xinclude \
	  --output ${BUILDDIR}/ptx/publication-${*}.xml \
	  ./one-file.xsl publication/${*}.xml

${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx: $(SOURCES) one-file.xsl | validate-xml
	@echo "Preprocessing PTX-->PTX, output will be placed in ${BUILDDIR}/ptx..."
	@mkdir -p ${BUILDDIR}/ptx
	@echo "...calling xsltproc to create single-file PreTeXt document"
	@xsltproc \
	  --xinclude \
	  --output ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx \
	  ./one-file.xsl src/${ROOTDOCNAME}.ptx
	@echo "...DONE"

${BUILDDIR}/html/%/.sentinal: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Converting PTX to HTML for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/${*}/.sentinal
	@mkdir -p ${BUILDDIR}/html/${*}/knowl
#	@echo "...html fixups"
#	@./make.d/html/fixups.sh ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
#	@mv ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx.html-fixup ${BUILDDIR}/ptx/${ROOTDOCNAME}-html.ptx
	@echo "...calling pretext to compile PreTeXt document"
	@$(PRETEXT) \
	  --verbose \
	  --component all \
	  --format html \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-html.xml \
	  --parameters \
		html.css.extra dla.css \
	  --directory ${BUILDDIR}/html/${*}/ \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
#	  ${BUILDDIR}/ptx/${ROOTDOCNAME}-html.ptx
	@echo "...copying css style customizations"
	@cp css/dla.css ${BUILDDIR}/html/${*}/
	@echo "...copying fonts"
	@mkdir -p ${BUILDDIR}/html/${*}/fonts
	@cp stixfonts/fonts/static_otf_woff2/*.woff2 ${BUILDDIR}/html/${*}/fonts/
	@sed -i -e 's/scale: [0-9]*,/scale: 100,/' ${BUILDDIR}/html/${*}/*.html
	@touch ${BUILDDIR}/html/${*}/.sentinal
	@echo "...DONE"
	@echo "Now call:"
	@echo "   make ${*}-html-images  (to build SVG images)"
	@echo "   make html-serve               (to serve the output locally for previewing)"

${BUILDDIR}/html/%/images/.sentinal: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Generating SVG files for HTML output for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/${*}/images/.sentinal
	@mkdir -p ${BUILDDIR}/html/${*}/images
	@echo "...calling pretext to generate images"
	@$(PRETEXT) \
	  --verbose \
	  --component latex-image \
	  --format svg \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-html.xml \
	  --directory ${BUILDDIR}/html/${*}/images \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...copying institution logo"
	@-cp images/${BRANDLOGO} ${BUILDDIR}/html/${*}/images
	@touch ${BUILDDIR}/html/${*}/images/.sentinal
	@echo "...DONE"

${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Converting PTX to LATEX for version: ${*}..."
	@mkdir -p ${BUILDDIR}/latex
	@echo "...calling pretext to compile PreTeXt document"
	@${PRETEXT} \
	  --XSL style-latex.xsl \
	  --component all \
	  --format latex \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-latex.xml \
	  --output ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...applying adjustments from ./make.d/latex/"
	@./make.d/latex/fourier-font.sh ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex
	@./make.d/latex/fix-colophon-website.sh ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex
	@./make.d/latex/page-breaks.sh ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex
	@echo "...DONE"


html-serve:
	@./scripts/serve.py ${BUILDDIR}/html $(SERVEPORT) 2>/dev/null

validate-xml: $(SOURCES)
	@echo "Validating xml..."
	@xmllint --xinclude src/${ROOTDOCNAME}.ptx | xmllint --noout -
	@mkdir -p ${BUILDDIR}
	@echo "...DONE"
