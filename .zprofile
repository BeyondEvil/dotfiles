echo 'eval "$(pyenv init --path)"'

export DEV=~/dev

path=(
  ~/bin
  /opt/homebrew/{bin,sbin}
  $path
)
