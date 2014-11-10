#!/bin/bash


for f in bashrc bash_profile bash_aliases vimrc
do
  echo "processing $f"
  rm ~/.$f
  ln -s ~/dotfiles/$f ~/.$f
done

