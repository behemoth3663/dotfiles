test -n "${O1VM_SUPRESS_SHRC_LOGGING}" || echo '.bashrc' >&2

HISTSIZE='100000'
HISTFILESIZE='1000000'
HISTCONTROL='ignoreboth:erasedups'
HISTIGNORE='history:exit:logout:cd:pwd:man:l[ls]:l:doas shutdown*:sd:deco:mc:startx:kldstat:kldsize:portver:portupg -a:doas pkg check -d*'

# https://www.opennet.ru/base/sys/bash_tips.txt.html
shopt -s histappend
PROMPT_COMMAND='history -a'
shopt -s cdspell

RESET="\[\033[0m\]"
BOLD="\[\033[1m\]"
GRAY="\[\033[1;30m\]"
RED="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[1;33m\]"
BLUE="\[\033[1;34m\]"
CYAN="\[\033[1;36m\]"

_get_current_git_branch() {
	local s
	s=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	test "_${s}" = _HEAD && s=$(git rev-parse --short HEAD 2>/dev/null)
	test -z "${s}" || echo " ${s} "
}

#NO_COLOR_PS1=
PS1_TAIL_COLOR="${YELLOW}"
if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
	PS1_TAIL_COLOR="${RED}"
	PS1_HOST="${GRAY}@${RESET}\h"
	test -z "${NO_COLOR_PS1}" || PS1_HOST='@\h'
fi

#PS1="${RESET}\u${PS1_HOST}${CYAN}:${RESET}\w${PS1_TAIL_COLOR}>${RESET} "
PS1="${RESET}\u${PS1_HOST}${CYAN}:${RESET}${BOLD}\w${RESET}\$(${HOME}/bin/gitbrash)${PS1_TAIL_COLOR}>${RESET} "
test -x "${HOME}/bin/gitbrash" || PS1="${RESET}\u${PS1_HOST}${CYAN}:${RESET}${BOLD}\w${RESET}\$(_get_current_git_branch)${PS1_TAIL_COLOR}>${RESET} "
test -z "${NO_COLOR_PS1}" || PS1="\u${PS1_HOST}:\w> "

if [ "${UID}" -eq 0 ]; then
	#SSH_* variables are lost
	#PS1="${RESET}\h${RED}:${RESET}\w ${RED}\\\$${RESET} "
	PS1="\r${GREEN}\H ${RED}: ${BLUE}\w\n${RED}\\\$${RESET} "
	test -z "${NO_COLOR_PS1}" || PS1='\h:\w \$ '
fi

unset PS1_HOST PS1_TAIL_COLOR NO_COLOR_PS1 RESET BOLD GRAY RED GREEN YELLOW BLUE CYAN #MAGENTA WHITE

case "${OSTYPE}" in
	darwin*)
		export BASH_SILENCE_DEPRECATION_WARNING=1
		export HOMEBREW_AUTOREMOVE=1
		export HOMEBREW_BAT=1
		export HOMEBREW_NO_ANALYTICS=1
		export HOMEBREW_NO_EMOJI=1
		export HOMEBREW_NO_ENV_HINTS=1
		export INFOPATH="${INFOPATH:+${INFOPATH}:}/opt/homebrew/share/info"
		test -x '/opt/local/bin/mcedit' && export EDITOR='/opt/local/bin/mcedit'
		alias make='/opt/homebrew/bin/bmake'
		test -s "${ENV:=${HOME}/.shrc}" && export ENV
		;;
	*)
		test -s "${ENV:=${HOME}/.shrc}" && export ENV && . "${ENV}"
		;;
esac
