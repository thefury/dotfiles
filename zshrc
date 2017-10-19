# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ruby rails bundler)

# User configuration
export EDITOR=vim
export VISUAL=vim

# History control.
SAVEHIST=100000
HISTSIZE=100000
if [ -e ~/priv/ ]; then
  HISTFILE=~/priv/zsh_history
elif [ -e ~/secure/ ]; then
  HISTFILE=~/secure/zsh_history
else
  HISTFILE=~/.zsh_history
fi
if [ -n "$HISTFILE" -a ! -w $HISTFILE ]; then
  echo
  echo "[31;1m HISTFILE [$HISTFILE] not writable! [0m"
  echo
fi

# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh

# updates to PATH
_prepend_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

_append_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
_prepend_to_path /usr/local/sbin
_prepend_to_path /usr/local/bin
_prepend_to_path ~/bin
_prepend_to_path /Applications/Postgres.app/Contents/Versions/latest/bin


# Java
export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# Go
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec

_append_to_path $GOPATH/bin
_append_to_path $GOROOT/bin

_prepend_to_path $HOME/.rbenv/bin
eval "$(rbenv init -)"

# Aliases
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
alias hist="history | cut -c 8-"
alias myip="curl icanhazip.com"
alias myips="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias wgetdir='wget -r -l1 -P035 -nd --no-parent'
alias mirror="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent"
alias f1="awk '{print \$1}'"
alias f2="awk '{print \$2}'"

# pecohist show your command history and let you grep them, then copy your selection to your clipboard
func pecohist() {
  cmd=$(hist | peco | tr -d '\n')
  $(echo $cmd | pbcopy)
  echo $cmd
}
# Quick commands to sync CWD between terminals.
pin() {
  rm -f ~/.pindir
  echo $PWD >~/.pindir
  chmod 0600 ~/.pindir >/dev/null 2>&1
}
pout() {
  cd `cat ~/.pindir`
}

# Make a new command.
vix() {
  if [ -z "$1" ]; then
    echo "usage: $0 <newfilename>"
    return 1
  fi
  touch $1
  chmod -v 0755 $1
  $EDITOR $1
}

# Make a new command in ~/bin
makecommand() {
  if [ -z "$1" ]; then
    echo "Gotta specify a command name, champ" >&2
    return 1
  fi

  mkdir -p ~/bin
  local cmd=~/bin/$1
  if [ -e $cmd ]; then
    echo "Command $1 already exists" >&2
  else
    echo "#!${2:-/bin/sh}" >$cmd
  fi

  vix $cmd
}
