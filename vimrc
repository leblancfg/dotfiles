" No search highlight
set nohls

" Show hybrid relative line numbers
set relativenumber
set number

" Show fancy glyphs
set encoding=UTF-8

" Mouse
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    if !has('nvim')
        set ttymouse=xterm2
    endif
endif

" Feiltypes?
filetype on
filetype plugin on

" Tabs are 4 spaces, natch.
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

" For everything else, use a tab width of 4 space chars.
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4.
set softtabstop=4   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.

" Reload indent file after each save
filetype plugin indent on

" Silent Running
command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

" Always reload the newest file, even if that means overwriting
set autoread

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set custom maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
let maplocalleader="\\"

" Copy-paste, works with Cygwin and mouse-enabled X Server on Linux
map <leader>y "+y
map <leader>p "+p

" Switch between previous buffer
nnoremap <leader><leader> <c-^>

" Toggle Paste for Insert mode
map <leader>p :set paste!<CR>

" Insert breakpoint
let g:breakpoint_str="# fmt: off\n
\import ipdb; ipdb.set_trace()  # noqa: E702, E402\n
\# fmt: on\n"
map <Leader>b m`O<ESC> :put =breakpoint_str<CR> 4kd2d2j0<Esc>

" Easier .vimrc refresh
nmap <Leader><C-r> :so $MYVIMRC<CR>

" Handy way to insert UTC timestamp
nmap <Leader>d :r! date "+\%Y-\%m-\%d"<CR>
nmap <Leader>D o## <Esc>:r! date "+\%Y-\%m-\%d"<CR>0i<BS><Esc>

" Search and replace word under cursor
nnoremap <Leader>S :%s/\<<C-r><C-w>\>/

" Edit vimrc
nmap <Leader>v :w<CR> :vsp ~/.vimrc<CR>

"""" Markdown """"
" Put an X in the checkmark on that line
nmap <leader>x 0f[lsX<Esc>

" Markdown to PDF and launch
map <Leader>z :w<CR> :AsyncRun pandoc % -o %:r.pdf --highlight-style zenburn --variable urlcolor=cyan && open %:r.pdf<CR>

" Pandoc metadata block header
let g:metadataBlock="---\n
\title: Insert Title Here\n
\author: François Leblanc\n
\date: \n
\..."
map <Leader>m ggm`O<ESC> :put =metadataBlock<CR> ggd2djfI

" New checkmarked line
nmap <leader>c o* [ ] <Esc><<A

" Create new tab
nmap <leader><space> :tabnew<CR>

" ALE
" Run Black on file
nmap <leader>f :ALEFix<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ----- vim-plug -----
" See if it's installed, else fetch it
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start plugin manager section
call plug#begin('~/.vim/plugged')

" IDE-like features
Plug 'rubik/vim-base16-paraiso'
Plug 'preservim/nerdtree'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'

" Make splits fullscreen and back with <ctrl>wo
Plug 'itspriddle/ZoomWin'

" Prose and Markdown
Plug 'reedes/vim-pencil', { 'for': 'markdown' }
Plug 'plasticboy/vim-markdown'
 
" Tim Pope extravaganza
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'github/copilot.vim'
let g:copilot_filetypes = {
            \ 'markdown': ['markdown', 'gfm', 'md', 'mkd', 'mkdn', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'mdx', 'mk', 'ron', 'textile', 'txt'],
            \ }

"" Python
Plug 'AndrewRadev/splitjoin.vim'
let g:splitjoin_python_brackets_on_separate_lines = 1
Plug 'dense-analysis/ale'
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

"" SQL
Plug 'erhickey/bigquery-vim'

" Fancy glyphs
Plug 'ryanoasis/vim-devicons'

" vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'

" Auto resize the panes based on pointer
Plug 'roman/golden-ratio'

" Replace with register
Plug 'vim-scripts/ReplaceWithRegister'

" Better tabs 
Plug 'itchyny/lightline.vim'

" Add plugins to &runtimepath
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug-in specific configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No folding for MD files
let g:vim_markdown_folding_disabled = 1

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber
let g:nerdtree_vis_confirm_open = 0
let NERDTreeIgnore=['\.git$', 'egg-info', 'dist-info', '__editable__', '__pycache__']

" Open FZF
map <C-f> :Rg<CR>
map <C-p> :GitFiles<CR>

""" ALE
let g:ale_fix_on_save=1
let g:ale_linters = {
\   'python': ['ruff', 'mypy'],
\   'sql': ['sqlint'],
\}
let g:ale_python_ruff_options = '--ignore E501'
let g:ale_fixers = {
\   'yaml': ['yamlfix'],
\   'sql': ['sqlfmt'],
\   'python': ['black', 'isort'],
\   'ruby': ['rubocop'],
\}
let b:ale_sql_pgformatter_options = '--function-case 2 --keyword-case 2 --spaces 2 --no-extra-line'
map <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

" BigQuery
" TODO: vmap to arbitrary filetypes
" execute the visual selection
vnoremap <buffer> <enter> :BQExecute<CR>
" execute the current paragraph
nnoremap <buffer> <enter> m'vap:BQExecute<CR>g`'

"lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'srcery_drk',
      \ }
let g:lightline = { 
       \ 'colorscheme': 'wombat',
       \ 'active': {
       \   'left': [ ['mode', 'paste'],
       \             ['fugitive', 'readonly', 'filename', 'modified'] ],
       \   'right': [ [ 'lineinfo' ], ['percent'] ]
       \ },
       \ 'component': {
       \   'readonly': '%{&filetype=="help"?"":&readonly?"\ue0a2":""}',
       \   'modified': '%{&filetype=="help"?"":&modified?"\ue0a0":&modifiable?"":"-"}',
       \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
       \ },
       \ 'component_visible_condition': {
       \   'readonly': '(&filetype!="help"&& &readonly)',
       \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
       \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
       \ },
       \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
       \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
       \ }

" I'd rather not use a color scheme, but can't get decent colors when I run in
" tmux+iterm2
colorscheme base16-paraiso
hi VertSplit guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
set fillchars=vert:\│
" Don't overwrite the background color
hi Normal guibg=NONE ctermbg=NONE
