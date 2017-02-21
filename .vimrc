"--- Commands ---
command Fix !eslint % --fix

"--- Plugins ---
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
Plug 'valloric/youcompleteme'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'mattn/emmet-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-commentary'
Plug 'unblevable/quick-scope'
Plug 'mxw/vim-jsx'
call plug#end()

"--- Syntastic Settings ---
set statusline=%<%F%h%m%r%h%w%=\ lin:%l\,%L\ col:%c%V
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_ruby_checkers = ['rubocop']

"--- Lets & Sets ---
set nocompatible
set hlsearch
set showtabline=2
set tabstop=2
set shiftwidth=2
set expandtab
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*
set rnu
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$|node_modules'
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix\|NERDTree'
let g:ctrlp_show_hidden = 1
let g:ctrlsf_ackprg = 'ag'
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:99'
let g:ycm_filetype_blacklist = { 'ctrlsf': 1 }
filetype plugin indent on
colorscheme angr

"--- AutoCmds ---
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

"--- Maps ---
map <Space> :noh<CR>:NERDTreeClose<CR>:lclose<CR>
map <C-\> :NERDTreeFind<CR>
map <C-T> :CtrlP .<CR>
map <C-_> :tabclose<CR>
map ∆ 4j
map ˚ 4k
nmap + :tabn<CR>
nmap _ :tabp<CR>
nmap \ :tabedit
nmap <C-f> <Plug>CtrlSFPrompt
vmap <C-f> <Plug>CtrlSFVwordPath
