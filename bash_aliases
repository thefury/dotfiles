#!/bin/sh

alias reload='source ~/.zshrc'

alias ll='ls -la'
alias df='df -h'
alias d='du -Ah'

alias gc='git commit'
alias ga='git add'
alias gco='git checkout'
alias gb='git branch'
alias gst='git status'
alias gup='git pull --rebase'
alias gpoh='git push origin HEAD'
alias gprune='gco master && git branch --merged | grep -v "\\*\\|master\\|develop" | xargs -n 1 git branch -d'
alias gclean="gco master && git branch -r --merged | grep origin | grep -v '>' | grep -v master | xargs -L1 | awk '{split($0,a,"/"); print a[2]}'"
alias grh='git reset HEAD --hard'

alias tn='tmux new-session -s'
alias ta='tmux attach-session -t'
alias tk='tmux kill-session -s'
alias tl='tmux list-sessions'

alias ppjson='python -m json.tool'

function wip() {
  git add . && git commit -m "wip: $1"
}

function brc() {
  vim $1
  source $1
}

func env4pid() {
  xargs --null --max-args=1 < /proc/$1/environ
}


alias t='/usr/local/Cellar/todo-txt/2.10/bin/todo.sh'
alias tw='t lsp @work'
alias tdir='cd $HOME/ownCloud/todo'
alias i='t addto inbox.txt'
alias j='jrnl'

func despace() {
  mv "$1" `echo $1 | tr ' ' '-'`
}

func log_question()
{
  echo $1
  read
  jrnl today: ${1}. $REPLY
}

func log_question() {
  echo $1
  read
  jrnl today: ${1} @microjournal. $REPLY
}

# pecohist show your command history and let you grep them, then copy your selection to your clipboard
alias hist="history | cut -c 8-"
func pecohist() {
  cmd=$(hist | peco | tr -d '\n')
  $(echo $cmd | pbcopy)
  echo $cmd
}

alias myip="curl icanhazip.com"
alias myips="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias c='clear;pwd'
#alias afk="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias cx="chmod +x"
alias kb="$EDITOR ~/Library/KeyBindings/DefaultKeyBinding.dict"

alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

alias svim='sudo vim'
