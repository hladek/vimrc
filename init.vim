
"" Default clipboard
set clipboard=unnamed,unnamedplus
"Ctrl-c to copy in + buffer from visual mode
vmap <C-c> "+y

"Ctrl-p to paste from the + register in cmd mode
" nnoremap <C-v> Pi

"Ctrl-p to paste from the + register while editing
 " inoremap <C-v> <ESC>Pi


let g:maplocalleader = "\\"
let g:mapleader = "\<Space>"

if has("nvim")
" Terminal exit
tnoremap <Esc> <C-\><C-n>
endif



" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_python_exec = 'python3'
" let g:syntastic_python_flake8_args = "--ignore=E501"
" autocmd FileType pandoc nnoremap <buffer> <Space>o :TOC<CR>

" let g:pandoc#formatting#mode = 'hA'
" let g:pandoc#formatting#textwidth = 80
" let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1
" let g:pandoc#modules#disabled = ["folding"]

" set wrap "Wrap lines
"let g:pencil#wrapModeDefault = 'soft'


nnoremap <Leader>w :w<CR>
vnoremap <C-s> <ESC>wi
nnoremap <C-s> w


" Smart way to move between windows
" map <C-j> <C-W>j
" map <C-k> <C-W>k
" map <C-h> <C-W>h
" map <C-l> <C-W>l

" Jump after paste
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]


""""""""""""" key map timeouts
"
""
set notimeout
"set ttimeout
"
" personally, I find a tenth of a second to work well for key code
" timeouts. If you experience problems and have a slow terminal or network
" connection, set it higher.  If you don't set ttimeoutlen, the value for
"
" timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
"
"set ttimeoutlen=400
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" => VIM user interface
 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " Set 7 lines to the cursor - when moving vertically using j/k
set so=7
set splitbelow
set splitright
 "Always show current position
 set ruler
 " Height of the command bar
 set cmdheight=2
 " A buffer becomes hidden when it is abandoned
 set hid
 " Configure backspace so it acts as it should act
 set backspace=eol,start,indent
" Sets how many lines of history VIM has to remember
set history=700
 """""""""""""""""""""
 " Mouse

 " In many terminal emulators the mouse works just fine, thus enable it.
 if has('mouse')
 set mouse=a
 endif

"""""""""""""""""""
" Searching
 
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
 " For regular expressions turn magic on
 set magic
 " Show matching brackets when text indicator is over them
 set showmatch
 " How many tenths of a second to blink when matching brackets
 set mat=2
 " No annoying sound on errors
 set noerrorbells
 set novisualbell
 set t_vb=
 set tm=500
 " Add a bit extra margin to the left
 set foldcolumn=1

""""""""""""""""""""""
" Editing
""
 " Use spaces instead of tabs
set expandtab
 " Be smart when using tabs ;)
set smarttab
 " 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
 " Linebreak on 500 characters
set autoindent "Auto indent
set smartindent "Smart indent

" Komenty v Pythone
inoremap # X#

" Pre quickfix do toho isteho okna
set switchbuf=useopen
set hidden

set completeopt=menu
set laststatus=2
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc,bin/**,.git/**,*.lm,*.vocab,*.gz
set wildmenu                                                 " show a navigable menu for tab completion
"set wildmode=longest,list,full


set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping
" Enable filetype plugins
filetype plugin on
filetype indent on
" Set to auto read when a file is changed from the outside
set autoread

 " Return to last edit position when opening files (You want this!)
 autocmd BufReadPost *
 \ if line("'\"") > 0 && line("'\"") <= line("$") |
 \ exe "normal! g`\"" |
 \ endif


call plug#begin()

""""""""""
"" Status line
"""""

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

"""" """"""""""
" General Editing
"""""""""""""""
Plug 'tpope/vim-sensible'

Plug 'Raimondi/delimitMate'


Plug 'terryma/vim-expand-region'
" Expand selection by v (uses text objects)
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'

""""""""""""""""
" Binary file editing
Plug 'Shougo/vinarise.vim'

""""""""
" Project root guess
"
Plug 'dbakker/vim-projectroot'
let g:rootmarkers = ['.git' , 'src' , 'README.md','.gitignore']

""""""""""""""""
"File Navigation - NerdTree
"

Plug 'scrooloose/nerdtree'

nnoremap <Leader>f :NERDTreeToggle <C-R>=ProjectRootGuess()<CR><CR>
let NERDTreeQuitOnOpen = 1
" Quit NERDTree if it is the only window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
Plug 'Xuyuanp/nerdtree-git-plugin'

""""""""""""""""
" Unite
"

Plug 'Shougo/unite.vim'

" let g:unite_data_directory = "~/tmp"
let g:unite_abbr_highlight = "Normal"

Plug 'Shougo/neomru.vim'
" Unite mappings
nnoremap <Leader>q :Unite buffer file_mru<CR>
nnoremap <Leader>b :Unite buffer file_mru<CR>
let g:neomru#file_mru_limit=10

Plug 'osyo-manga/unite-quickfix'
nnoremap <Leader>x :Unite quickfix<CR>
autocmd QuickfixCmdPost Unite quickfix

Plug 'Shougo/unite-outline'

nnoremap <Leader>o :Unite -vertical -direction=belowright -winwidth=60 -auto-preview outline<CR>

"""""""""""
" Marks
"

Plug 'kshenoy/vim-signature'

""""""""""""
" Make and syntax Check
""

Plug 'neomake/neomake'
autocmd! BufWritePost * Neomake

""""""""""""""""
" Find and replace
""""""""""""
Plug 'dkprice/vim-easygrep'

let g:EasyGrepOpenWindowOnMatch = 0
let g:EasyGrepCommand = 1
let g:EasyGrepFilesToExclude = "tags,.aux,.log,.bbl"
let g:EasyGrepJumpToMatch = 0
let g:EasyGrepMode = 1

""""""
""  Tags
""

" Dependency For easytags and pyref
Plug 'xolox/vim-misc'

if executable("ctags")
  ""  Plug 'majutsushi/tagbar'

  ""  nnoremap <Leader>o :TagbarOpenAutoClose<CR>

  ""  let g:tagbar_singleclick = 1
  ""  let g:tagbar_sort = 0
  ""  let g:tagbar_type_make = {
  ""              \ 'kinds':[
  ""                  \ 'm:macros',
  ""                  \ 't:targets'
  ""              \ ]
  ""  \}

  ""  set tags=./tags;,tags;

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

  ""  let g:tagbar_type_tex = {
  ""      \ 'ctagstype' : 'latex',
  ""      \ 'kinds' : [
  ""      \ 'c:chapters',
  ""      \ 's:sections',
  ""      \ 'u:subsections',
  ""      \ 'b:subsubsections',
  ""      \ 'p:parts',
  ""      \ 'P:paragraphs',
  ""      \ 'G:subparagraphs',
  ""      \ 'i:includes', 
  ""      \ 'l:labels',
  ""      \ 'b:bibitems',
  ""      \ ],
  ""   \ 'sort' : 0
  ""  \ }

    Plug 'xolox/vim-easytags'
    let g:easytags_async = 1
    let g:easytags_dynamic_files = 1
    let g:easytags_events = ['BufWritePost']
    let g:easytags_on_cursorhold = 0

endif
"""""""
" Git
" """""

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

""""""""""""""""""""
" Code Comletion
" """"""""""

if has("nvim")

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
let g:clang_verbose_pmenu = 1
let g:clang_compilation_database = "./"
let g:clang_diagsopt = ''   " <- disable diagnostics
autocmd CompleteDone * pclose
endif

Plug 'shougo/neoinclude.vim'


""""""""""""""
"""" CPP Editing
"""""""""
Plug 'justmao945/vim-clang'
Plug 'octol/vim-cpp-enhanced-highlight'


"""""""""
" Python
" """""

let g:neomake_python_flake8_maker = {
    \ 'args': ['--ignore=E221,E231,E241,E272,E251,W702,E203,E201,E202,E501',  '--format=default'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#',
    \ }
let g:neomake_python_enabled_makers = ['flake8']

if has("python3")
Plug 'davidhalter/jedi-vim'
endif

" Python reference manual search
" depends on vim-misc
Plug 'xolox/vim-pyref'
let g:pyref_mapping = 'K'

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
let g:lexical#thesaurus = ['~/.config/nvim/mthesaur.txt',]

au Filetype tex set makeprg=latexmk\ -f\ -pdf\ %
au Filetype bib set makeprg=latexmk\ -f\ -pdf\ %
"Reformat paragraph endlines
nnoremap <Leader>= gwip

Plug 'reedes/vim-wordy'

"""""""""""
" Color scheme

Plug 'nanotech/jellybeans.vim'

call plug#end()

 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " => Colors and Fonts
 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " Enable syntax highlighting
 syntax enable
  " Set utf8 as standard encoding and en_US as the standard language
 set encoding=utf8
 " Use Unix as the standard file type
 set ffs=unix,dos,mac
 
colorscheme jellybeans
set guifont=Monospace\ 13
set t_Co=256
