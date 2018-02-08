alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ls="ls -lhaF"

server() {
  open "http://localhost:${1}" && python -m SimpleHTTPServer $1
}
