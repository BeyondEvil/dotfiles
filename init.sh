#!/bin/bash

set -eo pipefail

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
if [[ ! -d $ZDOTDIR/.git ]]; then
  git clone --recursive git@github.com:BeyondEvil/dotfiles.git $ZDOTDIR
else
  pushd $ZDOTDIR
  git pull
  popd
if

# change the root .zshenv file to use ZDOTDIR
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF

if ! which brew 1>/dev/null; then
  echo "Installing Homebrew..."
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew update

brew upgrade

formulae="
awscli
go
jq
jsonnet
kubectl
kubectx
openssl
pyenv
readline
shellcheck
stern
sqlite3
wget
xz
zlib
"

brew install $formulae

casks="
1password
bitwarden
brave-browser
docker
google-chrome
intellij-idea
iterm2
pycharm
slack
"

brew install --cask $casks

echo "Done"
