
" vimrc.vim - Extension of vim-sensible plugin with less sensible defaults.
" Maintainer:   Adam Stankiewicz <sheerun@sher.pl>
" Version:      2.0

if exists("g:loaded_vimrc") || &cp
  finish
else
  let g:loaded_vimrc = 1
end

let g:maplocalleader = "\\"
let g:mapleader = "\<Space>"

"" Basics

" Disable strange Vi defaults.
set nocompatible

" Turn on filetype plugins (:help filetype-plugin).
if has('autocmd')
  filetype plugin indent on
endif

 """""""""""""""""""""
 " Mouse

 " In many terminal emulators the mouse works just fine, thus enable it.
 if has('mouse')
 set mouse=a
 endif

""""""""""""" key map timeouts
"
""
" Allow for mappings including `Esc`, while preserving
" zero timeout after pressing it manually.
set ttimeout
set ttimeoutlen=100
set notimeout

""""""""""""""""""""
" Windows
""""""""""

" Use Q to intelligently close a window
" (if there are multiple windows into the same buffer)
" or kill the buffer entirely if it's the last window looking into that buffer.
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif
  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Set window title by default.
set title

" Always focus on splited window.
set splitright
set splitbelow


"""""""""""""""""""
" Shell and Termianl
" 

if has("nvim")
" Terminal exit
tnoremap <Esc> <C-\><C-n>
endif

" Avoid problems with fish shell
" ([issue](https://github.com/tpope/vim-sensible/issues/50)).
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

""""""""
" Save and load  File
""""""""""""

" Set to auto read when a file is changed from the outside
set autoread

 " Return to last edit position when opening files (You want this!)
 autocmd BufReadPost *
 \ if line("'\"") > 0 && line("'\"") <= line("$") |
 \ exe "normal! g`\"" |
 \ endif
" Disable swap to prevent annoying messages.
set noswapfile

" Expand %% to path of current buffer in command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

nnoremap <Leader>w :w<CR>

" Enable saving by `Ctrl-s`
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Enable backup and undo files by default.
let s:dir = has('win32') ? '$APPDATA/Vim' : isdirectory($HOME.'/Library') ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
let &backupdir = expand(s:dir) . '/backup//'
let &undodir = expand(s:dir) . '/undo//'
set undofile

" Automatically create directories for backup and undo files.
if !isdirectory(expand(s:dir))
  call system("mkdir -p " . expand(s:dir) . "/{backup,undo}")
end



""""""""""""""
" Indent
""

 " 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
 " Linebreak on 500 characters
set smartindent "Smart indent
" Autoindent when starting new line, or using `o` or `O`.
set autoindent
" Use 'shiftwidth' when using `<Tab>` in front of a line.
" By default it's used only for shift commands (`<`, `>`).
set smarttab
 " Use spaces instead of tabs
set expandtab


call plug#begin()

""""""""""""""""""""""
" Editing
""

Plug 'tpope/vim-repeat'

" finds next character with fFtT

Plug 'dahu/vim-fanfingtastic'

Plug 'tpope/vim-unimpaired'

" Display undotree by UndotreeToggle
Plug 'mbbill/undotree'

" Do not fold by default. But if, do it up to 3 levels.
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Allow backspace in insert mode.
set backspace=indent,eol,start

 " Use Unix as the standard file type
 set ffs=unix,dos,mac

set history=700
" Support all kind of EOLs by default.
set fileformats+=mac

" Save up to 100 marks, enable capital marks.
set viminfo='100,f1

" Use dash as word separator.
set iskeyword+=-

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


""""""""""""""""
" Binary file editing
Plug 'Shougo/vinarise.vim'



"""" """"""""""
" Copy and Paste
"""""""""""""""

" Make sure pasting in visual mode doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()
" Visually select the text that was last edited/pasted (Vimcast#26).
noremap gV `[v`]
"Ctrl-c to copy in + buffer from visual mode
vmap <C-c> "+y
" Y yanks from the cursor to the end of line as expected. See :help Y.
nnoremap Y y$

" http://stackoverflow.com/questions/2861627/paste-in-insert-mode
set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>

" And this for yanking visual selection into clipboard with Ctrlc:

vnoremap <C-c> "+y

" Blinks on yw, yy ...
Plug 'machakann/vim-highlightedyank'

" vv to select word and more
" Ctrl v to select less
Plug 'terryma/vim-expand-region'
" Expand selection by v (uses text objects)
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'

"" Default clipboard
set clipboard=unnamed,unnamedplus

"""""""""""""""
" Buffer and File switch
"
" Plug 'ctrlpvim/ctrlp.vim'

" If opening buffer, search first in opened windows.
set switchbuf=usetab

" Hide buffers instead of asking if to save them.
set hidden
Plug 'Shougo/unite.vim'

Plug 'Shougo/denite.nvim'
let g:unite_data_directory = "~/tmp"
let g:unite_abbr_highlight = "Normal"

Plug 'Shougo/neomru.vim'
" Unite mappings
nnoremap <Leader>q :Unite buffer file file_mru<CR>
let g:neomru#file_mru_limit=10


""""""""""
" Quickfix
"
Plug 'romainl/vim-qf'

nmap <Leader>x <PLug>QfCtoggle

" Pre quickfix do toho isteho okna
set switchbuf=useopen
set hidden

" Plug 'osyo-manga/unite-quickfix'
"nnoremap <Leader>x :Unite quickfix<CR>
" autocmd QuickfixCmdPost Unite quickfix


""""""""""""
" Make and syntax Check
""

Plug 'neomake/neomake'
autocmd! BufWritePost * Neomake

""""""""""""""""
" Find and replace
""""""""""""

" Highlight on substitute s/something
Plug 'osyo-manga/vim-over'

" Use Silver Searcher for CtrlP plugin (if available)
" Fallback to git ls-files for fast listing.
" Because we use fast strategies, disable caching.
let g:ctrlp_use_caching = 0
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'cd %s && ag -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git',
    \ 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f' ]
endif

" Accept CtrlP selections also with <Space>
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<Space>', '<CR>', '<2-LeftMouse>'],
  \ }
" Auto center on matched string.
noremap n nzz
noremap N Nzz
" Keep flags when repeating last substitute command.
nnoremap & :&&<CR>
xnoremap & :&&<CR>
" Enable search highlighting.
set hlsearch

" Enable highlighted case-insensitive incremential search.
set incsearch

" Use `Ctrl-L` to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
" Ignore case when searching.
set ignorecase
" Don't ignore case when search has capital letter
" (although also don't ignore case by default).
set smartcase
" Make a simple "search" text object.
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" It allows for replacing search matches with cs and then /././.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>
 " Ignore case when searching
 set ignorecase
 " When searching try to be smart about cases
 set smartcase
 " Highlight search results
 set hlsearch
 " Makes search act like search in modern browsers
 set incsearch
 " For regular expressions turn magic on
 set magic

" <Leader>vv grep for word under cursor
Plug 'dkprice/vim-easygrep'


let g:EasyGrepOpenWindowOnMatch = 0
let g:EasyGrepCommand = 1
let g:EasyGrepFilesToExclude = "tags,.aux,.log,.bbl"
let g:EasyGrepJumpToMatch = 0
let g:EasyGrepMode = 0
let g:EasyGrepRoot = "search:.git,.hg,.svn"

""""""
""  Tags
""

" Don't scan included files. The .tags file is more performant.
set complete-=i
" Dependency For easytags and pyref
Plug 'xolox/vim-misc'

if executable("ctags")
    Plug 'majutsushi/tagbar'
    nnoremap <Leader>o :TagbarOpenAutoClose<CR>

    let g:tagbar_singleclick = 1
    let g:tagbar_sort = 0
    let g:tagbar_type_make = {
                \ 'kinds':[
                    \ 'm:macros',
                    \ 't:targets'
                \ ]
    \}


  ""  " Add support for markdown files in tagbar.
  ""  let g:tagbar_type_pandoc = {
  ""      \ 'ctagstype': 'markdown',
  ""      \ 'ctagsbin' : '~/.congig/nvim/markdown2ctags.py',
  ""      \ 'ctagsargs' : '-f - --sort=yes',
  ""      \ 'kinds' : [
  ""          \ 's:sections',
  ""          \ 'i:images'
  ""      \ ],
  ""      \ 'sro' : '|',
  ""      \ 'kind2scope' : {
  ""          \ 's' : 'section',
  ""      \ },
  ""      \ 'sort': 0,
  ""  \ }

    let g:tagbar_type_tex = {
        \ 'ctagstype' : 'latex',
        \ 'kinds' : [
        \ 'c:chapters',
        \ 's:sections',
        \ 'u:subsections',
        \ 'b:subsubsections',
        \ 'p:parts',
        \ 'P:paragraphs',
        \ 'G:subparagraphs',
        \ 'i:includes', 
        \ 'l:labels',
        \ 'b:bibitems',
        \ ],
     \ 'sort' : 0
    \ }


    Plug 'xolox/vim-easytags'
    let g:easytags_async = 1
    let g:easytags_events = ['BufWritePost','BufReadPost']
    let g:easytags_on_cursorhold = 0

    " For tags in working directory
    let g:easytags_dynamic_files = 2
    set tags = "./tags"
    set cpo += "d"

endif


" nnoremap <Leader>t :CtrlPBufTag<CR>
" let g:ctrlp_match_window = 'top,order:ttb,min:1,max:10,results:100'


" Plug 'Shougo/unite-outline'

"nnoremap <Leader>o :Unite -start-insert -vertical -direction=belowright -winwidth=60 -auto-preview outline<CR>

" Plug 'tsukkee/unite-tag'

"""""""
" Git
" """""

Plug 'tpope/vim-fugitive'

" Shows marks on lines
Plug 'airblade/vim-gitgutter'

""""""""""""""""""""
" Comletion
" """"""""""

set completeopt=menu
set laststatus=2

" Disable output, vcs, archive, rails, temp and backup files.
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc,bin/**,.git/**,*.lm,*.vocab,*.gz
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*
"set wildmode=longest,list,full

" Autocomplete commands using nice menu in place of window status.
" Enable `Ctrl-N` and `Ctrl-P` to scroll through matches.
set wildmenu

" For autocompletion, complete as much as you can.
set wildmode=longest,full
if has("nvim")
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'shougo/neoinclude.vim'

let g:deoplete#enable_at_startup = 1
let g:clang_verbose_pmenu = 1
let g:clang_compilation_database = "./"
let g:clang_diagsopt = ''   " <- disable diagnostics
autocmd CompleteDone * pclose
else
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
endif



""""""""""""""
"""" CPP Editing
"""""""""
Plug 'justmao945/vim-clang'
Plug 'octol/vim-cpp-enhanced-highlight'


"""""""""
" Python
" """""

" Komenty v Pythone
inoremap # X#
if executable("flake8")
let g:neomake_python_flake8_maker = {
    \ 'args': ['--ignore=E221,E231,E241,E272,E251,W702,E203,E201,E202,E501',  '--format=default'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#',
    \ }
let g:neomake_python_enabled_makers = ['flake8']
endif
if has("python3")
Plug 'davidhalter/jedi-vim'
endif
Plug 'hynek/vim-python-pep8-indent'
"Plug 'vim-scripts/indentpython.vim'


""""""""
"" Text file, TEX and Markdown
""""

" Close environent with Ctrl + _
Plug 'vim-scripts/closeb'

Plug 'beloglazov/vim-online-thesaurus'

" Hlavne dobre na robenie tabuliek
" oznacit ga& zarovna okolo &
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

Plug 'reedes/vim-lexical'
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd,md call lexical#init()
  autocmd FileType tex call lexical#init()
  autocmd FileType text call lexical#init({ 'spell': 0 })
"  autocmd FileType markdown,mkd,md call pencil#init()
"  autocmd FileType tex call pencil#init()
"  autocmd FileType text         call pencil#init()
augroup END

" [s next bad word
" z= suggests correction
" set spelllang=sk Nastavi jazyk na spellovanie

let g:lexical#thesaurus = ['~/.config/nvim/mthesaur.txt',]

au Filetype tex set makeprg=latexmk\ -f\ -pdf\ %
au Filetype bib set makeprg=latexmk\ -f\ -pdf\ %
"Reformat paragraph endlines
nnoremap <Leader>= gwip

" For proofreading
Plug 'reedes/vim-wordy'

""""""""""
"" Status line
"""""

" Show mode in statusbar, not separately.
set noshowmode
" Always show window statuses, even if there's only one.
set laststatus=2

" Show the line and column number of the cursor position.
set ruler

" Show the size of block one selected in visual mode.
set showcmd

Plug 'vim-airline/vim-airline'
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#bufferline#overwrite_variables = 1
"let g:airline_section_x = '%{PencilMode()}'

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

Plug 'bling/vim-bufferline'
let g:bufferline_show_bufnr = 0
let g:bufferline_rotate = 1
let g:bufferline_echo = 1
"""""""""""
" View

" Shows marks on lines
Plug 'kshenoy/vim-signature'
" Color scheme
"
Plug 'nanotech/jellybeans.vim'
call plug#end()

 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " => Colors and Fonts
 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

" Enable syntax highlighting.
if has('syntax')
  syntax enable
endif

 " Enable syntax highlighting
  " Set utf8 as standard encoding and en_US as the standard language
 set encoding=utf8

 " Set 7 lines to the cursor - when moving vertically using j/k
set so=7
 "Always show current position
 set ruler
 " Height of the command bar
 set cmdheight=2
" Sets how many lines of history VIM has to remember
" TODO - error on first start
colorscheme jellybeans
set guifont=Monospace\ 13
set t_Co=256


" Force utf-8 encoding in GVim
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

" Highlight line under cursor. It helps with navigation.
set cursorline

" Keep 8 lines above or below the cursor when scrolling.
set scrolloff=8

" Keep 15 columns next to the cursor when scrolling horizontally.
set sidescroll=1
set sidescrolloff=15

" Set minimum window size to 79x5.
set winwidth=79
set winheight=5
set winminheight=5

" Disable any annoying beeps on errors.
set noerrorbells
set visualbell

 set t_vb=
 set tm=500
 " Add a bit extra margin to the left
 set foldcolumn=1
" Don't display the intro message on starting Vim.
set shortmess+=I

" When 'wrap' is on, display last line even if it doesn't fit.
set display+=lastline

" Wrap lines by default
set wrap linebreak
set showbreak=" "


set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping
" Set default whitespace characters when using `:set list`
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

 " Don't redraw while executing macros (good performance config)
 set lazyredraw
 " Show matching brackets when text indicator is over them
 set showmatch
 " How many tenths of a second to blink when matching brackets
 set mat=2
