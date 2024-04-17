#!/bin/bash

##########################################################
# check if root
##########################################################
if [ "$EUID" = 0 ]
then echo "Please do not run as root"
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
     then INSTALLER="sudo pacman -S "
elif [ "$DISTRO" = "debian" ]
    then INSTALLER="sudo apt-get install "
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
    sudo mv yay /usr/bin/
    sudo chown -R "$USER" /usr/bin/yay
fi

##########################################################
# snap installer for debian
##########################################################
if [ "$DISTRO" = "debian" ]
then 
    eval "$INSTALLER snap"
fi

##########################################################
# starship
##########################################################
curl -sS https://starship.rs/install.sh | sh

##########################################################
# ZSH
##########################################################
eval "$INSTALLER zsh"

# remove if .config/zsh already exists
rm -rf ~/.config/zsh

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

##########################################################
# NeoVim
##########################################################
if [ "$DISTRO" = "arch" ]
then
    eval "$INSTALLER neovim"
elif [ "$DISTRO" = "debian" ]
then 
    sudo snap install nvim --classic
fi

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# remove if .config/nvim already exists
rm -rf ~/.config/nvim

# move the cloned nvim config files to .confg
mv ./.config/nvim ~/.config/

# source packer
nvim -c ":luafile ~/.config/nvim/dilpreet/packer.lua" -c ":PackerSync" -c ":qall"
