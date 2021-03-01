SOURCES = \
  $(wildcard src/*.xml) $(wildcard src/*.tex) \
  $(wildcard src/*/*.xml) $(wildcard src/*/*.tex) \
  $(wildcard src/*/*/*.xml) $(wildcard src/*/*/*.tex) \
  $(wildcard src/*/*/*/*.xml) $(wildcard src/*/*/*/*.tex)
# I think that's as deep as things go...

BRANDLOGO=AUG-Colour.png
ROOTDOCNAME=book
SERVEPORT=8080
BUILDDIR=${XDG_RUNTIME_DIR}/pretext/DLA
#PRETEXT=/opt/pretext/pretext/pretext
PRETEXT=./pretext/pretext/pretext

PTX_TARGETS = twosemester-ptx onesemester-ptx
HTML_TARGETS = twosemester-html onesemester-html
LATEX_TARGETS = twosemester-latex onesemester-latex
IMAGE_TARGETS = twosemester-html-images onesemester-html-images
.PHONY: twosemester-html-all onesemester-html-all \
  clean ptx-clean html-clean html-images-clean \
  $(PTX_TARGETS) $(HTML_TARGETS) $(LATEX_TARGETS) $(IMAGE_TARGETS) \
  html-fonts html-serve validate-xml \
  help list

list: help
help:
	@echo "== TARGETS ==============="
	@echo "> validate-xml           : Check for XML syntax/format errors. (Does not validate against PTX schema.)"
	@echo "> twosemester-html-all   : Perform all steps necessary to create HTML version of the book containing all chapters."
	@echo "> onesemester-html-all   : Perform all steps necessary to create HTML version of the book containing chapters for a one-semester course."
	@echo "> twosemester-html       : Output (only) HTML files containing all chapters."
	@echo "> onesemester-html       : Output (only) HTML files containing chapters for a one-semester course."
	@echo "> twosemester-html-images: Create SVG image files to accompany the html output for all chapters."
	@echo "> onesemester-html-images: Create SVG image files to accompany the html output for chapters for a one-semester course."
	@echo "> html-fonts             : Copy STIX2Text fonts into the HTML build directory."
	@echo "> html-serve             : Fire up a simple Python web server to locally host the HTML output."
	@echo "> onesemester-latex      : Output (only) LaTeX file containing chapters for a one-semester course."
	@echo "> twosemester-ptx        : Only preprocess source to create a single XML file in PTX format containing all chapters."
	@echo "> onesemester-ptx        : Only preprocess source to create a single XML file in PTX format containing chapters for a one-semester course."
	@echo "> clean                  : Remove all output files."
	@echo "> ptx-clean              : Remove preprocessed PTX output."
	@echo "> html-clean             : Remove all HTML output."
	@echo "> html-images-clean      : Remove all accomanying SVG files."
	@echo "== PARAMETERS ============"
	@echo "> BUILDDIR : Root directory for all output files. [Default: $(BUILDDIR)]"
	@echo "> BRANDLOGO: Filename of institutional logo. Needs to exist in images/. [Default: $(BRANDLOGO)]"
	@echo "> PRETEXT  : Path to pretext compilation script [Default: $(PRETEXT)]"
	@echo "> SERVEPORT: Local port on which to serve HTML output when using the html-serve target. [Default: $(SERVEPORT)]"

twosemester-html-all: twosemester-html twosemester-html-images html-fonts
onesemester-html-all: onesemester-html onesemester-html-images html-fonts

clean: ptx-clean html-clean html-images-clean

ptx-clean:
	@-rm -f ${BUILDDIR}/ptx/.sentinal.*
	@-rm -f ${BUILDDIR}/ptx/*.ptx
html-clean:
	@-rm -f ${BUILDDIR}/html/.sentinal.*
	@-rm -f ${BUILDDIR}/html/*.html
	@-rm -f ${BUILDDIR}/html/knowl/*.html
html-images-clean:
	@-rm -f ${BUILDDIR}/html/images/.sentinal.*
	@-rm -f ${BUILDDIR}/html/images/*.svg

$(PTX_TARGETS): %-ptx: ${BUILDDIR}/ptx/${ROOTDOCNAME}-%.ptx preprocess.xsl
$(HTML_TARGETS): %-html: ${BUILDDIR}/html/.sentinal.% html-out.xml
$(IMAGE_TARGETS): %-html-images: ${BUILDDIR}/html/images/.sentinal.%
$(LATEX_TARGETS): %-latex: ${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex

${BUILDDIR}/ptx/${ROOTDOCNAME}-%.ptx: $(SOURCES) | validate-xml
	@echo "Preprocessing PTX*-->PTX for selected version ${*}, output will be placed in ${BUILDDIR}/ptx..."
	@mkdir -p ${BUILDDIR}/ptx
	@echo "...calling xsltproc with parameter version=${*} to create PreTeXt document"
	@xsltproc \
	  --xinclude \
	  --output ${BUILDDIR}/ptx/${ROOTDOCNAME}-${*}.ptx \
	  --stringparam version ${*} \
	  ./preprocess.xsl src/${ROOTDOCNAME}.xml
	@echo "...DONE"

${BUILDDIR}/html/.sentinal.%: ${BUILDDIR}/ptx/${ROOTDOCNAME}-%.ptx
	@echo "Converting PTX to HTML for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/.sentinal.*
	@mkdir -p ${BUILDDIR}/html/knowl
	@echo "...calling pretext to compile PreTeXt document"
	@$(PRETEXT) \
	  --verbose \
	  --component all \
	  --format html \
	  --publisher html-out.xml \
	  --parameters \
		html.css.extra dla.css \
	  --directory ${BUILDDIR}/html \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}-${*}.ptx
	@echo "...copying css style customizations"
	@cp css/dla.css ${BUILDDIR}/html/
	@sed -i -e 's/scale: [0-9]*,/scale: 100,/' ${BUILDDIR}/html/*.html
	@touch ${BUILDDIR}/html/.sentinal.${*}
	@echo "...DONE"
	@echo "Now call:"
	@echo "   make ${*}-html-images  (to build SVG images)"
	@echo "   make html-serve               (to serve the output locally for previewing)"

${BUILDDIR}/html/images/.sentinal.%: ${BUILDDIR}/ptx/${ROOTDOCNAME}-%.ptx
	@echo "Generating SVG files for HTML output for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/images/.sentinal.*
	@mkdir -p ${BUILDDIR}/html/images
	@echo "...calling pretext to generate images"
	@$(PRETEXT) \
	  --verbose \
	  --component latex-image \
	  --format svg \
	  --directory ${BUILDDIR}/html/images \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}-${*}.ptx
	@echo "...copying institution logo"
	@-cp images/${BRANDLOGO} ${BUILDDIR}/html/images
	@touch ${BUILDDIR}/html/images/.sentinal.${*}
	@echo "...DONE"

html-fonts: \
  ${BUILDDIR}/html/STIX2Text-Regular.woff \
  ${BUILDDIR}/html/STIX2Text-Bold.woff \
  ${BUILDDIR}/html/STIX2Text-Italic.woff \
  ${BUILDDIR}/html/STIX2Text-BoldItalic.woff \
  ${BUILDDIR}/html/STIX2Math.woff \
  ${BUILDDIR}/html/STIX2Text-Regular.woff2 \
  ${BUILDDIR}/html/STIX2Text-Bold.woff2 \
  ${BUILDDIR}/html/STIX2Text-Italic.woff2 \
  ${BUILDDIR}/html/STIX2Text-BoldItalic.woff2 \
  ${BUILDDIR}/html/STIX2Math.woff2

${BUILDDIR}/html/%.woff: stixfonts/WOFF/%.woff
	@mkdir -p ${BUILDDIR}/html
	-cp $< ${BUILDDIR}/html/
${BUILDDIR}/html/%.woff2: stixfonts/WOFF2/%.woff2
	@mkdir -p ${BUILDDIR}/html
	-cp $< ${BUILDDIR}/html/

${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex: ${BUILDDIR}/ptx/${ROOTDOCNAME}-%.ptx
	@echo "Converting PTX to LATEX for version: ${*}..."
	@mkdir -p ${BUILDDIR}/latex
	@echo "...calling pretext to compile PreTeXt document"
	@${PRETEXT} \
	  --component all \
	  --format latex \
	  --parameters \
	    numbering.projects.level 2 \
	  --directory ${BUILDDIR}/latex \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...DONE"

html-serve:
	@./scripts/serve.py ${BUILDDIR}/html $(SERVEPORT) 2>/dev/null

validate-xml: $(SOURCES)
	@echo "Validating xml..."
	@xmllint --xinclude src/${ROOTDOCNAME}.xml | xmllint --noout -
	@mkdir -p ${BUILDDIR}
	@echo "...DONE"
