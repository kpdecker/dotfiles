function timer_start {
  # timerCmd=$(history 1 | sed -e 's/^[ 0-9]*//')
  # echo $timerCmd
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

if [[ "$-" = *i* ]]; then
  export BASH_INTERACTIVE=true
else
  export BASH_INTERACTIVE=false
fi

[[ -z $precmd_functions ]] && precmd_functions=()

# Profile content
source ~/.dotfiles/env.sh

for scriptPath in ~/.dotfiles/profile.d/*; do
  source $scriptPath
done

for scriptPath in ~/.dotfiles/zsh_profile.d/*; do
  source $scriptPath
done


if [ "$BASH_INTERACTIVE" = true ]; then
  # Shared history for all shells
  setopt INC_APPEND_HISTORY

  trap 'timer_start' DEBUG
  precmd_functions=($precmd_functions timer_stop)
fi
