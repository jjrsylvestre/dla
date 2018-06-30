#!/bin/sh

for I in $*
do
  cat src/templates.d/copyright-header.tex ${I} > /tmp/dla-tmp.tex
  mv /tmp/dla-tmp.tex ${I}
done
