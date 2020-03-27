SOURCES = $(wildcard *.xsl) \
  $(wildcard src/*.xml) $(wildcard src/*.tex) \
  $(wildcard src/*/*.xml) $(wildcard src/*/*.tex) \
  $(wildcard src/*/*/*.xml) $(wildcard src/*/*/*.tex) \
  $(wildcard src/*/*/*/*.xml) $(wildcard src/*/*/*/*.tex)
# I think that's as deep as things go...

BRANDLOGO=AUG-Colour.png
SERVEPORT=8080
BUILDDIR=${XDG_RUNTIME_DIR}/pretext/DLA
HTMLXSL=./mathbook/xsl/mathbook-html.xsl
LATEXXSL=./mathbook/xsl/mathbook-latex.xsl
MBX=./mathbook/script/mbx

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
	@echo "> BRANDLOGO: Filename of institutional logo. Needs to exist in src/images/. [Default: $(BRANDLOGO)]"
	@echo "> HTMLXSL  : Path to XSL file to use to process into HTML format. [Default: $(HTMLXSL)]"
	@echo "> LATEXXSL : Path to XSL file to use to process into LaTeX format. (Note: LaTeX output not yet supported.) [Default: $(LATEXXSL)]"
	@echo "> MBX      : Path to script to extract and convert TEX images to SVG. [Default: $(MBX)]"
	@echo "> SERVEPORT: Local port on which to serve HTML output when using the html-serve target. [Default: $(SERVEPORT)]"

define mathbookerrmsg
ERROR
Cannot file appropriate XSL file for conversion.
If you are using the default HTMLXSL/LATEXXSL paths,
you should first do
ln -s /path/to/your/mathbook
before compiling.
(See "make help" for more info.)
endef

twosemester-html-all: twosemester-html twosemester-html-images html-fonts
onesemester-html-all: onesemester-html onesemester-html-images html-fonts

clean: ptx-clean html-clean html-images-clean

ptx-clean:
	@-rm -f ${BUILDDIR}/ptx/.sentinal.*
	@-rm -f ${BUILDDIR}/ptx/book.ptx
html-clean:
	@-rm -f ${BUILDDIR}/html/.sentinal.*
	@-rm -f ${BUILDDIR}/html/*.html
	@-rm -f ${BUILDDIR}/html/knowl/*.html
html-images-clean:
	@-rm -f ${BUILDDIR}/html/images/.sentinal.*
	@-rm -f ${BUILDDIR}/html/images/*.svg

$(PTX_TARGETS): %-ptx: ${BUILDDIR}/ptx/.sentinal.%
$(HTML_TARGETS): %-html: ${BUILDDIR}/html/.sentinal.%
$(IMAGE_TARGETS): %-html-images: ${BUILDDIR}/html/images/.sentinal.%
$(LATEX_TARGETS): %-latex: ${BUILDDIR}/latex/book-%.tex
${BUILDDIR}/ptx/.sentinal.twosemester: $(SOURCES) | validate-xml; $(call preprocess,twosemester)
${BUILDDIR}/ptx/.sentinal.onesemester: $(SOURCES) | validate-xml; $(call preprocess,onesemester)

define preprocess
@echo "Preprocessing PTX*-->PTX for selected version ${1}, output will be placed in ${BUILDDIR}/ptx..."
@mkdir -p ${BUILDDIR}/ptx
@-rm -f ${BUILDDIR}/ptx/.sentinal.*
@echo "...calling xsltproc with parameter version=${1} to create PreTeXt document"
@xsltproc \
  --xinclude \
  --output ${BUILDDIR}/ptx/book.ptx \
  --stringparam version $1 \
  ./preprocess.xsl src/book.xml
@echo "...copying publisher file(s)"
@cp src/html-out.xml ${BUILDDIR}/ptx
@touch ${BUILDDIR}/ptx/.sentinal.${1}
@echo "...DONE"
endef

# the extra touch on the sentinal file is just in case xsltproc decides not to create the output file....
${BUILDDIR}/html/.sentinal.%: ${BUILDDIR}/ptx/.sentinal.%
ifeq ($(wildcard $(HTMLXSL)),)
	$(error $(mathbookerrmsg))
endif
	@echo "Converting PTX to HTML for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/.sentinal.*
	@mkdir -p ${BUILDDIR}/html/knowl
	@echo "...calling xsltproc to compile PreTeXt document"
	@xsltproc \
	  --output ${BUILDDIR}/html/.sentinal.${*} \
	  style-html.xsl ${BUILDDIR}/ptx/book.ptx
	@echo "...copying css style customizations"
	@cp css/dla.css ${BUILDDIR}/html/
	@sed -i -e 's/scale: [0-9]*,/scale: 100,/' ${BUILDDIR}/html/*.html
	@touch ${BUILDDIR}/html/.sentinal.${*}
	@echo "...DONE"
	@echo "Now call:"
	@echo "   make ${*}-html-images  (to build SVG images)"
	@echo "   make html-serve               (to serve the output locally for previewing)"

${BUILDDIR}/html/images/.sentinal.%: ${BUILDDIR}/ptx/.sentinal.%
ifeq ($(wildcard $(MBX)),)
	$(error $(mathbookerrmsg))
endif
	@echo "Generating SVG files for HTML output for version: ${*}..."
	@-rm -f ${BUILDDIR}/html/images/.sentinal.*
	@mkdir -p ${BUILDDIR}/html/images
	@echo "...calling mbx script"
	@/opt/mathbook/script/mbx -v \
	  -c latex-image \
	  -f svg \
	  -d ${BUILDDIR}/html/images \
	${BUILDDIR}/ptx/book.ptx
	@echo "...copying institution logo"
	@-cp src/images/${BRANDLOGO} ${BUILDDIR}/html/images
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

# the extra touch on the sentinal file is just in case xsltproc decides not to create the output file....
${BUILDDIR}/latex/book-%.tex: ${BUILDDIR}/ptx/.sentinal.%
ifeq ($(wildcard $(LATEXXSL)),)
	$(error $(mathbookerrmsg))
endif
	@echo "Converting PTX to LATEX for version: ${*}..."
	@mkdir -p ${BUILDDIR}/latex
	@echo "...calling xsltproc to compile PreTeXt document"
	@xsltproc \
	  --output ${BUILDDIR}/latex/book-${*}.tex \
	  style-latex.xsl ${BUILDDIR}/ptx/book.ptx
	@echo "...DONE"

html-serve:
	@./scripts/serve.py ${BUILDDIR}/html $(SERVEPORT) 2>/dev/null

validate-xml: $(SOURCES)
	@echo "Validating xml..."
	@xmllint --xinclude src/book.xml | xmllint --noout -
	@mkdir -p ${BUILDDIR}
	@echo "...DONE"
