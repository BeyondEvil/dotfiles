#!/usr/bin/env bash

set -eo pipefail

get() {
  local plugin="${1}"
  local name
  local install_dir

  name=$(basename -s .git "${plugin}")
  install_dir=${ZDOTDIR}/plugins/${name}

  echo "plugin: ${plugin}"
  echo "name: ${name}"
  echo "install dir: ${install_dir}"

  if [[ ! -d ${install_dir}/.git ]]; then
    echo "Installing zsh plugin ${name}"
    git clone "${plugin}" "${install_dir}"
  else
    echo "Updating zsh plugin ${name}"
    pushd "${install_dir}" 1>/dev/null || exit 1
    git pull --ff-only
    popd 1>/dev/null || exit 1
  fi
}

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

if ! arch -arch x86_64 uname -m &>/dev/null; then
  echo "Installing Rosetta 2"
  # needed for AWS CLI 2
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

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

# Install zsh plugins
IFS=$'\n' read -r -d '' -a plugins << 'END' || :
https://github.com/zsh-users/zsh-syntax-highlighting.git
https://github.com/zsh-users/zsh-autosuggestions.git
https://github.com/zsh-users/zsh-completions.git
END

for plugin in "${plugins[@]}"; do
  get "${plugin}"
done

brew tap homebrew/cask-fonts
brew update && brew upgrade

IFS=$'\n' read -r -d '' -a formulae << 'END' || :
direnv
docker-credential-helper-ecr
go
jq
jsonnet
kubectl
kubectx
openssl
pre-commit
pure
pyenv
readline
shellcheck
starship
stern
sqlite3
wget
xz
ykman
zlib
END

echo "Installing formulae"
brew install "${formulae[@]}"

IFS=$'\n' read -r -d '' -a casks << 'END' || :
1password
aws-vault
brave-browser
docker
font-hack-nerd-font
google-chrome
intellij-idea
iterm2
pycharm
slack
spotify
vnc-viewer
yubico-yubikey-manager
END

echo "Installing casks"
brew install --cask "${casks[@]}"

echo "Cleaning up"
brew cleanup

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/.config/zsh

echo "Copying dotfiles to ZDOTDIR"
cp $DEV/dotfiles/.z* $ZDOTDIR

echo "Copy starship.toml to config dir"
cp $DEV/dotfiles/starship.toml ~/.config/

echo "Copy gitfiles to home"
cp $DEV/dotfiles/

echo "Change the root .zshenv file to use ZDOTDIR"
if [[ -s ~/.zshenv ]]; then
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF
fi

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

# OSX settings
# source $DEV/dotfiles/osx.sh CURRENTLY NOT WORKING

echo "Done"
