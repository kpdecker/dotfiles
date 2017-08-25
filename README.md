# dotfiles

My own dotfiles. There are many like them, but this one is my own.

## New Machines Steps

1. Install Chrome
2. Manually install password manager and other app store apps
3. Install non-dev tools
    1. [Alfred](https://www.alfredapp.com/)
    2. [Stay](https://cordlessdog.com/stay/)
    3. [Divvy](http://mizage.com/divvy/)
    4. [Spotify](https://www.spotify.com/us/download/mac/)
    5. [Better Touch Tool](https://www.boastr.net/)
4. Install dev tools
    1. [iTerm](https://www.iterm2.com/)
    2. [Gitx](https://rowanj.github.io/gitx/)
    3. [Homebrew](https://brew.sh/)
    4. git-extras: `brew install git-extras`
    5. [nvm](https://github.com/creationix/nvm)
    
Within the home directory, run:

```
git clone git@github.com:kpdecker/dotfiles.git .dotfiles
ln -s ~/.dotfiles/profile.sh ~/.profile
ls -s ~/.dotfiles/bin ~/bin
ln -s ~/.dotfiles/bash_completion.d ~/.bash_completion.d
```


Based losely on [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles).
