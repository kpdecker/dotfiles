#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

for path in ~/.dotfiles/setup/osx-defaults/*; do
  $path
done

for app in "Activity Monitor" \
  "Address Book" \
  "Calendar" \
  "cfprefsd" \
  "Contacts" \
  "Dock" \
  "Google Chrome Canary" \
  "Google Chrome" \
  "Mail" \
  "Messages" \
  "Photos" \
  "Safari" \
  "SystemUIServer" \
  "Terminal" \
  "Transmission" \
  "Twitter" \
  "iCal"; do
  killall "${app}" &> /dev/null
done

ln -s ~/.dotfiles/osx/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
