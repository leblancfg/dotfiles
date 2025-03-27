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

### User configuration

## Installs
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"; fi
# if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
# if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# Userland niceities
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"

# Use that brew stuff
[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)
[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

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
mkdir -p $ZSH_CUSTOM/plugins/poetry
[ -x "$(command -v poetry)" ] && poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }

# Spin completion
autoload -Uz compinit && compinit
# Check if it's in PATH first
if [[ -f /usr/local/bin/spin ]]; then
  source <(spin completion --shell=zsh)
fi

# Load any userland secrets
if [[ -f ~/.env ]]; then
    source ~/.env
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs, plugins,
# and themes. Aliases can be placed here, though oh-my-zsh users are encouraged
# to define aliases within the ZSH_CUSTOM folder.  For a full list of active
# aliases, run `alias`.
# export CLOUDSDK_PYTHON=/usr/bin/python3
source ~/.aliases

# Talk to vim
export WHISPER_CPP_HOME=$HOME/src/github.com/ggerganov/whisper.cpp
PATH=$PATH:$WHISPER_CPP_HOME/examples/whisper.nvim/

# One Password
ONEPASSPLUGS=$HOME/leblancfg/.config/op/plugins.sh
[[ -f $ONEPASSPLUGS ]] && source $ONEPASSPLUGS

zstyle ':completion:*' menu select
fpath+=~/.zfunc
eval "$(direnv hook zsh)"
