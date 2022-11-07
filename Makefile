####################################
# Grouped Packages: Cross-Platform #
####################################

install-portable-packages: \
    install-cargo-packages \
    install-fzf \
    install-grc \
    install-npm-packages \
    install-python-tools \
    install-ruby-gems

update: \
    update-cargo \
    update-npm \
    update-python \
    update-ruby \
    update-tldr
    # update-grc
    # update-vim


##############################################
# Grouped Pakcages & Config: Distro-Specific #
##############################################

install-fedora: \
    install-system-packages-fedora-gnome \
    install-portable-packages \
    install-ssh-agent-systemd
    # install-retroterm-fedora \
    # install-chrome-fedora \
    # install-vim-fedora

update-fedora: update
	sudo dnf upgrade -y

install-ubuntu: \
    install-system-packages-ubuntu \
    install-portable-packages \
    install-duplicati-ubuntu
    #install-chrome-ubuntu \
    #install-retroterm-ubuntu \
    #install-vim-ubuntu

install-ubuntu-wsl: \
    install-system-packages-ubuntu-wsl \
    install-portable-packages \
    init-ssh-conf \
    install-xfce-superkey \
	scripts/init_gnome_keyring.sh
	# See: https://github.com/dnschneid/crouton/wiki/Fix-error-while-loading-shared-libraries:-libQt5Core.so.5
	sudo strip --remove-section=.note.ABI-tag  /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
	# WIP: Set up host Firefox to allow opening browser from links in WSL
	# sudo update-alternatives --install "/bin/host_firefox" "firefox" '/mnt/c/Program Files/Mozilla Firefox/firefox.exe' 1

update-ubuntu: update
	sudo apt-get update && sudo apt-get upgrade -y

# Minimal config + packages for Raspberry Pi (headless)
install-rpi: install-python-tools
	scripts/rpi/install_system_packages.sh


#########################
# Runtime Configuration #
#########################

# WIP
init-ssh-conf:
	mkdir -p ~/.ssh
	cp ssh/config ~/.ssh/
	source ~/.bashrc && ssh-set-permissions

############################
# Packages: Cross-Platform #
############################

install-cargo-packages:
	scripts/install_cargo_packages.sh

install-fzf:
	scripts/git/install_fzf.sh

install-grc:
	scripts/git/install_grc.sh

install-npm-packages:
	scripts/install_npm_packages.sh

install-poetry:
	scripts/install_poetry.sh

install-pyenv:
	scripts/install_pyenv.sh

install-python-tools:
	scripts/install_python_tools.sh

install-ruby-gems:
	sudo gem install -g scripts/Gemfile

install-ssh-agent-systemd:
	scripts/install_ssh_agent_systemd.sh

install-vim:
	scripts/git/install_vim.sh

install-xfce-superkey:
	scripts/git/install_xfce_superkey.sh


# Updates
# -------

update-cargo: install-cargo-packages

update-grc: install-grc

update-npm: install-npm-packages

update-python:
	scripts/install_python_tools.sh -u

update-ruby:
	sudo gem update

update-tldr:
	- tldr --update

update-vim:
	scripts/install_vim.sh

update-git-repos:
	scripts/git/install_fzf.sh
	scripts/git/install_grc.sh
	scripts/git/install_retroterm.sh
	scripts/git/install_vim.sh
	scripts/git/install_xfce_superkey.sh


####################
# Packages: Fedora #
####################

install-system-packages-fedora-gnome:
	sudo scripts/fedora/install_system_packages.sh -r -g -n

install-system-packages-fedora-xfce:
	sudo scripts/fedora/install_system_packages.sh -r -g -x

install-system-packages-fedora-headless:
	sudo scripts/fedora/install_system_packages.sh -r

reinstall-system-packages-fedora:
	sudo scripts/fedora/install_system_packages.sh

install-vim-fedora:
	scripts/fedora/install_vim_prereqs.sh
	scripts/install_vim.sh

install-chrome-fedora:
	sudo scripts/fedora/install_chrome.sh

install-retroterm-fedora:
	scripts/fedora/install_retroterm_prereqs.sh
	scripts/git/install_retroterm.sh


#####################
# Packages: Ubuntu #
#####################

install-system-packages-ubuntu:
	sudo scripts/ubuntu/install_system_packages.sh -r -g

install-system-packages-ubuntu-wsl:
	sudo scripts/ubuntu/install_system_packages.sh -r -w

reinstall-system-packages-ubuntu:
	sudo scripts/ubuntu/install_system_packages.sh

install-vim-ubuntu:
	scripts/ubuntu/install_vim_prereqs.sh
	scripts/install_vim.sh
	scripts/install_vim_plug.sh

install-chrome-ubuntu:
	sudo scripts/ubuntu/install_chrome.sh

install-duplicati-ubuntu:
	scripts/ubuntu/install_duplicati.sh

install-retroterm-ubuntu:
	scripts/ubuntu/install_retroterm_prereqs.sh
	scripts/git/install_retroterm.sh
