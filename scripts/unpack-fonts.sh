#!/bin/sh

unpack_to=${1}
stixfonts_version=${2}
stixfonts_file=v${stixfonts_version}.tar.gz
cache_dir=${XDG_CACHE_HOME}/pretext/stixfonts
cached_file=${cache_dir}/${stixfonts_file}

echo

echo -n "Refreshing STIXFONTS cached download..."

if [ -f ${cached_file} ]
then
	echo "up to date"
else
	mkdir -p ${cache_dir}
	if wget -q -P ${cache_dir} https://github.com/stipub/stixfonts/archive/refs/tags/${stixfonts_file}
	then
		echo "done"
	else
		echo "error"
		echo
		exit 1
	fi
fi

echo -n "Copying FONTS into build directory..."

if tar -xzf ${cached_file} --directory="${unpack_to}" --strip-components=3 --wildcards stixfonts-${stixfonts_version}/fonts/static_otf_woff2/STIXTwoText-*.woff2
then
	echo "done"
	echo
else
	echo "error"
	echo
	exit 1
fi
