#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

ln -s .dotfiles/profile.sh ~/.profile
ls -s ~/.dotfiles/bin ~/bin

./setup/osx-defaults.sh
./setup/brew.sh
./setup/git.sh

echo "Done. Note that some of these changes require a logout/restart to take effect."
