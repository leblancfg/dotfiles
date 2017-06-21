#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

function gitp () { git add . && git commit -m "$@" && git push origin master ; }
alias nb="cd /c/Users/FLeblanc/notebooks"
alias jn="cd /c/Users/FLeblanc && jupyter notebook &> /dev/null &"
alias jnk='ps -W | grep "jupyter-notebook" | awk "{print \$1}" | xargs kill -f'
alias an='$"`where python | grep conda`"'
