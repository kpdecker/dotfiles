if [[ "$-" = *i* ]]; then
  export BASH_INTERACTIVE=true
else
  export BASH_INTERACTIVE=false
fi

# Profile content
source ~/.dotfiles/env.sh

for path in ~/.dotfiles/profile.d/*; do
  source $path
done
