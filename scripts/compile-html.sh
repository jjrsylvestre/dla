#!/bin/sh

mkdir -p /run/user/${UID}/pretext/DLA/html/knowl
mkdir -p build
if ! test -L build/html
then
	ln -s /run/user/${UID}/pretext/DLA/html build/html
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
	style-html.xsl src/book.xml
rm -f build/html/DELETEME.html

# local style overrides
cp css/dla.css build/html/
sed -i \
  -e 's/scale: [0-9]*,/scale: 100,/' \
  -e '/<\/head>/ {
r css/dla.css.loadstring
N
}' build/html/*.html
