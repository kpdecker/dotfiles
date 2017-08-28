shopt -s nullglob

function timer_start {
  if [ -z "$timer" ]; then
    timer=${timer:-$SECONDS}
  fi
}

function timer_stop {
  if [ -n "$timer" ]; then
    timer_show=$(($SECONDS - $timer))
    unset timer
  fi
}

# Bash Completions
for path in ~/.dotfiles/bash_completion.d/* ~/.bash_completion.d/*; do
  source $path
done

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
  source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
fi;

# Profile content
source ~/.dotfiles/env.sh

for path in ~/.dotfiles/bash_profile.d/*; do
  source $path
done

shopt -u nullglob # disable

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

trap 'timer_start' DEBUG
export PROMPT_COMMAND="timer_stop"

