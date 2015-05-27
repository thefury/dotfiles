
" preferred tabbing
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smarttab
set nocompatible

set relativenumber

" big line for 80 characters
set textwidth=80
set colorcolumn=+1

" pathogen for plugins
execute pathogen#infect()
syntax enable
filetype plugin indent on

" remove trailing whitespace on save for ruby files
autocmd BufWritePre *.rb :%s/\s\+$//e

" I prefer this list style
let g:netrw_liststyle=3

" delete key not working on mac
set backspace=indent,eol,start

" vim/slime
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_target = "tmux"

" tags
set tags=./tags;/
" slime
let g:slime_target='tmux'

" markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
