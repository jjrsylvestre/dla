#!/bin/sh

xmllint \
  --noout \
  --xinclude \
  --postvalid \
  --relaxng /opt/mathbook/schema/pretext.rng \
  src/book.xml
