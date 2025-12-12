"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Turn on the Wild menu
set wildmenu

" Always show current position
" set ruler

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show matching brackets when text indicator is over them
set showmatch

" Show line numbers on first column
set number

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on

" Set screen background
" set background=dark

" Set colors
colorscheme desert

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4


""""""""""""""""""""""""""""""
" => TABS
""""""""""""""""""""""""""""""
" always show tabline (0=never,1=if tab >1 ,2=always)
set showtabline=2

" custom tabline
set tabline=%!MyTabLine()

""""""""""""""""""""""""""""""
" => Functions
""""""""""""""""""""""""""""""

function! MyTabLine()
  let s = ''
  " loop over tabs
  for i in range(1, tabpagenr('$'))
    " Highlight tabs: current vs others 
    if i == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " Clic on tabs (if mouse enabled)
    let s .= '%' . i . 'T'

    let buflist = tabpagebuflist(i)
    let winnr  = tabpagewinnr(i)
    let buf    = buflist[winnr - 1]

    " File name (name only,no path)
    let fname = bufname(buf)
    if fname == ''
      let fname = '[No Name]'
    else
      let fname = fnamemodify(fname, ':t')
    endif

    " notify if file has been modified
    let modified = getbufvar(buf, '&modified') ? '❗️' : ' ✅'

    let s .= ' ' . i . ': ' . fname . modified . ' '
  endfor

  let s .= '%#TabLineFill#%T'

  return s
endfunction

function! CloseWin(win)
  for w in range(1, winnr('$'))
      if bufname(winbufnr(w)) ==# a:win
          execute w . 'wincmd c'  
          return 1
      endif
  endfor
  return 0
endfunction

function! ShowCustom()
  if CloseWin('[QuickHelp]')
      return
  endif
  new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  file [QuickHelp]
  call setline(1, 'Quick Help')
  call append(1,'SHIFT+t       :> Oepn a terminal at the bottom of the current window')
  call append(1,'SHIFT+Left    :> Move to the tab on the left')
  call append(1,'SHIFT+Right   :> Move to the tab on the right')
  call append(1,'CTRL+n        :> Open new tab')
  call append(1,'<F2>          :> Select all')
  call append(1,'<F3>          :> Copy selection in system clipboard')
  call append(1,'<F4>          :> Open file browser using Netrw')
  call append(1,'<F12>         :> Show this Help')
  call append(1,'====================================================================')
endfunction

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Highlight text desert colorscheme 
hi User1 cterm=bold term=bold,reverse ctermfg=236 ctermbg=144 

" Format the status line
" set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
" https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'

set statusline=
set statusline +=\ [%{&ff}] 
set statusline +=\ %y
set statusline +=\ [%{''.(&fenc!=''?&fenc:&enc).''}]
set statusline +=\ %<%F "%m
set statusline +=\ \ Line:\%l\/%L\ \[\%p%%]
set statusline +=\ \ Column:\%c
set statusline +=%=
"set statusline +=\%1*<F4>\ Open\ \|   
"set statusline +=\ \%1*<F3>\ Copy\ selection\ \|   
"set statusline +=\ \%1*<F2>\ Select\ all\ \|   
set statusline +=\ \%1*<F12>\ Help 

""""""""""""""""""""""""""""""
" => Mappings
""""""""""""""""""""""""""""""

" Open a terminal below current tan
noremap <silent> <S-t> :below terminal<CR>

" Move on left tab
noremap <silent> <S-Left> gT

" Move on right tab
noremap <silent> <S-Right> gt

" Open a new file with no name in a new tab [CTRL+n]
noremap <silent> <C-n> :tabnew<CR>

" Select All
noremap <silent> <F2> ggVG

" Copy selection to the system clipboard [visual mode]
vnoremap <silent> <F3> "+y

" Open Netrw on the left
noremap <silent> <F4> :Lex<CR>

" Show custom maps
noremap <silent> <F12> :call ShowCustom()<CR>

""""""""""""""""""""""""""""""
" => Terminal
""""""""""""""""""""""""""""""
set termwinsize=15*0

""""""""""""""""""""""""""""""
" => Netrw
""""""""""""""""""""""""""""""
" Tree view
let g:netrw_liststyle = 3

" Size of Netrw window
let g:netrw_winsize = 25

" Hide banner
let g:netrw_banner = 0

""""""""""""""""""""""""""""""
" => YAML,Shell,ZShell
""""""""""""""""""""""""""""""
autocmd FileType yaml,sh,zsh,json setlocal ts=2 sts=2 sw=2 expandtab


if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":autocmd! vimStartup"
  augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim), for a commit or rebase message
    " (likely a different one than last time), and when using xxd(1) to filter
    " and edit binary files (it transforms input files back and forth, causing
    " them to have dual nature, so to speak)
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

  augroup END
endif
