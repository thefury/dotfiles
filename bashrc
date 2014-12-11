#!/bin/bash

# my standard setup stuff
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export EDITOR=vim
export PATH="$HOME/bin:$PATH"

. ~/.bin/tmuxinator.bash

# personal bin
export PATH="$HOME/bin:$PATH"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
