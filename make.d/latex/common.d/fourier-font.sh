#!/bin/sh

# 1. unfortunately the fouriernc package already defines \warning
#    which then interferes with ptx's warning environment
# 2. fontspec package shouldn't(?) be needed with fouriernc

sed -i \
	-e 's|usepackage{lmodern|usepackage{fouriernc|' \
	-e 's|newtcolorbox\[use counter from=block\]{warning|newtcolorbox[use counter from=block]{ptxwarning|' \
	-e 's|begin{warning|begin{ptxwarning|g' \
	-e 's|end{warning|end{ptxwarning|g' \
	-e 's|\\usepackage{fontspec}|%\\usepackage{fontspec}|' \
	${1}

