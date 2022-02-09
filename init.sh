#!/bin/bash

set -eo pipefail

NVM_VERSION=0.39.1

echo "Create folders"
mkdir -p ~/dev
mkdir -p ~/.config/zsh/plugins
mkdir -p ~/bin

DEV=~/dev

if ! xcode-select -p 1>/dev/null; then
  echo "Installing xcode command line tools..."
  xcode-select --install
fi
#
## set the amazing ZDOTDIR variable
#export ZDOTDIR=~/.config/zsh
#
## clone the dotfiles repo
#if [[ ! -d $DEV/dotfiles/.git ]]; then
#  git clone --recursive git@github.com:BeyondEvil/dotfiles.git $DEV/dotfiles
#else
#  pushd $DEV/dotfiles
#  git pull
#  popd
#if
#
#cp $DEV/dotfiles/.z* $ZDOTDIR
#
## change the root .zshenv file to use ZDOTDIR
#cat << 'EOF' >| ~/.zshenv
#export ZDOTDIR=~/.config/zsh
#[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
#EOF
#
#if ! which brew 1>/dev/null; then
#  echo "Installing Homebrew..."
#  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#fi
#
#eval "$(/opt/homebrew/bin/brew shellenv)"
#
#if ! nvm &>/dev/null; then
#  echo "Installing NVM..."
#  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
#fi
#
## zsh -c "nvm install --lts && nvm alias default $(node --version)"
#
#if [[ ! -d $ZDOTDIR/plugins/zsh-syntax-hightlighting/.git ]]; then
#  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZDOTDIR/plugins/zsh-syntax-hightlighting
#fi
#
#brew update
#
#brew upgrade
#
#formulae="
#awscli
#go
#jq
#jsonnet
#kubectl
#kubectx
#openssl
#pure
#pyenv
#readline
#shellcheck
#stern
#sqlite3
#wget
#xz
#zlib
#"
#
#brew install $formulae
#
#casks="
#1password
#bitwarden
#brave-browser
#docker
#google-chrome
#intellij-idea
#iterm2
#pycharm
#slack
#"
#
#brew install --cask $casks
#
#brew cleanup

echo "Done"
