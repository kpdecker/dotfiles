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
   3. [nvm](https://github.com/creationix/nvm)
   4. [VS Code](https://code.visualstudio.com/)

Within the home directory, run:

```
git clone git@github.com:kpdecker/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
./setup/code.sh
```

Monitor setup:

Large resolution:

```
displayplacer "id:75531AAA-79D6-5909-E410-3E7B79E11BFE res:3008x1692 origin:(-2112,-1692)" "id:85A369C5-8B84-CB33-DA4A-0327F8D8C746 res:3008x1692 origin:(896,-1692)" "id:AFBB28AC-35D4-31C6-DEE0-E26A50BCB926 res:1792x1120 origin:(0,0)"
```

Smaller Resolution:

```
displayplacer "id:75531AAA-79D6-5909-E410-3E7B79E11BFE res:2560x1440 origin:(--384,-1440)" "id:85A369C5-8B84-CB33-DA4A-0327F8D8C746 res:2560x1440 origin:(896,-1440)" "id:AFBB28AC-35D4-31C6-DEE0-E26A50BCB926 res:1792x1120 origin:(0,0)"
```

Based losely on [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles).
