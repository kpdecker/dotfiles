alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ls="ls -lhaF"

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
