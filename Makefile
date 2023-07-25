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
LATEX_TARGETS = two-semester-latex one-semester-latex two-semester-print-latex one-semester-print-latex
IMAGE_TARGETS = two-semester-html-images one-semester-html-images
.PHONY: ptx two-semester-html-all one-semester-html-all \
  $(HTML_TARGETS) $(LATEX_TARGETS) $(IMAGE_TARGETS) \
  clean ptx-clean html-clean html-images-clean \
  html-serve validate-xml \
  help list

list: help
help:
	@echo "= TARGETS =========================================================================================="
	@echo "> validate-xml            : Check for XML syntax/format errors."
	@echo "                            (Does not validate against PTX schema.)"
	@echo "> two-semester-html-all   : Perform all steps necessary to create HTML version of the book"
	@echo "                            containing all chapters."
	@echo "> one-semester-html-all   : Perform all steps necessary to create HTML version of the book"
	@echo "                            containing chapters for a one-semester course."
	@echo "                            one-semester course."
	@echo "> two-semester-html       : Output (only) HTML files containing all chapters."
	@echo "> one-semester-html       : Output (only) HTML files containing chapters for a one-semester course."
	@echo "> two-semester-html-images: Create SVG image files to accompany the html output for all chapters."
	@echo "> one-semester-html-images: Create SVG image files to accompany the html output for chapters for a"
	@echo "                            one-semester course."
	@echo "> html-serve              : Fire up a simple Python web server to locally host the HTML output."
	@echo "> two-semester-latex      : Output (only) LaTeX file containing chapters for a two-semester course."
	@echo "                            (Electronic pdf version)"
	@echo "> two-semester-print-latex: Output (only) LaTeX file containing chapters for a two-semester course."
	@echo "                            (Print pdf version)"
	@echo "> one-semester-latex      : Output (only) LaTeX file containing chapters for a one-semester course."
	@echo "                            (Electronic pdf version)"
	@echo "> one-semester-print-latex: Output (only) LaTeX file containing chapters for a one-semester course."
	@echo "                            (Print pdf version)"
	@echo "> ptx                     : Only preprocess source to create a single XML file in PTX format"
	@echo "                            containing all chapters."
	@echo "> clean                   : Remove all output files."
	@echo "> ptx-clean               : Remove preprocessed PTX output."
	@echo "> html-clean              : Remove all HTML output."
	@echo "> html-images-clean       : Remove all accomanying SVG files."
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
html-clean:
	@-rm -f ${BUILDDIR}/html/.sentinal.*
	@-rm -f ${BUILDDIR}/html/*.html
	@-rm -f ${BUILDDIR}/html/knowl/*.html
html-images-clean:
	@-rm -f ${BUILDDIR}/html/images/.sentinal.*
	@-rm -f ${BUILDDIR}/html/images/*.svg

ptx: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
$(HTML_TARGETS): %-html: ${BUILDDIR}/ptx/publication-%-html.xml ${BUILDDIR}/html/%/.sentinal
$(IMAGE_TARGETS): %-html-images: ${BUILDDIR}/html/%/images/.sentinal
$(LATEX_TARGETS): %-latex: ${BUILDDIR}/ptx/publication-%-latex.xml ${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex

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
	@echo "...copying css style customizations"
	@cp css/dla.css ${BUILDDIR}/html/${*}/
	@echo "...copying fonts"
	@cp stixfonts/fonts/static_otf_woff2/*.woff2 ${BUILDDIR}/html/${*}/
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
	  --component all \
	  --format latex \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-latex.xml \
	  --output ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@sed -i \
	  -e 's|newtcolorbox\[use counter from=block\]{warning|newtcolorbox[use counter from=block]{warningenv|' \
	  -e 's|begin{warning|begin{warningenv|g' \
	  -e 's|end{warning|end{warningenv|g' \
	  -e 's|\\usepackage{fontspec}|%\\usepackage{fontspec}|' \
	  -e 's|usepackage{lmodern|usepackage{fouriernc|' \
	  ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex
	@echo "...DONE"

html-serve:
	@./scripts/serve.py ${BUILDDIR}/html $(SERVEPORT) 2>/dev/null

validate-xml: $(SOURCES)
	@echo "Validating xml..."
	@xmllint --xinclude src/${ROOTDOCNAME}.ptx | xmllint --noout -
	@mkdir -p ${BUILDDIR}
	@echo "...DONE"
