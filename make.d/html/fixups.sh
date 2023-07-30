#!/bin/sh

sed \
  -e '/<!--html-fixup / {s|<!--html-fixup ||; s|-->||}' \
  ${1} \
  > ${1}.html-fixup
