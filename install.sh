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
git clone https://github.com/dilpreet1910/dotfiles

##########################################################
# ZSH
##########################################################
# remove if .config/zsh already exists
rm -rf .config/zsh

# move the cloned zsh config files to .config
mv ./dotfiles/.config/zsh ~/.config/

# system link .zshrc file to home dir
ln -s ~/.config/zsh/.zshrc ~/.zshrc
