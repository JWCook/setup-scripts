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
	./init_gnome_keyring.sh
	# See: https://github.com/dnschneid/crouton/wiki/Fix-error-while-loading-shared-libraries:-libQt5Core.so.5
	sudo strip --remove-section=.note.ABI-tag  /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
	# WIP: Set up host Firefox to allow opening browser from links in WSL
	# sudo update-alternatives --install "/bin/host_firefox" "firefox" '/mnt/c/Program Files/Mozilla Firefox/firefox.exe' 1

update-ubuntu: update
	sudo apt-get update && sudo apt-get upgrade -y

# Minimal config + packages for Raspberry Pi (headless)
install-rpi: install-python-tools
	./rpi/install_system_packages.sh


#########################
# Runtime Configuration #
#########################

# WIP
init-ssh-conf:
	mkdir -p ~/.ssh
	cp ssh/config ~/.ssh/
	source ~/dotfiles/bash/bashrc && ssh-set-permissions

############################
# Packages: Cross-Platform #
############################

install-cargo-packages:
	./install_cargo_packages.sh

install-fzf:
	./git/install_fzf.sh

install-grc:
	./git/install_grc.sh

install-npm-packages:
	./install_npm_packages.sh

install-poetry:
	./install_poetry.sh

install-pyenv:
	./install_pyenv.sh

install-python-tools:
	./install_python_tools.sh

install-ruby-gems:
	sudo gem install -g ./Gemfile

install-ssh-agent-systemd:
	./install_ssh_agent_systemd.sh

install-vim:
	./git/install_vim.sh

install-xfce-superkey:
	./git/install_xfce_superkey.sh


# Updates
# -------

update-cargo: install-cargo-packages

update-grc: install-grc

update-npm: install-npm-packages

update-python:
	./install_python_tools.sh -u

update-ruby:
	sudo gem update

update-tldr:
	- tldr --update

update-vim:
	./install_vim.sh

update-git-repos:
	./git/install_fzf.sh
	./git/install_grc.sh
	./git/install_retroterm.sh
	./git/install_vim.sh
	./git/install_xfce_superkey.sh


####################
# Packages: Fedora #
####################

install-system-packages-fedora-gnome:
	sudo ./fedora/install_system_packages.sh -r -g -n

install-system-packages-fedora-xfce:
	sudo ./fedora/install_system_packages.sh -r -g -x

install-system-packages-fedora-headless:
	sudo ./fedora/install_system_packages.sh -r

reinstall-system-packages-fedora:
	sudo ./fedora/install_system_packages.sh

install-vim-fedora:
	./fedora/install_vim_prereqs.sh
	./install_vim.sh

install-chrome-fedora:
	sudo ./fedora/install_chrome.sh

install-retroterm-fedora:
	./fedora/install_retroterm_prereqs.sh
	./git/install_retroterm.sh


#####################
# Packages: Ubuntu #
#####################

install-system-packages-ubuntu:
	sudo ./ubuntu/install_system_packages.sh -r -g

install-system-packages-ubuntu-wsl:
	sudo ./ubuntu/install_system_packages.sh -r -w

reinstall-system-packages-ubuntu:
	sudo ./ubuntu/install_system_packages.sh

install-vim-ubuntu:
	./ubuntu/install_vim_prereqs.sh
	./install_vim.sh
	./install_vim_plug.sh

install-chrome-ubuntu:
	sudo ./ubuntu/install_chrome.sh

install-duplicati-ubuntu:
	./ubuntu/install_duplicati.sh

install-retroterm-ubuntu:
	./ubuntu/install_retroterm_prereqs.sh
	./git/install_retroterm.sh
