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
Plug 'drewtempelmeyer/palenight.vim'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'

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

" FZF {{{
let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(&lines * 0.6) " 60% of screen
  let width = float2nr(&columns * 0.8) " 80% of screen
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = float2nr(&lines * 0.1) " space to top: 10%

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'anchor': 'NW',
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction
" }}}

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
