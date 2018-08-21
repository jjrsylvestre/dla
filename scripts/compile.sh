#!/bin/sh

mkdir -p /run/user/${UID}/pretext/DLA/knowl
mkdir -p build
if ! test -L build/html
then
	ln -s /run/user/${UID}/pretext/DLA build/html
fi

if ! test -f mathbook-xsl.d/mathbook-html.xsl
then
	echo "First do"
	echo "ln -s /path/to/your/mathbook/xsl mathbook-xsl.d"
	echo "before compiling."
	exit 1
fi

# Even though a directory is allowed as argument for --output option,
# xsltproc gives a "I/O error : Is a directory" error.
# But using a throw-away main output file avoids the error
# (and DELETEME.html is just blank after processing anyway).

xsltproc \
  --xinclude \
	--output build/html/DELETEME.html \
	--stringparam numbering.projects.level 2 \
	--stringparam html.knowl.example no \
	style.xsl src/book.xml
rm -f build/html/DELETEME.html

# UNUSED STRINGPARAMS

#	--stringparam numbering.theorems.level 2
# ^^^^ Don't like this: theorems share numbering with remarks, etc., so theorem numbering won't start at 1 in each Theory section.

# --stringparam toc.level 2 \
# ^^^^ In principle I like this, but in current incarnation it makes it difficult to navigate. Wish there was a toc.level=2.5.
