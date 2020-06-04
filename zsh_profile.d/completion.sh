if [ "$BASH_INTERACTIVE" = true ]; then
  # Add tab completion for many brew commands
  if which brew &> /dev/null && [ -e "$(brew --prefix)/share/zsh-completions" ]; then
     fpath=($(brew --prefix)/share/zsh-completions $fpath)
  fi;
  if which brew &> /dev/null && [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
     source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi;

  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

  autoload -U compinit && compinit
fi
