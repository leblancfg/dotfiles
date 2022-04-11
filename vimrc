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
" TODO: probably broken
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

" Force reload all windows (e.g. on changing git branches)
nmap <leader>b :silent! windo! e<CR>

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

" NERDtree - file explorer
Plug 'scrooloose/nerdtree'
" Finder
" Plug 'kien/ctrlp.vim'
" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'

" Make splits fullscreen and back with <ctrl>wo
Plug 'itspriddle/ZoomWin'

" AsyncRun - do stuff in the background
Plug 'skywind3000/asyncrun.vim'

" Prose and Markdown
Plug 'reedes/vim-pencil'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
 
" Tim Pope extravaganza
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'github/copilot.vim'
let g:copilot_filetypes = {
            \ 'markdown': ['markdown', 'gfm', 'md', 'mkd', 'mkdn', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'mdx', 'mk', 'ron', 'textile', 'txt'],
            \ }

"" Python
Plug 'dense-analysis/ale'
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
Plug 'AndrewRadev/splitjoin.vim'
let g:splitjoin_python_brackets_on_separate_lines = 1

" Fancy glyphs
Plug 'ryanoasis/vim-devicons'

" vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'

" Pair parens, etc.
" Plug 'jiangmiao/auto-pairs'

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

" Gitignore CtrlP - loads faster
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" No folding for MD files
let g:vim_markdown_folding_disabled = 1

" Open NERDTree with Ctrl-N
map <C-n> :NERDTreeToggle<CR>

" Open FZF
map <C-f> :Rg<CR>
map <C-p> :GitFiles<CR>

" Enable NERDline numbers
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

""" ALE
let g:ale_linters = {
\   'python': ['flake8'],
\}
let g:ale_python_flake8_options = '--ignore W503,E501'

let g:ale_fixers = {
\   'yaml': ['yamlfix'],
\   'sql': ['pgformatter'],
\   'python': ['black'],
\}
let b:ale_sql_pgformatter_options = '--function-case 2 --keyword-case 2 --spaces 2 --no-extra-line'
let g:ale_fix_on_save=1

map <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

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
colorscheme peachpuff

" Vimdiff colors are aweful
if &diff
  " colorscheme evening
  highlight DiffAdd    cterm=bold ctermfg=3 ctermbg=8 gui=none guifg=bg guibg=Red
  highlight DiffDelete cterm=bold ctermfg=3 ctermbg=8 gui=none guifg=bg guibg=Red
  highlight DiffChange cterm=bold ctermfg=3 ctermbg=8 gui=none guifg=bg guibg=Red
  highlight DiffText   cterm=bold ctermfg=3 ctermbg=4 gui=none guifg=bg guibg=Red
endif

" Refresh all panes with <leader>e
function! PullAndRefresh()
  set noconfirm
  bufdo e!
  set confirm
endfun

map <leader>e :call PullAndRefresh()<CR>

" Multipurpose tab key
" function! InsertTabWrapper()
"     let col = col('.') - 1
"     if !col || getline('.')[col - 1] !~ '\k'
"         return "\<tab>"
"     else
"         return "\<c-p>"
"     endif
" endfunction
" inoremap <expr> <tab> InsertTabWrapper()
" inoremap <s-tab> <c-n>
