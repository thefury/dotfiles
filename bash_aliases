#!/usr/bin/env bash

ALIASES_DIR=$HOME/.aliases.d

for i in $ALIASES_DIR/*; do 
  if [[ -f "$i" ]]; then
    source "$i"
  fi
done

# Aliases
alias em='emacsclient -nw ${@}'
alias dce='docker-compose exec'
alias reload='source ~/.zshrc'
alias ll='ls -la'

alias hist="history | cut -c 8-"
alias myip="curl icanhazip.com"
alias myips="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias mirror="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent"
alias timestamp=$(date +%s)
alias stripcolors="sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'"
alias tmux="tmux -2"
alias j='jrnl'
alias org="emacs ~/Nextcloud/workflow/notes/index.org"

alias tn="task context none"

alias utc='date -u'

#=============================================
# Movement Functions
#=============================================

pin() {
  rm -f ~/.pindir
  echo $PWD >~/.pindir
  chmod 0600 ~/.pindir >/dev/null 2>&1
}

pout() {
  cd `cat ~/.pindir`
}


update() {
  pushd $HOME/dotfiles

  git stash
  git pull --rebase
  git stash pop

  $HOME/dotfiles/install.sh
  source $HOME/.zshrc

  popd
}

upgrade() {
  brew update
  brew upgrade
  brew cleanup -s
  brew cask cleanup
  #now diagnotic
  brew doctor
  brew missing
}

trello() {
  echo "$@" | mail -s "$@" trevoroke+iwxuplrxhp8afuo37qh5@boards.trello.com < /dev/null
  echo "task added"
}

note() {
  echo "- $@" > ~/Nextcloud/Notes/00-inbox.md
  echo "note added"
}
