#!/bin/bash


for f in bashrc bash_profile bash_aliases
do
  echo "processing $f"
  rm ~/.$f
  ln -s ~/dotfiles/$f ~/.$f
done
#ln -s ~/dotfiles/bashrc ~/.bashrc
#ln -s ~/dotfiles/bash_profile ~/.bash_profile
#ln -s ~/dotfiles/bash_aliases ~/.bash_aliases

