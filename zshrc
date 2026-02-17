## If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Terminal settings
stty -ixon -ixoff

# Path to your oh-my-zsh installation.
export LS_COLORS=''  # Prettier `fd`
export ZSH="$HOME/.oh-my-zsh"
export REPLACE_RC='no'  # Don't overwrite the zshrc if installing OMZ
export ZVM_CURSOR_STYLE_ENABLED=false  # Attempt at blinking cursor

# First, install oh-my-zsh if it's not present
if [ ! -d ~/.oh-my-zsh ];then
  echo 'oh-my-zsh not installed, installing...'
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ; 
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
HYPHEN_INSENSITIVE="true"
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

### Helpers
source_if_exists() { [[ -f "$1" ]] && source "$1" }
eval_if_exists() { [[ -x "$1" ]] && eval "$("$@")" }

### User configuration

## History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY       # Write timestamp to history
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file
setopt SHARE_HISTORY          # Share history between all sessions

# Userland niceities
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"

## Installs
source_if_exists /opt/dev/dev.sh
eval_if_exists ~/.local/state/tec/profiles/base/current/global/init zsh

source_if_exists "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
eval_if_exists /usr/local/bin/brew shellenv
eval_if_exists /opt/homebrew/bin/brew shellenv
source_if_exists $HOME/leblancfg/.config/op/plugins.sh

source_if_exists ~/.openclaw/completions/openclaw.zsh

# And make sure pyenv takes over system python
if [[ "$(uname -s)" == "Darwin" ]]; then
    export PATH="$(pyenv root)/shims:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Always do these steps when opening up interactive Python shells
if [ -f $PYTHONSTARTUP ]; then
   export PYTHONSTARTUP
else
   PYTHONSTARTUP="$HOME/.ipython/profile_default/startup/pyrc.py"
   if [ -f $PYTHONSTARTUP ]; then
      export PYTHONSTARTUP
   else
      echo "Not able to set PYTHONSTARTUP"
   fi
fi

# Autocomplete
[[ -f /opt/dev/sh/chruby/chruby.sh ]] && {
  type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
  # Load Ruby 3.3.6 by default if available
  if type chruby > /dev/null 2>&1; then
    chruby 3.4.2 2>/dev/null || true
  fi
}

zstyle ':completion:*' menu select
fpath+=~/.zfunc
eval "$(direnv hook zsh)"

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }

### Finally, load any userland aliases and secrets ###
source_if_exists ~/.env
source_if_exists ~/.aliases

# Added by tec agent
[[ -x /Users/leblancfg/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/leblancfg/.local/state/tec/profiles/base/current/global/init zsh)"
