
call plug#begin()
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

""" Project specific vimrc

set exrc
set secure

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

"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 17
"
"nnoremap <Leader>f :Vexplore<CR>

Plug 'scrooloose/nerdtree'

nnoremap <Leader>f :NERDTree<CR>
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



""""""""""""""""""""""
" Editing
""

Plug 'tpope/vim-repeat'

Plug 'tpope/vim-surround'

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

""""""""
" REST console in REST filetype
":set ft=rest
Plug 'diepm/vim-rest-console'


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

"" Default clipboard
if (executable('pbcopy') || executable('xclip') || executable('xsel')) && has('clipboard')
    set clipboard=unnamed,unnamedplus
endif


""""
" Text Objects
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
" Latex
"    im: inside math environment. Recognizes $, \[ ... \], \( ... \). Usable as vim, cim, etc.
"    ie: inside environment. Recognizes matching \begin and \end tags.
"    %: jump around between matched begin/end blocks. If the current line does not have one, use default % motion. Works in visual mode.
Plug 'gibiansky/vim-latex-objects'
" i – the current indentation level and the line above
" ii – the current indentation level excluding the line above 
Plug 'michaeljsmith/vim-indent-object'


" Make a simple "search" text object.
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" It allows for replacing search matches with cs and then /././.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

"""""""""""""""
" Buffer and File switch
"

" If opening buffer, search first in opened windows.
set switchbuf=usetab

" Hide buffers instead of asking if to save them.
set hidden

if has("nvim") || v:version >= 800
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" Change mappings.
" call denite#custom#map('insert','<pageup>','<denite:move_to_next_line>','noremap')
" call denite#custom#map('insert','<pagedown>','<denite:move_to_previous_line>','noremap')

endif
"nnoremap <Leader>q :Denite buffer<CR>
"else
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$\|build\|dist\|venv',
    \ 'file': '\v\.(exe|so|dll)$',
    \ }

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

nnoremap <Leader>q :CtrlPBuffer<CR>
"endif


""""""""""
" Quickfix
"
" Plug 'romainl/vim-qf'
Plug 'chemzqm/denite-extra'
" nmap <Leader>x <Plug>QfCtoggle

" nmap <Leader>l <Plug>QfLtoggle
" Pre quickfix do toho isteho okna
set switchbuf=useopen
set hidden



""""""""""""
" Make and syntax Check
""

"Plug 'neomake/neomake'
" autocmd! BufWritePost * Neomake

" let g:neomake_open_list = 2
""""""""""""""""
" Find and replace
""""""""""""

" Fallback to git ls-files for fast listing.
if executable('ag')
    set grepprg=ag\ --vimgrep
endif

" Auto center on matched string.
noremap n nzz
noremap N Nzz
" Keep flags when repeating last substitute command.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Search live preview
if has('nvim')
set inccommand=split
endif

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

Plug 'mhinz/vim-grepper'
" <Leader>vv grep for word under cursor


" * # search for visual selection
"Plug 'bronson/vim-visual-star-search'
function! Esca(str)
    let res = escape(a:str, '\*')
    let res = substitute(res, '\n', '\\n', 'g')
    let res = substitute(res, '\[', '\\[', 'g')
    let res = substitute(res, '\~', '\\~', 'g')
    return res
endfunction

function! VStar()
    let temp = @"
    normal! gvy
    let res = Esca(@")
    let @" = temp
    return res
endfunction


" Grep operator
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)


nnoremap <Leader>8 <ESC>:<C-U>Grepper -noprompt -cword -dir file,root<CR>
xnoremap * <ESC>/<C-R>=VStar()<CR><CR>
xnoremap # <ESC>?<C-R>=VStar()<CR><CR>
xnoremap / <ESC>/<C-R>=VStar()<CR>
xmap <Leader>/ <plug>(GrepperOperator)
nnoremap <Leader>/ <ESC>:<C-U>Grepper<CR>
xnoremap R <ESC>:<C-U>%s/<C-R>=VStar()<CR>/<C-R>=VStar()<CR>/cg

" Replace in current file
xnoremap R <ESC>:<C-U>%s/<C-R>=VStar()<CR>/<C-R>=VStar()<CR>/cg
nnoremap R :<C-U>%s/<C-R><C-W>/<C-R><C-W>/cg
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

"    Plug 'ludovicchabant/vim-gutentags'
"    " wildignore affects gutentags root finder !
"    let g:gutentags_project_root = ['setup.py']
"
"    let g:gutentags_file_list_command = {
"                             \ 'markers': {
"                                 \ '.git': 'git ls-files',
"                                 \ '.hg': 'hg files',
"                                 \ }
"                            \ } 
"    let g:gutentags_trace = 1
    set tags=./tags,tags,~/.config/nvim/tags
    
    set cpo += "d"

endif

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
set wildignore=*.lm,*.vocab,*.gz
set wildignore+=*.o,*.out,*.obj,*.rbc,*.rbo,*.class,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*.swp,*~,._*
"set wildmode=longest,list,full

" Autocomplete commands using nice menu in place of window status.
" Enable `Ctrl-N` and `Ctrl-P` to scroll through matches.
set wildmenu

" For autocompletion, complete as much as you can.
set wildmode=longest,full
if has("nvim")

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neoinclude.vim',{ 'tag': '*' }


let g:deoplete#enable_at_startup = 1
let g:clang_verbose_pmenu = 1
let g:clang_compilation_database = "./"
let g:clang_diagsopt = ''   " <- disable diagnostics
autocmd CompleteDone * pclose
elseif v:version >= 743
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
endif


" The command line is used to display echodoc text. This means that you will either need to set noshowmode or set cmdheight=2. Otherwise, the -- INSERT -- mode text will overwrite echodoc's text.
Plug 'Shougo/echodoc.vim'

""""""""""""""
"""" CPP Editing
"""""""""
if has("autocmd")
    " Enable file type detection
    filetype on
    autocmd BufNewFile,BufRead *.h setfiletype cpp
endif

Plug 'justmao945/vim-clang'
Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'sheerun/vim-polyglot'

Plug 'vim-syntastic/syntastic'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_checkers = ['cppcheck']

let g:syntastic_cpp_cppcheck_args= ['--std=c11','--language=c++']
let g:syntastic_cpp_remove_include_errors = 1
" let g:neomake_cpp_enabled_makers = ['clangck'']
" let g:neomake_cpp_clang_args = ['-std=c++14', '-Wextra', '-Wall', '-Wno-unused-parameter', '-g']

"let g:neomake_cpp_clang_args = ['-std=c++14', '-Wextra', '-Wall', '-Wno-unused-parameter', '-g']
let g:neomake_cpp_clangcheck_args = ['-extra-arg', '-fno-modules']

let g:neomake_cpp_cppcheck_args= ['--std=c11','--language=c++']

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

""""""
" JavaScript Syntax
Plug 'pangloss/vim-javascript'
if executable('npm')
" TODO tern needs to be installed globally
Plug 'ternjs/tern_for_vim', { 'do': 'npm install tern' }
if has('nvim')
Plug 'carlitux/deoplete-ternjs'
endif
endif

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
let g:lexical#thesaurus_key = '<leader>t'

au Filetype tex set makeprg=latexmk\ -f\ -pdf\ %
au Filetype bib set makeprg=latexmk\ -f\ -pdf\ %
"Reformat paragraph endlines
nnoremap <Leader>= gwip

" For proofreading
Plug 'reedes/vim-wordy'


Plug 'lervag/vimtex'

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
Plug 'vim-airline/vim-airline-themes'

"let g:airline_powerline_fonts = 1
let g:airline_theme='jellybeans'
"let g:airline_section_x = '%{PencilMode()}'

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

Plug 'bling/vim-bufferline'
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#bufferline#overwrite_variables = 1
let g:bufferline_show_bufnr = 0
let g:bufferline_rotate = 1
let g:bufferline_echo = 0
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
