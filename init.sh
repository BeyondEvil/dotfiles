#!/bin/bash

echo "Create folders"
# mkdir -p $HOME/dev
# mkdir -p $HOME/.config/zsh
# mkdir -p $HOME/bin

if ! xcode-select -p 1>/dev/null; then
  echo "Installing xcode command line tools..."
  xcode-select --install
fi

if ! which brew 1>/dev/null; then
  echo "Installing Homebrew..."
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Done"
