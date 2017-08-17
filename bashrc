#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Common actions
alias jn="cd /c/Users/FLeblanc && jupyter notebook &> /dev/null &"
alias jnk='ps -W | grep "jupyter-notebook" | awk "{print \$1}" | xargs kill -f'
alias py='$"`where python | grep conda`"'
alias rgrep='grep -rF'

## Git
# Add, commit, and push to master.
# git recursively pull all subdirectories
function gitp () { git add --all && git commit -m "$@" && git push origin master ; }
alias gitr="find . -name ".git" -type d | sed 's/\/.git//' |  xargs -P10 -I{} git -C {} pull"

# ls aliases
alias la="ls -A"
alias l='ls'

# Update dotfiles
dfu() {
    (
        cd ~/.dotfiles && git pull --ff-only && ./install -q
    )
}

# Go up [n] directories
up()
{
    local cdir="$(pwd)"
    if [[ "${1}" == "" ]]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [[ "${1}" -gt "0" ]]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            local ncdir="$(dirname "${cdir}")"
            if [[ "${cdir}" == "${ncdir}" ]]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}"
}
