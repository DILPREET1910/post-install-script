#!/bin/bash

# check if root
if [ "$EUID" -ne 0 ]
then echo "Please runt as root"
    exit
fi

#############################
# ZSH
#############################
# remove if .config/zsh already exists
rm -rf .config/zsh

# move the cloned zsh config files to .config
mv ./dotfiles/.config/zsh ~/.config/

# system link .zshrc file to home dir
ln -s ~/.config/zsh/.zshrc ~/.zshrc
