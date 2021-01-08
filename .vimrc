" stanard stuff
set hlsearch
set ignorecase
set incsearch
set noswapfile
set number

nmap <F12> :set invnumber<CR>

" preferred tabbing
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smarttab
set nocompatible


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
Plug 'hashivim/vim-terraform'
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'michal-h21/vim-zettel'
Plug 'mattn/calendar-vim'
Plug 'tpope/vim-surround'

" for taskpaper stuff
Plug 'davidoc/taskpaper.vim'
Plug 'vim-scripts/vim-auto-save'
Plug 'djoshea/vim-autoread'

call plug#end()

" visual style
syntax on
filetype plugin indent on

" remove trailing whitespace on save for ruby files
autocmd BufWritePre *.rb :%s/\s\+$//e

" I prefer this list style
let g:netrw_liststyle=3

" VimWiki
" use \ws to switch between wikis

let vimwiki_path='~/Nextcloud/wiki/'
let vimwiki_export_path='~/Nextcloud/wiki_html/'
"'template_path': vimwiki_export_path.'templates/',
"'template_default': 'default',
"'template_ext': '.html',
let wiki_settings={
  \ 'auto_export': 0,
  \ 'nested_syntaxes': {
  \ 'js':'javascript',
  \ 'rb':'ruby',
  \ 'go':'go',
  \ 'sh':'sh'
  \ }}

let g:vimwiki_list = []

" Zettel needs to be first for fzf to work correctly
let wikis=["personal", "workyard", "traveller"]
for wiki_name in wikis
	let wiki=copy(wiki_settings)
	let wiki.path = vimwiki_path.wiki_name.'/'
	let wiki.path_html = vimwiki_export_path.wiki_name.'/'
	let wiki.diary_index = 'index'
	let wiki.diary_rel_path = 'diary/'
  let wiki.syntax = 'markdown'
  let wiki.ext = '.md'
	call add(g:vimwiki_list, wiki)
endfor

au BufRead,BufNewFile *.wiki,*.md set wrap linebreak nolist textwidth=85 wrapmargin=0

"let wiki_1 = {}
"let wiki_1.path = '~/Nextcloud/wiki/'
"let wiki_1.path_html = '~/Nextcloud/wiki_html'
"let wiki_2 = {}
"let wiki_2.path = '~/Nextcloud/zettel_wiki/'
"let wiki_2.path_html = '~/Nextcloud/zettel_wiki_html'
"let g:vimwiki_list = [wiki_1, wiki_2]

" Zettel Stuff
let g:zettel_format = "%file_no"
let g:zettel_options = [{"template" :  "~/Nextcloud/zettel_wiki/zettel-template.tpl"}]

nnoremap <leader>vt :VimwikiSearchTags<space>
nnoremap <leader>vs :VimwikiSearch<space>
nnoremap <leader>gt :VimwikiRebuildTags!<cr>:ZettelGenerateTags<cr><c-1>
nnoremap <leader>bl :VimwikiBacklinks<cr>

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

nmap <F4> i<C-R>=strftime("%Y-%m-%d %H:%M %p")<CR><Esc>
imap <F4> <C-R>=strftime("%Y-%m-%d %H:%M %p")<CR>
nmap <F3> i<C-R>=strftime("%H:%M %p")<CR><Esc>
imap <F3> <C-R>=strftime("%H:%M %p")<CR>
nmap <F2> i<C-R>=strftime("%Y-%m-%d %a")<CR><Esc>
imap <F2> <C-R>=strftime("%Y-%m-%d %a")<CR>

" Autosave taskpaper files                    
autocmd filetype taskpaper let g:auto_save = 1
autocmd filetype taskpaper :WatchForChanges!  
