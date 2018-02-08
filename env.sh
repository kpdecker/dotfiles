export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=~/.dotfiles/git-commands:$PATH
export PATH=~/bin:$PATH

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export EDITOR='subl -w'

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_OPTIONS='--color=auto'


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
