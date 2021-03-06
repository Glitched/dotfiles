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

set autowrite                           " Write file before building

nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
let localmapleader = "\<CR>"
nnoremap ; :
nnoremap : ;

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
Plug 'vimwiki/vimwiki'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'kshenoy/vim-signature'            " Show marks in gutter

" Code Colors
Plug 'ntpeters/vim-better-whitespace'
Plug 'luochen1990/rainbow'              " Color my brackets
Plug 'norcalli/nvim-colorizer.lua'      " Color colors

" UI Panels
Plug 'liuchengxu/vista.vim'
Plug 'mbbill/undotree'
Plug 'maxbrunsfeld/vim-yankstack'

" File Finding
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim'            " Required for lf.vim's <Leader>f
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf'

" LSP & Debug Adapter
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'nvim-treesitter/nvim-treesitter'
Plug 'puremourning/vimspector'

" Tasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" Code manipulation
" More intelligent and lower false positive rate than the standard autopairs plugin
Plug 'Krasjet/auto.pairs'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

" Snippets
Plug 'SirVer/ultisnips'

" Git
Plug 'airblade/vim-gitgutter'           " Show diff symbols in gutter
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'          " Show commit message with <Leader>gm

" Navigation
Plug 'easymotion/vim-easymotion'
Plug 'pechorin/any-jump.nvim'

" Language Specific
Plug 'let-def/ocp-indent-vim'           " Ocaml OCP-indent
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hhvm/vim-hack'

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
let g:UltiSnipsExpandTrigger=""

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

hi Search guifg=NONE guibg=#4C566A gui=bold " Make search hl less obtrusive
hi Floating          guibg=#242933      " Floating window background color
hi SignatureMarkText guifg=#B48EAD      " Default sidebar mark color
hi CocHighlightText  guibg=#4C566A      " Make cursor hold highlights visible


hi ExtraWhitespace   guibg=#BF616A        " Nord red for better whitespace

" }}}

" Language Specific {{{

" Hacklang
autocmd FileType hack setlocal equalprg=hackfmt
autocmd BufWritePre *.hack :normal gg=G``
autocmd BufWritePre *.php :normal gg=G``

" OCaml
" Opam Initialization
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"

" OCP Indent (Hopefully ocamlformat can handle this soon)
set rtp^="/Users/ryan/.opam/default/share/ocp-indent/vim"
autocmd FileType ocaml set indentexpr=ocpindent#OcpIndentLine()
autocmd BufWritePre *.ml :call CocAction('format')

" Go
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = "goimports"
let g:go_gopls_options = ['-remote=auto']
let g:go_code_completion_enabled = 0
let g:go_auto_type_info = 1           " Automatically show context info
let g:go_decls_mode = 'fzf'           " Enable support w/o ctrl-p
let g:go_doc_popup_window = 1         " Display docs in popup
let g:go_term_enabled = 1             " Run go commands in a term

" Syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1

" Nord for Go Debugger
let g:go_highlight_debug = 0
hi GoDebugBreakpoint guifg=#BF616A guibg=none gui=bold
hi GoDebugCurrent guifg=none guibg=#434C5E
hi GoDebugCurrentSign guifg=#88C0D0 gui=bold
let g:go_debug_breakpoint_sign_text = '->'
" TODO: Find a way to define signs after vim-go loads them
autocmd FileType go nnoremap call sign_define("godebugcurline", {"text":"=>","texthl":"GoDebugCurrentSign"})

" Go actions based on <Leader>r
autocmd FileType go nnoremap <leader>r  :GoRun<CR>
autocmd FileType go nnoremap <leader>rr :GoRun<CR>
autocmd FileType go nnoremap <leader>rt :GoTest<CR>
autocmd FileType go nnoremap <leader>rc :GoCoverageToggle<CR>
autocmd FileType go nnoremap <leader>rl :GoMetaLinter<CR>
autocmd FileType go nnoremap <leader>rd :GoDecls<CR>
autocmd FileType go nnoremap <leader>rg :GoDeclsDir<CR>

" Go Debugger Shortcuts
autocmd FileType go nnoremap <leader>da :GoDebugStart<CR>
autocmd FileType go nnoremap <leader>dd :GoDebugStop<CR>
autocmd FileType go nnoremap <leader>dr :GoDebugRestart<CR>
autocmd FileType go nnoremap <leader>dt :GoDebugTest<CR>
autocmd FileType go nnoremap <leader>db :GoDebugBreakpoint<CR>
autocmd FileType go nnoremap <leader>dc :GoDebugContinue<CR>
autocmd FileType go nnoremap <leader>dn :GoDebugNext<CR>
autocmd FileType go nnoremap <leader>ds :GoDebugStep<CR>
autocmd FileType go nnoremap <leader>do :GoDebugStepOut<CR>
autocmd FileType go nnoremap <leader>dp :GoDebugPrint
autocmd FileType go nnoremap <leader>de :GoDebugSet<CR>

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
nmap <leader>cf  <Plug>(coc-fix-current)
inoremap ;q <C-O><Plug>(coc-fix-current)

inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Navigate through competion windows Tab/S-Tab/CR
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ?
      \ coc#_select_confirm() :
      \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
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
    execute 'h '.expand('<cword>')
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
nmap F <Plug>(easymotion-s)
nmap f <Plug>(easymotion-bd-w)
imap ;S <C-O><Plug>(easymotion-s)
imap ;s <C-O><Plug>(easymotion-bd-w)

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
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>

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
inoremap ;a <Esc>A
inoremap ;o <Esc>A<Cr>

" }}}

" Yank, Cut, Delete, Paste, etc. {{{

" Yankstack (paste through time)
nnoremap Y y$
nnoremap <leader>p <Plug>yankstack_substitute_older_paste
nnoremap <leader>P <Plug>yankstack_substitute_newer_paste

" Paste from system clipboard
vmap <leader><leader>y "*y
vmap <leader><leader>Y "*Y
nmap <leader><leader>y "*y
nmap <leader><leader>Y "*Y
nmap <leader><leader>p "*p
nmap <leader><leader>P "*P

" Set 's' to 'd' except without storing in a buffer
nnoremap s "_d
nnoremap S "_D
nnoremap ss "_dd

" }}}

" Panel toggles {{{

nnoremap <Leader>tv :Vista!!<CR>
nnoremap <Leader>tu :UndotreeToggle<cr>

" Run command in a sidebar
command! -nargs=1 Aside AsyncRun -mode=term -pos=right -cols=50 <args>

" }}}

" Open Floating Windows {{{

nnoremap <Leader>at :call FloatTerm()<CR>
nnoremap <Leader>ag :call FloatTerm('lazygit')<CR>
nnoremap <Leader>gg  :call FloatTerm('lazygit')<CR>
nnoremap <Leader>ai :call FloatTerm('tig')<CR>
nnoremap <Leader>as :call FloatTerm('spt')<CR>
nnoremap <Leader>af :call FloatTerm('lf')<CR>
nnoremap <Leader>an :call FloatTerm('nnn')<CR>

" }}}

" Leader shortcuts for commonly used Vim actions {{{

nnoremap <Leader>d :bnext<CR>
" FZF
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>i :Lines<CR>
" Coc-FZF
nnoremap <Leader>cc :CocFzfListResume<CR>
nnoremap <Leader>co :CocFzfList outline<CR>
nnoremap <Leader>cs :CocFzfList symbols<CR>
nnoremap <Leader>ca :CocFzfList actions<CR>
nnoremap <Leader>cd :CocFzfList diagnostics<CR>
nnoremap <Leader>cb :CocFzfList diagnostics --current-buf<CR>
nnoremap <Leader>ce :CocFzfList extensions<CR>
nnoremap <Leader>cl :CocFzfList location<CR>
nnoremap <Leader>cv :CocFzfList services<CR>
nnoremap <Leader>cr :CocFzfList sources<CR>
" Alternate
nnoremap <Leader>aa :A<CR>

" Vim manipulation

nnoremap <Leader><Leader>r :so $MYVIMRC<CR>
nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>c :PlugClean<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader><Leader>q :q!<CR>
nnoremap <Leader>Q :qa<CR>
nnoremap <Leader><Leader>Q :qa!<CR>
nnoremap <Leader>x :x<CR>
nnoremap <Leader>h :noh<CR>

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
let g:gitgutter_sign_priority = 6      " Reduce priority so breakpoints are visible

" <Leader>gm shows a popup with the commit for a given line
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gP :Gpull<CR>

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

" {{{ Notes
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" }}}

function! VimRebaseModeMaps()
    nnoremap <buffer> P 0ciwpick<ESC>j
    nnoremap <buffer> R 0ciwreword<ESC>j
    nnoremap <buffer> E 0ciwedit<ESC>j
    nnoremap <buffer> S 0ciwskip<ESC>j
    nnoremap <buffer> F 0ciwfixup<ESC>j
    nnoremap <buffer> X 0ciwx<ESC>j
    nnoremap <buffer> D 0ciwdrop<ESC>j
endfunction

autocmd FileType gitrebase call VimRebaseModeMaps()

