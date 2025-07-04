#
# $FreeBSD: src/share/skel/dot.profile,v 1.21 2002/07/07 00:00:54 mp Exp $
#
# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

test -n "${O1VM_SUPRESS_SHRC_LOGGING}" || echo '.profile' >&2

# file permissions: rwxr-xr-x
umask 22

# make ${HOME}/bin first only
test "${PATH%:${HOME}/bin*}" = "${PATH}" || PATH="${PATH%:${HOME}/bin*}${PATH##*:${HOME}/bin}"
test "${PATH#${HOME}/bin:*}" = "${PATH}" && PATH="${HOME}/bin:${PATH}"

GOPATH="${HOME}/src/go"
if [ -d "${GOPATH}" ]; then
	IFS=':'
	set -- ${GOPATH}
	unset IFS GOPATH
	for i in ${*}; do
		test -d "${i}" && GOPATH="${GOPATH:+${GOPATH}:}${i}"
		test -d "${i}/bin" && PATH="${PATH:+${PATH}:}${i}/bin"
	done
	test -n "${GOPATH}" && export GOPATH GO111MODULE=auto #on
fi

test -d "${HOME}/.local/bin" && PATH="${PATH}:${HOME}/.local/bin"
export PATH

export BLOCKSIZE='K'
export PAGER='/usr/bin/less'
export LESS='--no-init --chop-long-lines'
export LESSHISTFILE='/dev/null'

export MANWIDTH='78'
export MANPAGER='/usr/bin/less --no-init --chop-long-lines --RAW-CONTROL-CHARS'
export GIT_PAGER="${MANPAGER}"

#export PS1="\[\033[0;32m\]\n\w\n\[\033[0m\]$(kubectl config view -o json | jq --join-output '."current-context" as $ctx | .contexts[] | select(.name == $ctx) | [.name, .context.namespace] | join("/")')\[\033[1;33m\]>\[\033[0m\] "
PS1="${USER}@\\h:\\w \\$ "

case "${OSTYPE}" in
	freebsd*)
		test -x "${EDITOR:=/usr/local/bin/mcedit}" || EDITOR='/usr/bin/ee'
		export EDITOR

		test -S "/var/run/${USER}/agent.sock" && export SSH_AUTH_SOCK="/var/run/${USER}/agent.sock"
		test -s "${HOME}/.pythonstartup" && export PYTHONSTARTUP="${HOME}/.pythonstartup"
		test -z "${TMUX}" || export COLORTERM='rxvt'
		export DOCKER_HOST='tcp://198.19.255.9:2375'
		;;
esac

if [ -n "${BASH}" ]; then
	test -s "${BASH_ENV:=${HOME}/.bashrc}" && export BASH_ENV && . "${BASH_ENV}"
else
	export ENV="${HOME}/.shrc"
fi
