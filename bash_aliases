#!/usr/bin/env bash

# Aliases
alias dce='docker-compose exec'
alias reload='source ~/.zshrc'
alias ll='ls -la'
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
alias j='jrnl'
alias t='task'
alias tt='task +TODAY'
alias hist="history | cut -c 8-"
alias myip="curl icanhazip.com"
alias myips="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias wgetdir='wget -r -l1 -P035 -nd --no-parent'
alias mirror="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent"
alias f1="awk '{print \$1}'"
alias f2="awk '{print \$2}'"
alias ts="tmux list-ssesions"
alias emacs="/usr/local/bin/emacs"
alias timestamp=$(date +%s)
alias stripcolors="sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'"
alias tmux="tmux -2"
alias j='jrnl'
alias t='task'
alias tv="terminal_velocity $HOME/Nextcloud/workflow/notes"

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

#=============================================
# Git functions
#=============================================

wip() {
  git add .
  git commit -m "wip: $1"
}

delmerged () {  
  git checkout master
  git branch --merged | grep -v '* ' | xargs git branch -D 
}

#=============================================
# Workflow Functions
#=============================================
WORKFLOW_DIR="$HOME/Nextcloud/workflow"
projects() {
  local proj=$(python3 ~/bin/projects_without_next_action.py)

  if [ "$proj" != "" ]
  then
    echo "Attention: The following projects don't currently have a next action:\n"
    echo $proj
    echo
  fi
}

waiting() {
  local waiting_cnt=$(task +waiting +PENDING count)

  if [ "$waiting_cnt" != 0 ]
  then
    echo "Any progress on these waiting for items?"
    task +waiting +PENDING ls
  fi
}

today() {
  projects
  waiting
  task +TODAY
}

review() {
  echo "Daily Review"
  echo "======================="
  task end.after:today completed
  echo
  echo "Journal"
  echo "======================="
  jrnl -from today 
}

note() {
  local id="$1"
  local dir="$WORKFLOW_DIR/projects"
  local file="$dir/$id.md"

  mkdir -p $dir
  $EDITOR $file
}

