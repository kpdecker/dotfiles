
# Bash Completions
for path in ~/.dotfiles/bash_completion.d/* ~/.bash_completion.d/* /etc/bash_completion.d/*; do
  source $path
done

# Profile content
source ~/.dotfiles/env.sh

for path in ~/.dotfiles/bash_profile.d/*; do
  source $path
done
