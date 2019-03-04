#!/bin/bash

bash_profile bashrc       install.sh   jrnl_config  taskrc       tmux.conf    vim          vimrc        zshrc

for f in bash_profile bashrc bash_aliases vimrc vim zshrc tmux.conf taskrc jrnl_config
do
  echo "processing $f"
  rm -r ~/.$f
  ln -s ~/dotfiles/$f ~/.$f
done
