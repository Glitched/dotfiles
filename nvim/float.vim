" ##############################
" ## Floating Windows
" ##############################

" Set background color for floating windows
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

