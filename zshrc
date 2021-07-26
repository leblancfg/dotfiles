# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/leblancfg/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

### User configuration

# Hook up smarter Ctrl-R
if [[ -r "$(brew --prefix)/opt/mcfly/mcfly.zsh" ]]; then
      source "$(brew --prefix)/opt/mcfly/mcfly.zsh"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs, plugins,
# and themes. Aliases can be placed here, though oh-my-zsh users are encouraged
# to define aliases within the ZSH_CUSTOM folder.  For a full list of active
# aliases, run `alias`.
source ~/.aliases

# Nix installer
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
if [ -e /Users/leblancfg/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/leblancfg/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

## Installs
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

### The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/leblancfg/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/leblancfg/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/leblancfg/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/leblancfg/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(pyenv virtualenv-init -)"

# Oh and screw MacOS sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# Autocomplete
# autoload -U compinit; compinit

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
