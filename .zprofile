export DEV=~/dev

export NVM_DIR=~/.nvm 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

path=(
  ~/bin
  ~/.local/bin
  /opt/homebrew/{bin,sbin}
  $path
)

eval "$(pyenv init --path)"
