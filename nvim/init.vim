" ##############################
" ## Basic Vim Settings
" ##############################

set ttimeoutlen=0  " Make <esc> more responsive
set number         " Line Numbers
set signcolumn=yes " Always have wide gutter
set autoindent

" Enable soft tabs of width 2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" ##############################
" Auto install Plug
" ##############################

" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ##############################
" ## Plugins
" ##############################

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
Plug 'maxbrunsfeld/vim-yankstack'

" File Finding
" Plug 'francoiscabrol/ranger.vim'
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'kshenoy/vim-signature' " Show marks in gutter
Plug 'mbbill/undotree'

Plug 'luochen1990/rainbow' " Color my brackets
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense
" More intelligent and lower false positive rate than the standard autopairs plugin
Plug 'Krasjet/auto.pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'

" Git
Plug 'airblade/vim-gitgutter' " Show diff symbols in gutter
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim' "Show commit message with <Leader>gm

Plug 'easymotion/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pechorin/any-jump.nvim'

Plug 'let-def/ocp-indent-vim' " Ocaml OCP-indent

call plug#end()

" ##############################
" ## Configure Airline
" ##############################

let g:airline#extensions#tabline#enabled = 1

let g:airline_theme='palenight'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_z = "%p%% %l/%L %c"
" Only show unusual encodings
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'

" Redefine some ugly symbols
" (Must include complete dict to hot reload config)
let g:airline_symbols = {
  \   'space': ' ',
  \   'paste': 'PASTE',
  \   'spell': 'SPELL',
  \   'notexists': 'Ɇ',
  \   'maxlinenr': ' ',
  \   'linenr': '☰ ',
  \   'readonly': '',
  \   'dirty': ' ⚡',
  \   'modified': '+',
  \   'crypt': '🔒',
  \   'keymap':   'Keymap:',
  \   'ellipsis': '...',
  \   'branch': '',
  \   'whitespace': '☲'
  \ }

" ##############################
" ## Colors & Appearance
" ##############################
let g:palenight_color_overrides = {
\ "black": { "gui": "#0b1118", "cterm": "170", "cterm16": "5" },
\}

colorscheme palenight
set termguicolors
set pumblend=10

" Enable Vim Rainbow and set colors
let g:rainbow_active = 1
let g:rainbow_conf = {'guifgs': ['#ffc485', '#c792ea', '#89ddff']}

" Recolor Coc Error popups
hi Pmenu guibg=#272b39
hi CocErrorSign guifg=#ff8b92

" Shorten update time from 4000 to 100 (for gitgutter)
set updatetime=100

" Enable Ctrl-P for fzf
nnoremap <C-p> :Files<Cr>

" Easymotion config
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-s2)
map  / <Plug>(easymotion-sn)

" Color vim signature marks with GitGutter
let g:SignatureMarkTextHLDynamic=1
let g:SignatureMarkerTextHLDynamic=1
let g:SignaturePeriodicRefresh=1
" Set default mark color to something tolerable
hi SignatureMarkText guifg=PeachPuff2

" Opam Initialization
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" OCP Indent
set rtp^="/Users/ryan/.opam/default/share/ocp-indent/vim"
autocmd FileType ocaml set indentexpr=ocpindent#OcpIndentLine()
autocmd BufWritePre *.ml :normal gg=G

" Use tab for autocompletion with Coc
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" FZF {{{
let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': 'call FloatTerm("fzf")' }

" ##############################
" ## Startify
" ##############################

let g:ascii = [
      \ '  .M"""bgd `7MMF"            db      `7MMM.     ,MMF"      db',
      \ ' ,MI    "Y   MM             ;MM:       MMMb    dPMM       ;MM:',
      \ ' `MMb.       MM            ,V^MM.      M YM   ,M MM      ,V^MM.',
      \ '   `YMMNq.   MM           ,M  `MM      M  Mb  M" MM     ,M  `MM',
      \ ' .     `MM   MM      ,    AbmmmqMA     M  YM.P"  MM     AbmmmqMA',
      \ ' Mb     dM   MM     ,M   A"     VML    M  `YM"   MM    A"     VML',
      \ ' P"Ybmmd"  .JMMmmmmMMM .AMA.   .AMMA..JML. `"  .JMML..AMA.   .AMMA.',
\ ]

let g:startify_custom_header =
  \ [''] +
  \ startify#center(g:ascii) +
  \ [''] +
  \ startify#center(startify#fortune#boxed())

" ##############################
" ## Functions
" ##############################

runtime float.vim

" ##############################
" ## Normal Key Maps
" ##############################

" Set 's' to 'd' except without storing in a buffer
nnoremap s "_d
nnoremap S "_D
nnoremap ss "_dd

" Simplify Window Navigation
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Swap H with ^ and L with $
noremap ^ H
noremap $ L
noremap H ^
noremap L $

" ##############################
" ## <Leader> Commands
" ##############################

nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
let localmapleader = "\<CR>"

" Yankstack (paste through time)
call yankstack#setup()
nmap Y y$
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
" Paste from system clipboard
nmap <leader><leader>p "*p
nmap <leader><leader>P "*P

" Panel toggles
nnoremap <Leader>tb :Tagbar<CR>
nnoremap <Leader>tu :UndotreeToggle<cr>

" AnyJump
" Jump to definition under cursor
nnoremap <leader>j :AnyJump<CR>
" open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>
" open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>

" Open Floating Windows
nnoremap <Leader>at :call FloatTerm()<CR>
nnoremap <Leader>ag :call FloatTerm('lazygit')<CR>
nnoremap <Leader>ai :call FloatTerm('tig')<CR>
nnoremap <Leader>ar :call FloatTerm('ranger')<CR>
nnoremap <Leader>as :call FloatTerm('spt')<CR>
nnoremap <Leader>af :call FloatTerm('lf')<CR>

" Vim manipulation
nnoremap <Leader><Leader>r :so $MYVIMRC<CR>
nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>c :PlugClean<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader><Leader>q :q!<CR>
nnoremap <Leader>Q :qa<CR>
nnoremap <Leader><Leader>Q :qa!<CR>
nnoremap <Leader>x :x<CR>
nnoremap <Leader>h :Noh<CR>

" Run the current line as if it were a command.
" Often more convenient than q: when experimenting.
nnoremap <leader>e :exe getline(line('.'))<cr>

" Split windows
nnoremap <Leader>l :vsplit<CR>
nnoremap <Leader>k :split<CR>

" Buffer
nnoremap <Leader>tn :tabn<CR>
nnoremap <Leader>tp :tabp<CR>
nnoremap <Leader>tc :tabe<CR>
nnoremap <Leader>tx :tabclose<CR>

" Git
" <Leader>gm shows a popup with the commit for a given line
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gs :Gstatus<CR>

