#!/bin/sh

BRANDLOGO=AUG-Colour.png

mkdir -p /run/user/${UID}/pretext/DLA/images
mkdir -p build
if ! test -L build/html
then
	ln -s /run/user/${UID}/pretext/DLA build/html
fi

~/local/mathbook/script/mbx -v -c latex-image -f svg -d build/html/images src/book.xml
if ! test -f html/images/${BRANDLOGO}
then
	cp src/images/${BRANDLOGO} build/html/images/
fi