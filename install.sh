#!/bin/bash

for f in bash_profile bashrc bash_aliases emacs.d vimrc vim zshrc tmux.conf taskrc jrnl_config aliases.d
do
  echo "processing $f"
  rm -r ~/.$f
  ln -s ~/dotfiles/$f ~/.$f
done
