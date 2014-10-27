#!/bin/bash

# my standard setup stuff
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export EDITOR=vim

. ~/.bin/tmuxinator.bash

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
