set ttimeoutlen=0  " Make <esc> more responsive
set number         " Line Numbers
set signcolumn=yes " Always have wide gutter
set autoindent

" Enable soft tabs of width 2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Auto install Plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'

" File Finding
Plug 'francoiscabrol/ranger.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'kshenoy/vim-signature' " Show marks in gutter

Plug 'luochen1990/rainbow' " Color my brackets
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense
Plug 'jiangmiao/auto-pairs' " Close my brackets for me
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Git
Plug 'airblade/vim-gitgutter' " Show diff symbols in gutter
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'rhysd/git-messenger.vim' "Show commit message with <Leader>gm

Plug 'easymotion/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pechorin/any-jump.nvim'

Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } " File browser
Plug 'let-def/ocp-indent-vim' " Ocaml OCP-indent

call plug#end()

" Set AirLine to OneDark
let g:airline_theme='onedark'

" Set Vim to OneDark
let g:onedark_color_overrides = {
\ "comment_grey": {"gui": "#808898", "cterm": "59", "cterm16": "15" },
\ "gutter_fg_grey": {"gui": "#79859e", "cterm": "59", "cterm16": "15" },
\ "black": { "gui": "#0b1118", "cterm": "170", "cterm16": "5" }
\}
colorscheme onedark

" Enable truecolors
set termguicolors

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

" Enable Vim Rainbow and set colors to OneDark
let g:rainbow_active = 1
let g:rainbow_conf = {'guifgs': ['#e5c07b', '#c678dd', '#56b6c2']}

" require the lua module
lua require("navigation")
" map the Terminal function in the lua module to some shortcuts
nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>

" Jump to definition under cursore
nnoremap <leader>j :AnyJump<CR>

" open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>

" open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>

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

