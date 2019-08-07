#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ls aliases
alias la="ls -A"
alias ll="ls -l"
alias l='ls'

## Jupyter Notebook
alias jn="cd && jupyter notebook &> /dev/null &"
alias jnk='ps -W | grep "jupyter-notebook" | awk "{print \$1}" | xargs kill -f'

## Git
# Add, commit, and push to master.
function gitp () { git add --all && git commit -m "$@" && git push origin master ; }
# git recursively pull all subdirectories
alias gitr="find . -name ".git" -type d | sed 's/\/.git//' |  xargs -P10 -I{} git -C {} pull"

## Pandoc
function panstrap () {
	DIR="$HOME/Templates"
	if [ "$#" -ne 2 ]; then
	    echo "Illegal number of parameters"
	fi
	pandoc "$1" -o "$2" --template $DIR/template.html --css $DIR/template.css --self-contained --toc --toc-depth 2 ; }

## Dotfiles
# Update dotfiles
dfpush() {
    (
        cd ~/dotfiles
	git add .
	git commit -m 'autoupdate'
	git push origin master
    )
}
dfpull() {
    (
        cd ~/dotfiles
	git pull --ff-only
	./install  2>&1 >/dev/null
    )
}

## Etc
alias shrug="echo '¯\\_(ツ)_/¯' > /dev/clipboard"
alias az="az.cmd"

## Anaconda
export PATH="$HOME/anaconda3/bin:$PATH"

