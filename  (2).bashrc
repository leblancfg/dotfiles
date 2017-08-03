export LC_ALL="C"
export LANG="C"


# Folder aliases
alias nb="cd /c/Users/FLeblanc/notebooks"

# Common actions
alias diary="cd ~/blog && vi ~/blog/CSA_diary.md"
alias jn="cd /c/Users/FLeblanc && jupyter notebook &> /dev/null &"
alias jnk='ps -W | grep "jupyter-notebook" | awk "{print \$1}" | xargs kill -f'
alias py='$"`where python | grep conda`"'
alias rgrep='grep -rF'

## Git
# Add, commit, and push to master.
# git recursively pull all subdirectories
function gitp () { git add --all && git commit -m "$@" && git push origin master ; }
alias gitr="find . -name ".git" -type d | sed 's/\/.git//' |  xargs -P10 -I{} git -C {} pull"
