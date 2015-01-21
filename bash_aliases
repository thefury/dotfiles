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

alias tma='tmux attach-session -t'
alias tmk='tmux kill-session'
alias tml='tmux list-sessions'

alias rk='be rake'
alias rc='be rails console'
alias rd='be rails dbconsole -p'

function wip() {
  git add . && git commit -m "wip: $1"
}

function brc() {
  vim $1
  source $1
}
