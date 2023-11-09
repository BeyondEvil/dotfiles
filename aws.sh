#!/usr/bin/env bash

set -eo pipefail

if ! arch -arch x86_64 uname -m &>/dev/null; then
  echo "Installing Rosetta 2"
  # needed for AWS CLI 2
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

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

brew install --cask aws-vault
