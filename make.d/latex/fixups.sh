#!/bin/sh

builddir=${1}
docname=${2}
version=${3}

echo
echo "LaTeX fixups.sh"
echo "builddir: ${builddir}"
echo "docname: ${docname}"
echo "version: ${version}"

echo
echo "common scripts:"
for script in ./make.d/latex/common.d/*.sh
do
	if [ ! -x ${script} ]
	then
		continue
	fi
	echo "    `basename ${script}`"
	$script ${builddir}/latex/${docname}-${version}.tex
done

echo
if [ -d  ./make.d/latex/${version}.d ]
then
	echo "scripts for version ${version}:"
	for script in ./make.d/latex/${version}.d/*.sh
	do
		if [ ! -x ${script} ]
		then
			continue
		fi
		echo "    `basename ${script}`"
		$script ${builddir}/latex/${docname}-${version}.tex
	done
else
	echo "... no scripts for version ${version}"
fi

echo
