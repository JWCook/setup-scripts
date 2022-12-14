#!/usr/bin/env bash
FISH_COMPLETE_DEST=~/.config/fish/completions/poetry.fish
BASH_COMPLETE_DEST=~/.config/bash/completions/poetry.bash-completion
BOOTSTRAPS=bootstrap
VF_REQUIREMENTS=~/.virtualenvs/global_requirements.txt

# Python versions to install and activate with pyenv
# Note: The first version in list will be used as the default 'python3' version
PYTHON_VERSIONS='
    3.11
    3.6
    3.7
    3.8
    3.9
    3.10
    pypy3.9
'

source ~/dotfiles/bash/bashrc

# Use -u (upgrade) to only install new python versions if missing
PYENV_OPTS='-f'
UPDATE_ONLY=
while getopts "u" option; do
    case "${option}" in
        u)
            PYENV_OPTS='-s'
            UPDATE_ONLY='true';;
    esac
done


# Download bootstrap scripts
if test -z $UPDATE_ONLY; then
    print-title 'Downloading install scripts'
    mkdir -p $BOOTSTRAPS
    curl -L https://bootstrap.pypa.io/get-pip.py -o $BOOTSTRAPS/get-pip.py
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer -o $BOOTSTRAPS/get-pyenv.sh
    curl -L https://install.python-poetry.org/install-poetry.py -o $BOOTSTRAPS/install-poetry.py
    curl -L http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o $BOOTSTRAPS/get-miniconda.sh
fi

# Install pyenv
print-title 'Installing/updating pyenv'
if cmd-exists pyenv; then
    pyenv update
else
    bash $BOOTSTRAPS/get-pyenv.sh
fi
pathadd ~/.pyenv/bin/
eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# Install pyenv-virtualenvwrapper plugin from source
# git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper

# Install python versions
for version in $PYTHON_VERSIONS; do
    pyenv install $PYENV_OPTS $version
done
pyenv global $PYTHON_VERSIONS
which python && python --version

# Ensure we have the latest pip (usually only necessary if current pip is broken)
print-title 'Installing/updating pip'
python $BOOTSTRAPS/get-pip.py

# Install poetry
print-title 'Installing/updating poetry'
if cmd-exists poetry; then
    poetry self update
else
    python $BOOTSTRAPS/install-poetry.py --preview
    poetry config virtualenvs.path ~/.virtualenvs
    poetry config virtualenvs.create false
fi

# Install poetry shell completions
mkdir -p $(dirname $BASH_COMPLETE_DEST)
mkdir -p $(dirname $FISH_COMPLETE_DEST)
bash -c "poetry completions bash > $BASH_COMPLETE_DEST"
fish -c "poetry completions fish > $FISH_COMPLETE_DEST"

# Install miniconda
# print-title 'Installing/updating miniconda'
# if cmd-exists conda; then
#     conda update --yes conda conda-build python
# else
#     bash $BOOTSTRAPS/get-miniconda.sh -b -p ~/.miniconda
#     pathadd ~/.miniconda/bin
#     conda update --yes conda python
#     conda install -y conda-build
# fi

# Install some user-level packages
print-title 'Installing/updating user packages'
pip install --user -Ur requirements-user.txt
source $(which virtualenvwrapper.sh)

# Install or update some python CLI tools with pipx
if test -z $UPDATE_ONLY; then
    while read package; do
        pipx install $package
    done < requirements-pipx.txt
else
    pipx upgrade-all
fi


# Make virtualenv for neovim
if ! lsvirtualenv | grep -q nvim; then
    mkvirtualenv nvim
    pip install -U pip jedi pynvim vim-vint
    deactivate
fi

# Link packages to install for every new virtualenv
ln -s $(pwd)/requirements-virtualenvs.txt $VF_REQUIREMENTS
