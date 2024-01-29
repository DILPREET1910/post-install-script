#!/bin/bash

##########################################################
# check if root
##########################################################
if [ "$EUID" -ne 0 ]
then echo "Please runt as root"
    exit
fi

##########################################################
# check for distro type
##########################################################
if  grep -q "ID=arch" < /etc/os-release 
    then DISTRO="arch"
elif grep -q "ID=ubuntu" < /etc/os-release && grep -q "ID_LIKE=debian" < /etc/os-release
    then DISTRO="debian"
fi

##########################################################
# set installer
##########################################################
if [ "$DISTRO" = "arch" ]
     then INSTALLER="pacman -S "
elif [ "$DISTRO" = "debian" ]
    then INSTALLER="apt-get install "
fi

##########################################################
# git clone dotfile from github
##########################################################
CLONED_DIR=$(pwd .)
git clone https://github.com/dilpreet1910/dotfiles
cd dotfiles || exit


##########################################################
# yay installer for arch
##########################################################
if [ "$DISTRO" = "arch" ]
then 
    git clone https://aur.archlinux.org/yay.git
    mv yay /usr/bin/
    chown -R "$USER" /usr/bin/yay
fi

##########################################################
# starship
##########################################################
curl -sS https://starship.rs/install.sh | sh

##########################################################
# ZSH
##########################################################
# remove if .config/zsh already exists
rm -rf .config/zsh

# move the cloned zsh config files to .config
mv ./.config/zsh ~/.config/

# system link .zshrc file to home dir
ln -s ~/.config/zsh/.zshrc ~/.zshrc

# zsh history
mkdir ~/.cache/zsh
touch ~/.cache/zsh/history

# install autojump
if [ "$DISTRO" = "debian" ]
then 
    eval "$INSTALLER autojump"
elif [ "$DISTRO" = "arch" ]
    then
        yay install autojump
fi
