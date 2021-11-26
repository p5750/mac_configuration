#!/bin/bash

set -Ceu

# Validation: must be bash
if [ -z "$BASH_VERSION" ] || [ "${BASH##*/}" != "bash" ]; then
  echo "$0: ERROR: Use bash" >&2
  exit 1
fi

# Validation: The OS must be macOS
if [ "$(uname)" != "Darwin" ]; then
  echo "$0: ERROR: macOS only"
  exit 1
fi

# dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# disable the sound on boot
sudo nvram SystemAudioVolume=%80

# Dock
defaults write com.apple.dock tilesize -integer 35
defaults write com.apple.dock orientation -string "right"
defaults write com.apple.dock show-recents -bool false
killall Dock

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder FXPreferredViewStyle clmv
chflags nohidden ~/Library
killall Finder

# Screen Capture
defaults write com.apple.screencapture location ~/Downloads

# Clock
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"

# Keyboard
## Remap capslock to control
keyboard_vid=$(ioreg -n 'Apple Internal Keyboard / Trackpad' -r | grep -E 'idVendor' | awk '{ print $4 }' | head -1)
keyboard_pid=$(ioreg -n 'Apple Internal Keyboard / Trackpad' -r | grep -E 'idProduct' | awk '{ print $4 }' | head -1)
keyboardid="${keyboard_vid}-${keyboard_pid}-0"
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboardid} -array-add '
<dict>
  <key>HIDKeyboardModifierMappingDst</key>
  <integer>30064771296</integer>
  <key>HIDKeyboardModifierMappingSrc</key>
  <integer>30064771129</integer>
</dict>
'
