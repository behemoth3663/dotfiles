#!/bin/sh

PKG_DIR="$(make -C /usr/ports/ports-mgmt/pkg -V PACKAGES)"    #/usr/ports/packages
PKG_SUFFIX="$(make -C /usr/ports/ports-mgmt/pkg -V PKG_SUFX)" #.txz -> .pkg
readonly PKG_DIR PKG_SUFFIX

readonly VERSION_REGEXP='-[0-9._,a-z+]+[^+]' #firefox-71.0_6,1.txz

find -L "${PKG_DIR}/Latest" -type l

find "${PKG_DIR}/All" -type f -name "*${PKG_SUFFIX}" |
	sed -r \
		-e "s,^${PKG_DIR}/All/,," \
		-e "s/${VERSION_REGEXP}\\${PKG_SUFFIX}\$//" |
	sort |
	uniq --repeated |
	while read -r s; do
		s=$(echo "${s}" | sed -r -e 's/(\+|\*|\?|\.)/\\\1/') #'
		find -E "${PKG_DIR}/All" -type f -iregex ".*/${s}${VERSION_REGEXP}\\${PKG_SUFFIX}\$" |
			sort --reverse --version-sort |
			tail -n +2 |
			sed -r -e '/terraform-0\.11\./d'
	done
