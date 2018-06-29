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

# even though a directory is allowed as argument for --output option,
# xsltproc gives a "I/O error : Is a directory" error
# but using a throw-away main output file avoids the error
# (and DELETEME.html is just blank after processing anyway)

xsltproc --xinclude --output build/html/DELETEME.html style.xsl src/book.xml
rm html/DELETEME.html
