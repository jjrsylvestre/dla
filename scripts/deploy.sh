#!/bin/sh

ask_continue()
{
	local ans
	echo -n "Continue [Y/n] ? "
	read ans
	if [ "${ans}" != "Y" ]
	then
		echo "Aborting ..."
		exit 1
	fi
}

local_dir=$1
excludes=$2
remote_loc=$3
runs=('--dry-run' '')
options=('--delete' '--verbose' '--recursive' '--itemize-changes' '--checksum')

echo

echo "All files for html deployment will be placed *under* the directory at remote location:"
echo
echo "  ${remote_loc}"
echo
echo "This directory should already exist and either be empty or contain the contents of your last deployment."
echo
ask_continue

if [ -f ${excludes} ]
then
	echo "Found exclude file ${excludes} containing:"
	echo
	cat ${excludes}
	echo
	ask_continue
	options+=("--exclude-from=${excludes}")
else
	echo ">>>> WARNING   Did not find exclude file ${excludes}"
	echo
	ask_continue
fi

for run in "${runs[@]}"
do
	echo
	echo "***"
	if [ -n ${run} ]
	then
			echo "*** DRY RUN ***"
	fi
	echo "*** Command:"
	echo "***"
	echo "***   rsync ${run} ${options[@]} \\"
	echo "***     ${local_dir}/ \\"
	echo "***     ${remote_loc}/"
	echo "***"
	echo $run ${options[@]} "${local_dir}/" "${remote_loc}/" | xargs rsync
	if [ -n "${run}" ]
	then
			echo
			ask_continue
	else
			echo
			echo "COMPLETE"
			echo
	fi
done
