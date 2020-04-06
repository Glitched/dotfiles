" Basic Vim Settings {{{

set background=dark
set grepprg=rg\ --vimgrep               " rg is faster

set ttimeoutlen=0                       " Make <esc> more responsive
set number                              " Line Numbers
set signcolumn=yes                      " Always have wide gutter
set autoindent

" Enable soft tabs of width 2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set foldmethod=marker                   " Use folds to organize this file
set updatetime=100                      " Shorten update time from 4000
set termguicolors                       " 24-bit color support
set noshowmode                          " Hide -- INSERT -- below Airline
set scrolloff=15                        " Keep my cursor reasonably centered

nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
let localmapleader = "\<CR>"

" }}}

" Plugins {{{

" Auto-install Plug {{{2

" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" }}}

call plug#begin()

" Vim UI
Plug 'mhinz/vim-startify'               " Custom start screen
Plug 'vim-airline/vim-airline'
Plug 'arcticicestudio/nord-vim'
Plug 'kshenoy/vim-signature'            " Show marks in gutter

" Code Colors
Plug 'sheerun/vim-polyglot'
Plug 'ntpeters/vim-better-whitespace'
Plug 'luochen1990/rainbow'              " Color my brackets
Plug 'norcalli/nvim-colorizer.lua'      " Color colors

" UI Panels
Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'
Plug 'mbbill/undotree'
Plug 'maxbrunsfeld/vim-yankstack'

" File Finding
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim'            " Required for lf.vim's <Leader>f
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP & Debug Adapter
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector'

" Tasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" Code manipulation
" More intelligent and lower false positive rate than the standard autopairs plugin
Plug 'Krasjet/auto.pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

" Git
Plug 'airblade/vim-gitgutter'           " Show diff symbols in gutter
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'          " Show commit message with <Leader>gm

" Navigation
Plug 'easymotion/vim-easymotion'
Plug 'pechorin/any-jump.nvim'

" Language Specific
Plug 'let-def/ocp-indent-vim'           " Ocaml OCP-indent

call plug#end()

" Plugin Initialization {{{2
" This section is for plugins that need a line to be enabled
" that does not effect functionality

let g:rainbow_active = 1                " Bracket Pair Colorizer
lua require'colorizer'.setup()
let g:asyncrun_open = 6                 " Async terminal commands
call yankstack#setup()                  " Paste from the past

" Disable unwanted default mappings
let g:lf_map_keys = 0
let g:bclose_no_plugin_maps = 1

" }}}

" }}}

" Configure Airline {{{

let g:airline#extensions#tabline#enabled = 1

let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_z = "%p%% %l/%L %c" " Simplify line section
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

let airline#extensions#coc#error_symbol = ' '
let airline#extensions#coc#warning_symbol = ' '

" }}}

" Colors & Appearance {{{

set pumblend=10                         " Pseudo transparency for popups
let g:airline_theme='nord'              " Nord includes a theme for airline

" Theme customizations must be before `colorscheme`
let g:nord_uniform_diff_background = 1
let g:nord_italic                  = 1
let g:nord_underline               = 1
colorscheme nord

" Match Easymotion to Nord
hi EasyMotionTarget    guifg=#BF616A gui=bold
hi EasyMotionIncSearch guifg=#A3BE8C gui=bold
hi EasyMotionShade     guifg=#616E88

" Enable Vim Rainbow and set colors
let g:rainbow_conf = {'guifgs': ['#8FBCBB', '#EBCB8B', '#A3BE8C', '#B48EAD']}

hi SignatureMarkText guifg=#B48EAD      " Default sidebar mark color
hi Floating          guibg=#242933      " Floating window background color

" }}}

" Language Specific {{{

" OCaml
" Opam Initialization
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" OCP Indent (Hopefully ocamlformat can handle this soon)
set rtp^="/Users/ryan/.opam/default/share/ocp-indent/vim"
autocmd FileType ocaml set indentexpr=ocpindent#OcpIndentLine()
autocmd BufWritePre *.ml :call CocAction('format')

" }}}

" Coc Language Server {{{

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
inoremap ;f <C-O>:call CocAction('format')<CR>

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
inoremap ;q <C-O><Plug>(coc-fix-current)

inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Navigate through competion windows Tab/S-Tab/CR
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use tab for autocompletion with Coc
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Open help page or show Coc floating info
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>'
  else
    call CocAction('doHover')
  endif
endfunction

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold   :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

" }}}

" FZF {{{
" Enable Ctrl-P for fzf
nnoremap <C-p> :Files<Cr>

let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': 'call FloatTerm("fzf")' }

" }}}

" Start Screen (Startify) {{{

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

" }}}

" Code Navigation {{{

" Easymotion config
let g:EasyMotion_smartcase = 1
nmap F <Plug>(easymotion-s2)
nmap f <Plug>(easymotion-bd-w)
imap ;S <C-O><Plug>(easymotion-s2)
imap ;s <C-O><Plug>(easymotion-bd-w)
map  / <Plug>(easymotion-sn)

" AnyJump
" Jump to definition under cursor
nnoremap <leader>j :AnyJump<CR>
" open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>
" open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" }}}

" Splits and Windows {{{

" Simplify Window Navigation
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Split windows
nnoremap <Leader>l :vsplit<CR>
nnoremap <Leader>k :split<CR>

" Swap H with ^ and L with $
noremap ^ H
noremap $ L
noremap H ^
noremap L $

" }}}

" Yank, Cut, Delete, Paste, etc. {{{

" Yankstack (paste through time)
nnoremap Y y$
nnoremap <leader>p <Plug>yankstack_substitute_older_paste
nnoremap <leader>P <Plug>yankstack_substitute_newer_paste

" Paste from system clipboard
nmap <leader><leader>p "*p
nmap <leader><leader>P "*P

" Set 's' to 'd' except without storing in a buffer
nnoremap s "_d
nnoremap S "_D
nnoremap ss "_dd

" }}}

" Panel toggles {{{

nnoremap <Leader>tb :Tagbar<CR>
nnoremap <Leader>tv :Vista!!<CR>
nnoremap <Leader>tu :UndotreeToggle<cr>

" Run command in a sidebar
command! -nargs=1 Aside AsyncRun -mode=term -pos=right -cols=50 <args>

" }}}

" Open Floating Windows {{{

nnoremap <Leader>at :call FloatTerm()<CR>
nnoremap <Leader>ag :call FloatTerm('lazygit')<CR>
nnoremap <Leader>ai :call FloatTerm('tig')<CR>
nnoremap <Leader>ar :call FloatTerm('ranger')<CR>
nnoremap <Leader>as :call FloatTerm('spt')<CR>
nnoremap <Leader>af :call FloatTerm('lf')<CR>

" }}}

" Leader shortcuts for commonly used Vim actions {{{

nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>i :Lines<CR>

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
" Figure out why my theme is behaving badly
nnoremap <leader><leader>h :call SynStack()<CR>

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" }}}

" Git and Fugitive {{{

" Color vim signature marks with GitGutter
let g:SignatureMarkTextHLDynamic=1
let g:SignatureMarkerTextHLDynamic=1
let g:SignaturePeriodicRefresh=1

" <Leader>gm shows a popup with the commit for a given line
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gs :Gstatus<CR>

" }}}

" Floating Window Setup {{{

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
  elseif a:1 == 'lf'
    execute 'Lf'
  " Do nothing for fzf so plugin can take effect
  elseif a:1 != 'fzf'
    call termopen(a:1)
  endif

  startinsert
  " Close border window when main window closes
  autocmd TermClose * ++once :bd! | call nvim_win_close(s:float_term_border_win, v:true)
endfunction

" }}}

