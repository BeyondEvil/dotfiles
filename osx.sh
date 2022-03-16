#!/usr/bin/env bash

# Set top left corner to "lock screen"
defaults write com.apple.dock "wvous-tl-corner" = 5;
defaults write com.apple.dock "wvous-tl-modifier" = 0;

# Set bottom left corner to "show desktop"
defaults write com.apple.dock "wvous-bl-corner" = 4;
defaults write com.apple.dock "wvous-bl-modifier" = 0;
