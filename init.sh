#!/bin/bash

set -eo pipefail

NVM_VERSION=0.39.1

echo "Creating folders"
mkdir -p ~/dev
mkdir -p ~/.config/zsh/plugins
mkdir -p ~/bin

export DEV=~/dev

if ! xcode-select -p 1>/dev/null; then
  echo "Installing xcode command line tools"
  xcode-select --install
fi

if ! /usr/bin/pgrep oahd &>/dev/null; then
  echo "Installing Rosetta 2"
  # needed for AWS CLI 2
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/.config/zsh

# clone the dotfiles repo
if [[ ! -d $DEV/dotfiles/.git ]]; then
  echo "Cloning dotfiles"
  git clone --recursive https://github.com/BeyondEvil/dotfiles.git $DEV/dotfiles
else
  echo "Updating dotfiles"
  pushd $DEV/dotfiles 1>/dev/null || exit 1
  git pull --ff-only
  popd 1>/dev/null || exit 1
fi

echo "Copying dotfiles to ZDOTDIR"
cp $DEV/dotfiles/.z* $ZDOTDIR

# change the root .zshenv file to use ZDOTDIR
if [[ -s ~/.zshenv ]]; then
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF
fi

if ! which brew 1>/dev/null; then
  echo "Installing Homebrew"
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ ! -d ~/.nvm ]]; then
  echo "Installing NVM"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
fi

# zsh -c "nvm install --lts && nvm alias default $(node --version)"

zsh_highlight_dir=$ZDOTDIR/plugins/zsh-syntax-highlighting
if [[ ! -d $zsh_highlight_dir/.git ]]; then
  echo "Installing zsh syntax highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_highlight_dir
else
  echo "Updating zsh syntax highlighting"
  pushd $zsh_highlight_dir 1>/dev/null || exit 1
  git pull --ff-only
  popd 1>/dev/null || exit 1
fi

brew tap homebrew/cask-fonts
brew update && brew upgrade

formulae="
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
starship
stern
sqlite3
wget
xz
zlib
"

echo "Installing formulae"
brew install $formulae 2>/dev/null

casks="
1password
bitwarden
brave-browser
docker
font-hack-nerd-font
google-chrome
intellij-idea
iterm2
pycharm
slack
"

echo "Installing casks"
brew install --cask $casks 2>/dev/null

echo "Cleaning up"
brew cleanup

echo "Setting up python env"
/bin/zsh -l $DEV/dotfiles/python_env.zsh

if ! which aws 1>/dev/null; then
  echo "Installing AWS CLI"
  curl -fsSL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sed -i '' -e "s;%%HOME%%;${HOME}/dev;g" "${DEV}/dotfiles/awscli.xml"
  installer -pkg AWSCLIV2.pkg \
    -target CurrentUserHomeDirectory \
    -applyChoiceChangesXML "${DEV}/dotfiles/awscli.xml"
    ln -s ~/dev/aws-cli/aws ~/.local/bin/aws
    ln -s ~/dev/aws-cli/aws_completer ~/.local/bin/aws_completer
  rm "AWSCLIV2.pkg"
fi

echo "Done"
