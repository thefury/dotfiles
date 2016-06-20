#!/bin/bash


for f in bashrc bash_profile bash_aliases vimrc vim emacs zshrc tmux.conf
do
  echo "processing $f"
  rm -r ~/.$f
  ln -s ~/dotfiles/$f ~/.$f
done

