alias cov='open `find . -path ./node_modules -prune -o -path "*/lcov-report/index.html" -print`'

if [ -f ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh

  export PATH="$HOME/.yarn/bin:$PATH"
fi

export PATH=~/.config/yarn/global/node_modules/.bin/:$PATH
export PATH=./node_modules/.bin:$PATH

