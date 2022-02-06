#!/bin/bash

echo "Create folders"
mkdir -p $HOME/dev
mkdir -p $HOME/.config/zsh
mkdir -p $HOME/bin

if ! xcode-select -p 1>/dev/null; then
  echo "Installing xcode command line tools..."
  xcode-select --install
fi

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/.config/zsh

# clone the dotfiles repo
git clone --recursive git@github.com:mattmc3/zdotdir.git $ZDOTDIR

# change the root .zshenv file to use ZDOTDIR
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF

if ! which brew 1>/dev/null; then
  echo "Installing Homebrew..."
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Done"
