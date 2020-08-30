#!/bin/ksh
#
# Copyright (c) 2020 Matthias Pressfreund
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

patchdir='/var/syspatch'
osver=$(uname -r | tr -d .)
pubsig="/etc/signify/openbsd-${osver}-base.pub"
srcdirs='/usr/{src,xenocara}'

usage()
{
	echo "usage: ${0##*/} [-c | -l | -R | -r]" >&2
	exit 1
}

ls_installed()
{
	local patch name logfile
	for patch in ${patchdir}/${osver}-+([[:digit:]])_+([[:alnum:]_]); do
		name=${patch##*/${osver}-}
		logfile=${patch}/${name}.patch.sig.log
		[[ -f ${logfile} ]] && echo ${name}
	done | sort -V
}

ls_available()
{
	local patch name sigfile logfile
	for patch in ${patchdir}/${osver}-+([[:digit:]])_+([[:alnum:]_]); do
		name=${patch##*/${osver}-}
		sigfile=${patch}/${name}.patch.sig
		logfile=${sigfile}.log
		[[ -f ${sigfile} && ! -f ${logfile} ]] && echo ${name}
	done | sort -V
}

revert_recent()
{
	local filelist file orig
	local patch=$(ls_installed | tail -1)
	local diff=${patchdir}/${osver}-${patch}/*.patch.sig
	echo -n "Reverting ${patch} ... "
	filelist=$(sed -n 's/^RCS file\: \/cvs\(.*\)\,v$/\/usr\1/p' ${diff})
	for file in ${filelist}; do
		orig=${file}.orig~${patch}
		[[ -f ${orig} ]] && mv ${orig} ${file} || rm -f ${file}
	done
	rm -f ${diff}.log
	echo 'Done.'
}

if [[ $((id -u)) != 0 ]]; then
	echo "${0##*/}: need root privileges" >&2
	exit 1
fi

for d in ${srcdirs}; do
	if [[ ! -d ${d} ]]; then
		echo "${0##*/}: missing ${d}" >&2
		exit 1
	fi
done

arg=$@
((${#arg} > 2)) && usage
while getopts clRr arg; do
	case ${arg} in
	c)	ls_available;;
	l)	ls_installed;;
	R)	while [[ -n $(ls_installed) ]]; do revert_recent; done;;
	r)	revert_recent;;
	*)	usage;;
	esac
done

(($# > 0)) && exit 0

for patch in $(ls_available); do
	diff=${patchdir}/${osver}-${patch}/${patch}.patch.sig
	echo -n "Applying ${patch} ... "
	signify -Vep ${pubsig} -x ${diff} -m - | (cd $(sed -n \
		's/.*cd \(.*\) && patch -p0.*/\1/p' ${diff}) && \
		patch -p0 -z.orig~${patch}) > ${diff}.log
	if [[ $? -ne 0 ]]; then
		echo 'Failed.'
		mv ${diff}.log ${diff}.log.err
		exit 1
	fi
	echo 'Done.'
done
