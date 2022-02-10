echo "Install python 3.9"
pyenv install 3.9

echo "Set python 3.9 as global"
pyenv global 3.9

echo "Which python"
whence -p python

echo "Which python3"
whence -p python3

echo "pipx ensurepath"
pipx ensurepath

echo "restart the shell"
exec zsh -l

echo "pipx version"
pipx --version

echo "Install awscli"
pipx install awscli

echo "AWS version"
aws --version



