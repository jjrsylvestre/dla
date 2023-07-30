#!/bin/sh

sed -i \
	-e 's|newtcolorbox\[use counter from=block\]{warning|newtcolorbox[use counter from=block]{warningenv|' \
	-e 's|begin{warning|begin{warningenv|g' \
	-e 's|end{warning|end{warningenv|g' \
	-e 's|\\usepackage{fontspec}|%\\usepackage{fontspec}|' \
	-e 's|usepackage{lmodern|usepackage{fouriernc|' \
	${1}
