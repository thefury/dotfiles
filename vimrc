
" preferred tabbing
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smarttab
set nocompatible

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

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
