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

echo "Creating folders"
mkdir -p ~/dev/beyondevil
mkdir -p ~/.config/zsh/plugins
mkdir -p ~/bin
mkdir -p ~/.local/bin

export DEV=~/dev

# installed by brew
#if ! xcode-select -p 1>/dev/null; then
#  echo "Installing xcode command line tools"
#  xcode-select --install
#fi

# clone the dotfiles repo
dotfiles_repo="${DEV}/beyondevil/dotfiles"
if [[ ! -d "${dotfiles_repo}/.git" ]]; then
  echo "Cloning dotfiles"
  git clone --recursive https://github.com/BeyondEvil/dotfiles.git "${dotfiles_repo}"
  # change remote to SSH
  pushd "${dotfiles_repo}" 1>/dev/null || exit 1
  git remote set-url origin git@github.com:BeyondEvil/dotfiles.git
else
  echo "Updating dotfiles"
  pushd "${dotfiles_repo}" 1>/dev/null || exit 1
  git pull --ff-only
fi
popd 1>/dev/null || exit 1

if ! /opt/homebrew/bin/brew --version 1>/dev/null; then
  echo "Installing Homebrew"
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew analytics off

#if ! brew tap | grep -q "homebrew/cask-fonts"; then
#  brew tap homebrew/cask-fonts
#fi
brew update && brew upgrade

IFS=$'\n' read -r -d '' -a formulae << 'END' || :
fzf
jq
font-hack-nerd-font
starship
END

echo "Installing formulae"
brew install "${formulae[@]}"

IFS=$'\n' read -r -d '' -a casks << 'END' || :
iterm2
visual-studio-code
END

echo "Installing casks"
brew install --cask "${casks[@]}"

echo "Cleaning up"
brew cleanup

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/.config/zsh

# Install zsh plugins
IFS=$'\n' read -r -d '' -a plugins << 'END' || :
https://github.com/zsh-users/zsh-syntax-highlighting.git
https://github.com/zsh-users/zsh-autosuggestions.git
https://github.com/zsh-users/zsh-completions.git
END

for plugin in "${plugins[@]}"; do
  get "${plugin}"
done

echo "Link dotfiles to ZDOTDIR"
ln -sfn ${dotfiles_repo}/.z* ${ZDOTDIR}

echo "Link starship.toml to config dir"
ln -sfn ${dotfiles_repo}/starship.toml ~/.config/

echo "Link gitfiles to home"
# giconfig we copy because we make changes we don't want to track
cp ${dotfiles_repo}/gitconfig ~/.gitconfig
ln -sfn ${dotfiles_repo}/gitignore ~/.gitignore

read -p "git committer email: " committer_email
git config --global user.email "${committer_email}"

echo "Change the root .zshenv file to use ZDOTDIR"
if [[ ! -s ~/.zshenv ]]; then
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF
fi

echo "Done"
