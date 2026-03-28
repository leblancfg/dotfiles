# atheoster.zsh-theme
#
# Minimal powerline prompt with git branch and dirty-state indicator.

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'
}

CURRENT_BG='NONE'

# ── Segment drawing ──────────────────────────────────────────────────

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# ── Segments ─────────────────────────────────────────────────────────

prompt_status() {
  local -a symbols
  [[ $_retval -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n"
  fi
}

prompt_dir() {
  prompt_segment blue black '%c'
}

# ── Git (synchronous) ────────────────────────────────────────────────

typeset -g _retval=0

prompt_git() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local ref
  ref=$(command git symbolic-ref --short HEAD 2>/dev/null) || \
  ref=$(command git describe --exact-match --tags HEAD 2>/dev/null) || \
  ref=$(command git rev-parse --short HEAD 2>/dev/null) || return

  local PL_BRANCH_CHAR=$'\ue0a0'

  if [[ -n "$(command git status --porcelain --untracked-files=no --ignore-submodules=dirty 2>/dev/null | head -1)" ]]; then
    prompt_segment yellow black "${PL_BRANCH_CHAR} ${ref} ±"
  else
    prompt_segment green black "${PL_BRANCH_CHAR} ${ref}"
  fi
}

# ── Build prompt ─────────────────────────────────────────────────────

build_prompt() {
  CURRENT_BG='NONE'
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

_atheoster_save_retval() { _retval=$? }

setopt PROMPT_SUBST
PROMPT='%{%f%b%k%}$(build_prompt) '

autoload -Uz add-zsh-hook
add-zsh-hook precmd _atheoster_save_retval
