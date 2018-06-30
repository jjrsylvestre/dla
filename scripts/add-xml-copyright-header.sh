#!/bin/sh

for I in $*
do
  cp src/templates.d/copyright-header.xml /tmp/dla-tmp.xml
  sed -e 's/^<?xml version="1.0" encoding="UTF-8" ?>//' ${I} >> /tmp/dla-tmp.xml
  mv /tmp/dla-tmp.xml ${I}
done
