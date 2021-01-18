# @gf3’s Sexy Bash Prompt, inspired by “Extravagant Zsh Prompt”
# Shamelessly copied from https://github.com/gf3/dotfiles
# Screenshot: http://i.imgur.com/s0Blh.png

if [ "$BASH_INTERACTIVE" = false ]; then
  return
fi

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    MAGENTA=$(tput setaf 9)
    ORANGE=$(tput setaf 172)
    GREEN=$(tput setaf 190)
    PURPLE=$(tput setaf 141)
    WHITE=$(tput setaf 0)
  else
    MAGENTA=$(tput setaf 5)
    ORANGE=$(tput setaf 4)
    GREEN=$(tput setaf 2)
    PURPLE=$(tput setaf 1)
    WHITE=$(tput setaf 7)
  fi
  BOLD=$(tput bold)
else
  MAGENTA="\033[1;31m"
  ORANGE="\033[1;33m"
  GREEN="\033[1;32m"
  PURPLE="\033[1;35m"
  WHITE="\033[1;37m"
  BOLD=""
fi

c_cyan=`tput setaf 6`
c_red=`tput setaf 1`

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

function branch_color() {
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    color=""
    git diff --quiet 2>/dev/null >&2
    if [[ $? -eq 0 ]]
    then
      color=${c_cyan}
    else
      color=${c_red}
    fi
  else
    return 0
  fi
  echo -ne $color
}

function f_notifyme {
  LAST_EXIT_CODE=$?
  CMD=$(history 1 | sed -e 's/^[ 0-9]*//')

  if [ "$timer_show" -gt 3 ]; then
    printf "${WHITE}[Exec: ${timer_show}s]\n\u200b$reset_color"
    # No point in waiting for the command to complete
    ~/.dotfiles/notify.applescript "$CMD" "$LAST_EXIT_CODE" > /dev/null 2>&1 &
  fi
}

# Nav history by prefix
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Word Handling
bindkey "\e[1;9D" backward-word
bindkey "\e[1;9C" forward-word
# VSCode keycodes
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# Treat slashes as word separators for delete
# bind '\C-w:unix-filename-rubout'

setopt PROMPT_SUBST
function prompt() {
  local time="%D{%H:%M:%S}"
  local user="%{$MAGENTA%}%n"
  local host="%{$ORANGE%}%m"
  local dir_name="%{$GREEN%}%2d"
  local branch="%{\$(branch_color)%}\$(parse_git_branch)"
  local promptText="%{$WHITE%} \\\$ "

  export PROMPT="\$(f_notifyme)%B$user%{$WHITE%}@$host%{$WHITE%}:$dir_name$branch $promptText%{$reset_color%}%b\$(timer_stop)"
  export RPROMPT="$time"
}

prompt
