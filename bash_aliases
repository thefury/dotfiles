alias ll='ls -la'

alias bi='bundle install'
alias be='bundle exec'

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

alias tma='tmux attach-session -t'
alias tmk='tmux kill-session'
alias tml='tmux list-sessions'

alias rk='be rake'
alias rc='be rails console'
alias rd='be rails dbconsole -p'

alias ppjson='python -m json.tool'
alias tag='ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)'

alias today="grep '#today' ~/Dropbox/exocortex.md"
alias current="grep '#current' ~/Dropbox/exocortex.md"
alias todo='cat ~/Dropbox/exocortex.md'

function wip() {
  git add . && git commit -m "wip: $1"
}

function brc() {
  vim $1
  source $1
}

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
