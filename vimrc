
" preferred tabbing
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smarttab
set nocompatible

set number

" big line for 80 characters
" set textwidth=80
" set colorcolumn=+1


call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-endwise'
Plug 'bling/vim-airline'
Plug 'fatih/vim-go'
Plug 'vim-ruby/vim-ruby'
Plug 'chase/vim-ansible-yaml'
Plug 'stephpy/vim-yaml'
Plug 'tpope/vim-markdown'
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'
Plug 'tpope/vim-surround'
call plug#end()

" visual style
syntax on
filetype plugin indent on

" remove trailing whitespace on save for ruby files
autocmd BufWritePre *.rb :%s/\s\+$//e

" I prefer this list style
let g:netrw_liststyle=3

" VimWiki
let wiki_kc = {}
let wiki_kc.path = '~/Nextcloud/workflow/wiki/'
let wiki_kc.path_html = '~/Nextcloud/workflow/wiki_html'
let g:vimwiki_list = [wiki_kc]

" delete key not working on mac
set backspace=indent,eol,start

" vim/slime
"let g:slime_paste_file = "$HOME/.slime_paste"
"let g:slime_target = "tmux"

" tags
"set tags=./tags;/
" slime
"let g:slime_target='tmux'

" markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufRead *.dump set filetype=sql
autocmd BufNewFile,BufRead *.pill set filetype=ruby
autocmd BufNewFile,BufRead Gemfile set filetype=ruby

" CtrlP
"set runtimepath^=~/.vim/bundle/ctrlp.vim

" tmux integration
" re-run last command in top right pane of window 0
nmap \r :!tmux send-keys -t 0:0.1 C-p C-j <CR><CR>

" Prose Mode
function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  colors solarized
endfunction

command! ProseMode call ProseMode()
nmap \p :ProseMode<CR>
