#!/bin/bash

# my standard setup stuff
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export EDITOR=vim
export PATH="$HOME/bin:$PATH"

# personal bin
export PATH="$HOME/bin:$PATH"

export HOMEBREW_GITHUB_API_TOKEN="f8a78c30b2da63985c4f440dd884ae9b2d1f6ccb"

export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$HOME/kinetic/bin

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

complete -C aws_completer aws
