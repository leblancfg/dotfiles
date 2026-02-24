# atheoster.zsh-theme
#
# Minimal async powerline prompt. Renders instantly; git branch and
# dirty state load in the background and patch in when ready. A small
# placeholder segment holds the space while git info is in flight so
# the prompt never feels like it's still loading.

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

# ── Async git ────────────────────────────────────────────────────────

typeset -g _git_text="" _git_bg="" _git_fg=""
typeset -g _git_fd="" _git_pid=0 _git_pending=0
typeset -g _retval=0

# Pure filesystem walk -- no subprocess, effectively free.
_in_git_repo() {
  local dir="$1"
  while [[ "$dir" != "/" ]]; do
    [[ -e "$dir/.git" ]] && return 0
    dir="${dir:h}"
  done
  return 1
}

# Runs in a subshell. Outputs "bg:fg:text" or nothing.
_git_worker() {
  builtin cd -q "$1" 2>/dev/null || return
  command git rev-parse --is-inside-work-tree 2>/dev/null | command grep -q true || return

  local ref
  ref=$(command git symbolic-ref --short HEAD 2>/dev/null) || \
  ref=$(command git describe --exact-match --tags HEAD 2>/dev/null) || \
  ref=$(command git rev-parse --short HEAD 2>/dev/null) || return

  local PL_BRANCH_CHAR=$'\ue0a0'

  if [[ -n "$(command git status --porcelain --untracked-files=no --ignore-submodules=dirty 2>/dev/null | head -1)" ]]; then
    printf 'yellow:black:%s' "${PL_BRANCH_CHAR} ${ref} ±"
  else
    printf 'green:black:%s' "${PL_BRANCH_CHAR} ${ref}"
  fi
}

_git_callback() {
  local fd=$1
  zle -F $fd 2>/dev/null

  local result=""
  IFS= read -r result <&$fd 2>/dev/null
  exec {fd}<&- 2>/dev/null
  _git_fd=""
  _git_pending=0

  if [[ -n "$result" ]]; then
    _git_bg="${result%%:*}"; result="${result#*:}"
    _git_fg="${result%%:*}"
    _git_text="${result#*:}"
  fi

  zle && zle reset-prompt
}

_atheoster_precmd() {
  _retval=$?

  # Tear down previous async job
  if [[ -n "$_git_fd" ]]; then
    zle -F $_git_fd 2>/dev/null
    exec {_git_fd}<&- 2>/dev/null
    _git_fd=""
  fi
  if (( _git_pid > 0 )) && kill -0 $_git_pid 2>/dev/null; then
    kill $_git_pid 2>/dev/null
  fi

  _git_text="" _git_bg="" _git_fg="" _git_pending=0

  if _in_git_repo "$PWD"; then
    _git_pending=1
    exec {_git_fd}< <(_git_worker "$PWD")
    _git_pid=$!
    zle -F $_git_fd _git_callback
  fi
}

# ── Build prompt ─────────────────────────────────────────────────────

build_prompt() {
  CURRENT_BG='NONE'
  prompt_status
  prompt_context
  prompt_dir
  if [[ -n "$_git_text" ]]; then
    prompt_segment "$_git_bg" "$_git_fg" "$_git_text"
  elif (( _git_pending )); then
    prompt_segment white black $'\ue0a0 \u28FB'
  fi
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '

autoload -Uz add-zsh-hook
add-zsh-hook precmd _atheoster_precmd
