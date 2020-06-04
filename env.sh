export PATH=/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=~/.dotfiles/git-commands:$PATH

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


if [[ -f `which subl` ]]; then
  export EDITOR='subl -w'
else
  export EDITOR='vi'
fi


# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help:bg:fg"


# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';


# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";
