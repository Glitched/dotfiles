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
" ## Colors
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

" require the lua module
lua require("navigation")
" map the Terminal function in the lua module to some shortcuts
nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>

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
" Floating Windows
" ##############################

hi Floating guibg=#272b39
let s:float_term_border_win = 0
let s:float_term_win = 0
function! FloatTerm(...)

  let height = float2nr((&lines - 2) * 0.8)
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.8)
  let col = float2nr((&columns - width) / 2)
  " Border Window
  let border_opts = {
        \ 'relative': 'editor',
        \ 'row': row - 1,
        \ 'col': col - 2,
        \ 'width': width + 4,
        \ 'height': height + 2,
        \ 'style': 'minimal'
        \ }
  " Terminal Window
  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  let bbuf = nvim_create_buf(v:false, v:true)
  let s:float_term_border_win = nvim_open_win(bbuf, v:true, border_opts)
  let buf = nvim_create_buf(v:false, v:true)
  let s:float_term_win = nvim_open_win(buf, v:true, opts)
  " Styling (Give the window a background color)
  call setwinvar(s:float_term_border_win, '&winhl', 'Normal:Floating')
  call setwinvar(s:float_term_win, '&winhl', 'Normal:Floating')

  if a:0 == 0
    terminal
  " Do nothing for fzf so plugin an take effect
  elseif a:1 != 'fzf'
    call termopen(a:1)
  endif
  startinsert
  " Close border window when terminal window close
  autocmd TermClose * ++once :bd! | call nvim_win_close(s:float_term_border_win, v:true)
endfunction

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

" IDE Features (Tags & Files)
nnoremap <Leader>de :Tagbar<CR> :Defx -split=vertical -winwidth=30 -direction=topleft<CR>
nnoremap <Leader>tb :Tagbar<CR>
nnoremap <Leader>dx :Defx -split=vertical -winwidth=30 -direction=topleft<CR>

" AnyJump
" Jump to definition under cursor
nnoremap <leader>j :AnyJump<CR>
" open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>
" open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>

" Open Floating Windows
nnoremap <Leader>at :call FloatTerm()<CR>
nnoremap <Leader>ag :call FloatTerm('"lazygit"')<CR>
nnoremap <Leader>ai :call FloatTerm('"tig"')<CR>
nnoremap <Leader>ar :call FloatTerm('"ranger"')<CR>
nnoremap <Leader>as :call FloatTerm('"spt"')<CR>

" Vim manipulation
nnoremap <Leader><Leader>r :so $MYVIMRC<CR>
nnoremap <Leader>w :w<CR>

" Split windows
nnoremap <Leader>l :vsplit<CR>
nnoremap <Leader>k :split<CR>

" Buffer
nnoremap <Leader>tn :tabn<CR>
nnoremap <Leader>tp :tabp<CR>
nnoremap <Leader>tc :tabe<CR>
nnoremap <Leader>tx :tabclose<CR>

