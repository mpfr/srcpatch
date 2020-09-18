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
srcdirs='/usr/{src,xenocara}'

usage()
{
	echo "usage: ${0##*/} [-c | -l | -R | -r]" >&2
	exit 1
}

patches()
{
	local _patch _name _filter=$1
	for _patch in ${patchdir}/${osver}-+([[:digit:]])_+([[:alnum:]_]); do
		_name=${_patch##*/${osver}-}
		${_filter} ${_patch} ${_name}
	done | sort -V
}

installed()
{
	[[ -f $1/$2.patch.sig.log ]] && echo $2
}

available()
{
	local _sigfile=$1/$2.patch.sig
	[[ -f ${_sigfile} && ! -f ${_sigfile}.log ]] && echo $2
}

path_diff()
{
	echo "${patchdir}/${osver}-$1/$1.patch.sig"
}

path_src()
{
	echo $(sed -n 's/^.*cd \(.*\) && patch .*$/\1/p' $1)
}

revert_recent()
{
	local _patch=$(patches installed | tail -1)
	[[ -n ${_patch} ]] || return 0

	local _filelist _file _orig
	local _diff=$(path_diff ${_patch})
	local _src=$(path_src ${_diff} | sed 's/\//\\\//g')
	echo -n "Reverting ${_patch} ... "
	_filelist=$(sed -n "s/^Index\: \(.*\)$/${_src}\/\1/p" ${_diff})
	for _file in ${_filelist}; do
		_orig=${_file}.orig~${_patch}
		[[ -f ${_orig} ]] && mv ${_orig} ${_file} || rm -f ${_file}
	done
	rm -f ${_diff}.log
	echo 'Done.'
}

revert_all()
{
	while [[ -n $(patches installed) ]]; do
		revert_recent
	done
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
	c)	patches available;;
	l)	patches installed;;
	R)	revert_all;;
	r)	revert_recent;;
	*)	usage;;
	esac
done

(($# > 0)) && exit 0

for patch in $(patches available); do
	diff=$(path_diff ${patch})
	src=$(path_src ${diff})
	echo -n "Applying ${patch} ... "
	signify -Vep /etc/signify/openbsd-${osver}-base.pub -x ${diff} -m - \
		| patch -d ${src} -f -p0 -z .orig~${patch} > ${diff}.log
	if [[ $? -ne 0 ]]; then
		echo 'Failed.'
		mv ${diff}.log ${diff}.log.err
		exit 1
	fi
	echo 'Done.'
done
