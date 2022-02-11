echo "Install python 3.9"
pyenv install --skip-existing 3.9.10

echo "Set python 3.9 as global"
pyenv global 3.9.10

echo "Update pip"
python -m pip install --upgrade pip

echo "Install pipx"
python -m pip install --user --upgrade pipx

echo "Install poetry"
curl -sSL https://install.python-poetry.org | python -
