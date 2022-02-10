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

echo "pip version before"
pip --version

echo "Update pip"
python -m pip install --upgrade pip

echo "pip version after"
pip --version

echo "zsh path: $path"
echo "os PATH: $PATH"

# echo "pipx ensurepath"
echo "Install pipx"
python -m pip install --user --upgrade pipx
# brew install --ignore-dependencies pipx
# pipx ensurepath


# echo "restart the shell"
# exec zsh -l

echo "pipx version"
pipx --version

# echo "Install awscli"
pipx install awscli

# echo "AWS version"
aws --version
