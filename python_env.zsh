[[ -o login ]] && echo "Login" || echo "Non-Login"

echo "Install python 3.9"
pyenv install --skip-existing 3.9.10

echo "Set python 3.9 as global"
pyenv global 3.9.10

echo "pyenv versions"
pyenv versions

echo "Which python"
whence -p python
python --version

echo "Which python3"
whence -p python3
python --version

echo "zsh path: $path"
echo "os PATH: $PATH"

# echo "pipx ensurepath"
echo "Install pipx"
brew install pipx
# pipx ensurepath


# echo "restart the shell"
# exec zsh -l

echo "pipx version"
pipx --version

# echo "Install awscli"
# pipx install awscli

# echo "AWS version"
# aws --version
