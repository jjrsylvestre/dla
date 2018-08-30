#!/bin/sh

mkdir -p /run/user/${UID}/pretext/DLA/latex
mkdir -p build
if ! test -L build/latex
then
	ln -s /run/user/${UID}/pretext/DLA/latex build/latex
fi

if ! test -f mathbook-xsl.d/mathbook-latex.xsl
then
	echo "First do"
	echo "ln -s /path/to/your/mathbook/xsl mathbook-xsl.d"
	echo "before compiling."
	exit 1
fi

# Even though a directory is allowed as argument for --output option,
# xsltproc gives a "I/O error : Is a directory" error.
# But using a throw-away main output file avoids the error
# (and DELETEME.tex is just blank after processing anyway).

xsltproc \
  --xinclude \
	--output build/latex/DELETEME.tex \
	--stringparam numbering.projects.level 2 \
	style-latex.xsl src/book.xml
rm -f build/latex/DELETEME.tex
