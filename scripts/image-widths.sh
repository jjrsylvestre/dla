#!/bin/sh

for F in ${*}
do
	width=`pdfinfo ${F} | tr -s ' ' | grep "Page size" | cut -f3 -d' '`
	width_pct=`echo "scale=1; 100*${width}/340" | bc`
	echo "${width_pct}%  `basename ${F} .pdf`"
done
