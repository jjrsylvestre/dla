# recursive wildcard, from answers to
# https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
#
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SOURCES = $(call rwildcard,src,*.ptx *.tex)

BRANDLOGO=UA_Logo_Stk_Green_RGB.png
ROOTDOCNAME=book
SERVEPORT=8080
BUILDDIR=${XDG_RUNTIME_DIR}/pretext/DLA
#PRETEXT=/opt/pretext/pretext/pretext
#PRETEXT=./pretext/pretext/pretext
PRETEXTDIR=./pretext
ROOT_XMLID=book-discover-linear-algebra
REMOTE_LOCATION=
STIXFONTS_VERSION := $(shell cat stixfonts_version.txt)

HTML_TARGETS = two-semester-html one-semester-html
HTML_CLEAN_TARGETS = two-semester-html-clean one-semester-html-clean
IMAGE_TARGETS = two-semester-html-images one-semester-html-images
IMAGE_PDF_TARGETS = two-semester-html-image-pdfs one-semester-html-image-pdfs
IMAGE_CLEAN_TARGETS = two-semester-html-images-clean one-semester-html-images-clean
LATEX_TARGETS = two-semester-latex one-semester-latex two-semester-print-latex one-semester-print-latex
DEPLOY_TARGETS = two-semester-html-deploy one-semester-html-deploy
.PHONY: ptx two-semester-html-all one-semester-html-all \
  $(HTML_TARGETS) $(HTML_CLEAN_TARGETS) \
  $(IMAGE_TARGETS) $(IMAGE_CLEAN_TARGETS) \
  $(LATEX_TARGETS) \
  $(DEPLOY_TARGETS) \
  clean ptx-clean html-images-clean \
  html-serve validate-xml validate-ptx \
  help list

log_error = (>&2 echo ">>>> $1" && exit 1)

list: help
help:
	@echo "= TARGETS =========================================================================================="
	@echo "> validate-xml                  : Check for XML syntax/format errors."
	@echo "                                  (Does not validate against PTX schema.)"
	@echo "> validate-ptx                  : Check for PTX schema errors."
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
	@echo "> two-semester-html-image-pdfs  : Create PDF image files to accompany the html output for all"
	@echo "                                  chapters."
	@echo "> one-semester-html-image-pdfs  : Create PDF image files to accompany the html output for chapters"
	@echo "                                  for a one-semester course."
	@echo "> html-fonts                    : Copy STIX2Text fonts into the HTML build directory."
	@echo "> html-serve                    : Fire up a simple Python web server to locally host the HTML"
	@echo "                                  output."
	@echo "> two-semester-html-deploy      : rsync HTML files for the two-semester version to a remote server."
	@echo "                                  Requires that the REMOTE_LOCATION parameter be set on the command"
	@echo "                                  line."
	@echo "> one-semester-html-deploy      : rsync HTML files for the one-semester version to a remote server."
	@echo "                                  Requires that the REMOTE_LOCATION parameter be set on the command"
	@echo "                                  line."
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
	@echo "> BUILDDIR       : Root directory for all output files."
	@echo "                   [Default: $(BUILDDIR)]"
	@echo "> BRANDLOGO      : Filename of institutional logo. Needs to exist in images/."
	@echo "                   [Default: $(BRANDLOGO)]"
	@echo "> PRETEXTDIR     : Path to PreTeXt installation."
	@echo "                   [Default: $(PRETEXTDIR)]"
	@echo "> SERVEPORT      : Local port on which to serve HTML output when using the html-serve target."
	@echo "                   [Default: $(SERVEPORT)]"
	@echo "> REMOTE_LOCATION: Remote path to use as rsync target for HTML output."
	@echo "                   [Default: unset]"

two-semester-html-all: two-semester-html two-semester-html-images
one-semester-html-all: one-semester-html one-semester-html-images

$(DEPLOY_TARGETS): %-html-deploy: | %-html
	@[ "$(REMOTE_LOCATION)" ] || $(call log_error, "REMOTE_LOCATION not set!")
	@echo "Transferring ${BUILDDIR}/html/${*} to ${REMOTE_LOCATION} ..."
	@./scripts/deploy.sh ${BUILDDIR}/html/${*} ${*}-html-deploy.exclude ${REMOTE_LOCATION}

clean: ptx-clean html-clean html-images-clean

ptx-clean:
	@-rm -f ${BUILDDIR}/ptx/*.ptx

ptx: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
$(HTML_TARGETS): %-html: ${BUILDDIR}/ptx/publication-%-html.xml ${BUILDDIR}/html/%/.sentinel html-fonts
$(IMAGE_TARGETS): %-html-images: ${BUILDDIR}/ptx/publication-%-html.xml ${BUILDDIR}/html/%/images/.sentinel
$(IMAGE_PDF_TARGETS): %-html-image-pdfs: ${BUILDDIR}/ptx/publication-%-html.xml ${BUILDDIR}/html-image-pdfs/%/.sentinel
$(LATEX_TARGETS): %-latex: ${BUILDDIR}/ptx/publication-%-latex.xml ${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex

$(HTML_CLEAN_TARGETS): %-html-clean:
	@-rm -f ${BUILDDIR}/html/${*}/.sentinel*
	@-rm -f ${BUILDDIR}/html/${*}/*.html
	@-rm -f ${BUILDDIR}/html/${*}/knowl/*.html
	@-rm -f ${BUILDDIR}/html/${*}/knowl/index/*.html
	@-rm -f ${BUILDDIR}/html/${*}/knowl/xref/*.html
	@-rm -f ${BUILDDIR}/html/${*}/lunr-pretext-search-index.js
	@-rm -f ${BUILDDIR}/html/${*}/dla.css
$(IMAGE_CLEAN_TARGETS): %-html-images-clean:
	@-rm -f ${BUILDDIR}/html/${*}/images/.sentinel*
	@-rm -f ${BUILDDIR}/html/${*}/images/*.svg
	@-rm -f ${BUILDDIR}/html-image-pdfs/${*}/*.pdf

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

${BUILDDIR}/html/%/.sentinel: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Converting PTX to HTML for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/${*}/.sentinel
	@mkdir -p ${BUILDDIR}/html/${*}/knowl
#	@echo "...html fixups"
#	@./make.d/html/fixups.sh ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
#	@mv ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx.html-fixup ${BUILDDIR}/ptx/${ROOTDOCNAME}-html.ptx
	@echo "...calling pretext to compile PreTeXt document"
	@${PRETEXTDIR}/pretext/pretext \
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
	@sed -i -e 's/scale: [0-9]*,/scale: 100,/' ${BUILDDIR}/html/${*}/*.html
	@touch ${BUILDDIR}/html/${*}/.sentinel
	@echo "...DONE"
	@echo "Now call:"
	@echo "   make ${*}-html-images  (to build SVG images)"
	@echo "   make html-serve               (to serve the output locally for previewing)"

${BUILDDIR}/html/%/images/.sentinel: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Generating SVG files for HTML output for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/${*}/images/.sentinel
	@mkdir -p ${BUILDDIR}/html/${*}/images
	@echo "...calling pretext to generate images"
	@echo "...(restricted to ${ROOT_XMLID})"
	@${PRETEXTDIR}/pretext/pretext \
	  --verbose \
	  --component latex-image \
	  --format svg \
	  --restrict ${ROOT_XMLID} \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-html.xml \
	  --directory ${BUILDDIR}/html/${*}/images \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...copying institution logo"
	@mkdir -p ${BUILDDIR}/html/${*}/external
	@-cp images/${BRANDLOGO} ${BUILDDIR}/html/${*}/external/
	@touch ${BUILDDIR}/html/${*}/images/.sentinel
	@echo "...DONE"

${BUILDDIR}/html-image-pdfs/%/.sentinel: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Generating PDF files for HTML output for version: ${*}..."
	@-rm -f ${BUILDDIR}/html-image-pdfs/${*}/.sentinel
	@mkdir -p ${BUILDDIR}/html-image-pdfs/${*}
	@echo "...calling pretext to generate images"
	@echo "...(restricted to ${ROOT_XMLID})"
	@${PRETEXTDIR}/pretext/pretext \
	  --verbose \
	  --component latex-image \
	  --format pdf \
	  --restrict ${ROOT_XMLID} \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-html.xml \
	  --directory ${BUILDDIR}/html-image-pdfs/${*} \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@touch ${BUILDDIR}/html-image-pdfs/${*}/.sentinel
	@echo "...DONE"

${BUILDDIR}/latex/${ROOTDOCNAME}-%.tex: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Converting PTX to LATEX for version: ${*}..."
	@mkdir -p ${BUILDDIR}/latex
	@echo "...calling pretext to compile PreTeXt document"
	@${PRETEXTDIR}/pretext/pretext \
	  --XSL style-latex.xsl \
	  --component all \
	  --format latex \
	  --publisher ${BUILDDIR}/ptx/publication-${*}-latex.xml \
	  --output ${BUILDDIR}/latex/${ROOTDOCNAME}-${*}.tex \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...applying adjustments from ./make.d/latex/"
	@./make.d/latex/fixups.sh ${BUILDDIR} ${ROOTDOCNAME} ${*}
	@echo "...DONE"

html-fonts: ${BUILDDIR}/html/fonts/.sentinel

${BUILDDIR}/html/fonts/.sentinel:
	@echo "Copying STIX2 fonts..."
	@mkdir -p ${BUILDDIR}/html/fonts
	@./scripts/unpack-fonts.sh ${BUILDDIR}/html/fonts ${STIXFONTS_VERSION}
	@mkdir -p ${BUILDDIR}/html/one-semester
	@ln -sf ${BUILDDIR}/html/fonts ${BUILDDIR}/html/one-semester/fonts
	@mkdir -p ${BUILDDIR}/html/two-semester
	@ln -sf ${BUILDDIR}/html/fonts ${BUILDDIR}/html/two-semester/fonts
	@touch ${BUILDDIR}/html/fonts/.sentinel

html-serve:
	@./scripts/serve.py ${BUILDDIR}/html $(SERVEPORT) 2>/dev/null

validate-xml: $(SOURCES)
	@echo "Validating xml..."
	@xmllint --xinclude src/${ROOTDOCNAME}.ptx | xmllint --noout -
	@mkdir -p ${BUILDDIR}
	@echo "...DONE"

validate-ptx: ptx
	@echo "Validating ptx..."
	@jing ${PRETEXTDIR}/schema/pretext.rng ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx |\
	  grep -v \
	    -e "element \"worksheet\" not allowed anywhere"
	@mkdir -p ${BUILDDIR}
	@echo "...DONE"
