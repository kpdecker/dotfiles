
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
for path in ~/.dotfiles/bash_completion.d/* ~/.bash_completion.d/* /etc/bash_completion.d/*; do
  source $path
done

# Profile content
source ~/.dotfiles/env.sh

for path in ~/.dotfiles/bash_profile.d/*; do
  source $path
done

trap 'timer_start' DEBUG
export PROMPT_COMMAND="timer_stop"

