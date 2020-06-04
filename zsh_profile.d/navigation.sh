# Delete word by word with option+backspace (Requires iterm keyboard mapping defined in the preferences file in this repo)
# https://unix.stackexchange.com/questions/258656/how-can-i-delete-to-a-slash-or-a-word-in-zsh
#
# Should be paired with removal of custom keymapping in vscode:
#
#  {
#    "key": "alt+backspace",
#    "command": "-workbench.action.terminal.deleteWordLeft",
#    "when": "terminalFocus"
#  },
#
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir