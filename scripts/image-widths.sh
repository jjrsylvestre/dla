#!/bin/sh

for F in ${1}/*.pdf
do
	width=`pdfinfo ${F} | tr -s ' ' | grep "Page size" | cut -f3 -d' '`
	width_pct=`echo "scale=1; 100*${width}/340" | bc`
	echo "`basename ${F}`: ${width_pct}%"
done
