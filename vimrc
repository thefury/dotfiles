
" preferred tabbing
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smarttab

" pathogen for plugins
execute pathogen#infect()
syntax enable
filetype plugin indent on

" remove trailing whitespace on save for ruby files
autocmd BufWritePre *.rb :%s/\s\+$//e

" I prefer this list style
let g:netrw_liststyle=3
