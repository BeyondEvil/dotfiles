#!/usr/bin/env bash

set -eo pipefail

dotfiles_repo="${1}"

if ! arch -arch x86_64 uname -m &>/dev/null; then
  echo "Installing Rosetta 2"
  # needed for AWS CLI 2
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

if ! which aws 1>/dev/null; then
  echo "Installing AWS CLI"
  curl -fsSL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sed -i '' -e "s;%%HOME%%;${HOME}/dev;g" "${dotfiles_repo}/awscli.xml"
  installer -pkg AWSCLIV2.pkg \
    -target CurrentUserHomeDirectory \
    -applyChoiceChangesXML "${dotfiles_repo}/awscli.xml"
  ln -s ~/dev/aws-cli/aws ~/.local/bin/aws
  ln -s ~/dev/aws-cli/aws_completer ~/.local/bin/aws_completer
  rm "AWSCLIV2.pkg"
fi

brew install --cask aws-vault
brew install ykman tfenv
