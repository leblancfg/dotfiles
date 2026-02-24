# Terminal settings
stty -ixon -ixoff
export LS_COLORS=''  # Prettier `fd`
export ZVM_CURSOR_STYLE_ENABLED=false

# ── Completion ───────────────────────────────────────────────────────
autoload -Uz compinit
# Only regenerate .zcompdump once a day (stat check avoids slow compaudit)
if [[ -z "$ZSH_COMPDUMP" ]]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
fi
if [[ ! -f "$ZSH_COMPDUMP" || $(date +'%j') != $(stat -f '%Sm' -t '%j' "$ZSH_COMPDUMP" 2>/dev/null) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

zmodload -i zsh/complist
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'   # case-insensitive, partial-word

# ── Key bindings ─────────────────────────────────────────────────────
bindkey -e   # emacs mode

# Up/Down arrow: prefix-aware history search
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# Home / End
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}"  ]] && bindkey "${terminfo[kend]}"  end-of-line

# Shift-Tab: reverse menu completion
[[ -n "${terminfo[kcbt]}" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

bindkey '^r' history-incremental-search-backward
bindkey ' ' magic-space   # history expansion on space

# Edit command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# ── Terminal title (tmux / iTerm) ────────────────────────────────────
function _set_title_precmd { print -Pn "\e]2;%n@%m:%~\a"; print -Pn "\e]1;%15<..<%~%<<\a" }
function _set_title_preexec { print -Pn "\e]2;$2\a" }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _set_title_precmd
add-zsh-hook preexec _set_title_preexec

# ── Prompt ───────────────────────────────────────────────────────────
source "$HOME/dotfiles/atheoster.zsh-theme"

# ── Git aliases (the handful from omz you actually used) ─────────────
alias gco='git checkout'
alias gd='git diff'
alias ga='git add'
alias gb='git branch'
alias gf='git fetch'
alias gm='git merge'
alias grb='git rebase'
alias grba='git rebase --abort'
alias gss='git status --short'

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
