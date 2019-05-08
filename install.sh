#!/bin/bash

for f in bash_profile bashrc bash_aliases vimrc vim zshrc tmux.conf taskrc jrnl_config aliases.d spacemacs
do
  echo "processing $f"
  rm -r ~/.$f
  ln -s ~/dotfiles/$f ~/.$f
done
