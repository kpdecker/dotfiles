if [[ "$-" = *i* ]]; then
  export BASH_INTERACTIVE=true
else
  export BASH_INTERACTIVE=false
fi

# Profile content
source ~/.dotfiles/env.sh

for scriptPath in ~/.dotfiles/profile.d/*; do
  source $scriptPath
done

for scriptPath in ~/.dotfiles/zsh_profile.d/*; do
  source $scriptPath
done
