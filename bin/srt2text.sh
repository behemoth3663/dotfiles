#!/bin/sh

#https://github.com/oshenc/srttotext

test "${#}" -ne 1 && echo "Usage $(basename ""${0}"") SRTFILE" && exit 1
test ! -f "${1}" && echo "File ${1} doesn't exists." && exit 2

sed -r \
	-e 's/^\xef\xbb\xbf//' \
	-e 's/\r//' \
	-e 's/^[0-9]*$//' \
	-e '/^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}$/d' \
	-e 's/^[[:space:]]+$//' \
	-e '/^$/d' \
	-e 's/<[^>]*>//g' \
	-e 's/[.,!?"]//g' \
	-e 's/\{\\[[:alnum:]]+\}//' \
	-e 's/^-+//' \
	-e 's/…//g' \
	-e 's/[[:space:]]/\n/g' \
	"${1}" |
	sed -r \
		-e 's/[-]+$//' \
		-e '/^.$/d' \
		-e '/^[0-9%]+$/d' \
		-e "s/'(d|s|ll|re|ve|em)$//" \
		-e "s/n't$//" \
		-e '/^$/d' |
	tr '[:upper:]' '[:lower:]' | sort -u
