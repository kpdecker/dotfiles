alias cov='open `find . -path ./node_modules -prune -o -path "*/lcov-report/index.html" -print`'

. ~/.nvm/nvm.sh

export PATH=~/.config/yarn/global/node_modules/.bin/:$PATH
export PATH=./node_modules/.bin:$PATH

export PATH="$HOME/.yarn/bin:$PATH"
