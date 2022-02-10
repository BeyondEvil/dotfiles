#!/bin/bash

set -eo pipefail

NVM_VERSION=0.39.1

echo "Create folders"
mkdir -p ~/dev
mkdir -p ~/.config/zsh/plugins
mkdir -p ~/bin

export DEV=~/dev

echo "WHAT IS DEV: ${DEV}"

if ! xcode-select -p 1>/dev/null; then
  echo "Installing xcode command line tools..."
  xcode-select --install
fi

echo "EXPORT ZDOTDIR"

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/.config/zsh

echo "CLONE DOTFILES"
# clone the dotfiles repo
if [[ ! -d $DEV/dotfiles/.git ]]; then
  echo "CLONING"
  git clone --recursive https://github.com/BeyondEvil/dotfiles.git $DEV/dotfiles
else
  echo "PULLING"
  pushd $DEV/dotfiles
  git pull
  popd
fi

echo "COPY DOTFILES"
cp $DEV/dotfiles/.z* $ZDOTDIR

echo "USE ZDOTDIR"
# change the root .zshenv file to use ZDOTDIR
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF

echo "INSTALL BREW"

if ! which brew 1>/dev/null; then
  echo "Installing Homebrew..."
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "EVAL BREW"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "INSTALL NVM"
if ! nvm &>/dev/null; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
fi

# zsh -c "nvm install --lts && nvm alias default $(node --version)"

echo "INSTALL ZSH SYNTAX HIGHLIGHTING"
if [[ ! -d $ZDOTDIR/plugins/zsh-syntax-hightlighting/.git ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZDOTDIR/plugins/zsh-syntax-highlighting
fi

echo "BREW UPDATE"
brew update

echo "BREW upgrade"
brew upgrade

formulae="
awscli
go
jq
jsonnet
kubectl
kubectx
openssl
pure
pyenv
readline
shellcheck
stern
sqlite3
wget
xz
zlib
"

echo "BREW INSTALL FORMULAE"
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

echo "BREW INSTALL CASKS"
brew install --cask $casks

echo "BREW CLEANUP"
brew cleanup

echo "Done"
