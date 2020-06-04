alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls -lhaF --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
else
  # OSX has no --color, but default
  alias ls="ls -lhaF"

  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
  export GREP_OPTIONS='--color=auto'
fi

server() {
  open "http://localhost:${1}" && python -m  http.server $1
}

urldecode(){
  echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x\1/g;')";
}

alias yj="yarn jest"
alias yju="yarn jest -u"
alias ynb="yarn next:build"

alias gitx="fork"
