
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
    set ttymouse=xterm2
end

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

" Map Ctrl-j & Ctrl-k to move lines around
" nnoremap <C-j> :m .+1<CR>==
" nnoremap <C-k> :m .-2<CR>==
" inoremap <C-j> <Esc>:m .+1<CR>==gi
" inoremap <C-k> <Esc>:m .-2<CR>==gi
" vnoremap <C-j> :m '>+1<CR>gv=gv
" vnoremap <C-k> :m '<-2<CR>gv=gv

" Easier .vimrc refresh
nmap <Leader><C-r> :so $MYVIMRC<CR>

" TODO: probably just remove
" Run tests from leader-space
" nmap <Leader><Space> :w<CR> :!pytest -qq<CR>

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
" map <Leader>z :w<CR> :AsyncRun pandoc % -o %:r.pdf --toc --highlight-style zenburn --variable urlcolor=cyan && start %:r.pdf<CR>

" Pandoc metadata block header
let g:metadataBlock="---\n
\title: Insert Title Here\n
\author: François Leblanc\n
\date: \n
\..."
map <Leader>m ggm`O<ESC> :put =metadataBlock<CR> ggd2djfI

" New checkmarked line
nmap <leader>c o* [ ]<Esc><<A

" Force reload all windows (e.g. on changing git branches)
nmap <leader>b :silent! windo! e<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ----- vim-plug -----
" See if it's installed, else fetch it
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Start plugin manager section
call plug#begin('~/.vim/plugged')

" NERDtree - file explorer
Plug 'scrooloose/nerdtree'

" Make splits fullscreen and back
Plug 'itspriddle/ZoomWin'

" AsyncRun - do stuff in the background
Plug 'skywind3000/asyncrun.vim'

" Prose and Markdown
Plug 'reedes/vim-pencil'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'reedes/vim-wordy'

" Tim Pope extravaganza
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

"" Python
" vim-flake8 - Python static syntax, style check, and complexity measures.
" Plug 'nvie/vim-flake8', { 'for': 'python' }
" Plug 'psf/black'
"Plug 'davidhalter/jedi-vim'
Plug 'dense-analysis/ale'
Plug 'alfredodeza/pytest.vim'
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

" Finder
Plug 'kien/ctrlp.vim'

" Fancy glyphs
Plug 'ryanoasis/vim-devicons'

" vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'

" Auto resize the panes based on pointer
Plug 'roman/golden-ratio'

" Auto CTags
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'

" Add plugins to &runtimepath
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug-in specific configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No folding for MD files
let g:vim_markdown_folding_disabled = 1

" Open NERDTree with C-N
map <C-n> :NERDTreeToggle<CR>

" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" Remove trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Autoformat Python with Black
nnoremap <F6> :Black<CR>

" Testing pytest.vim
nmap <Leader>f :wa<CR>:Pytest file -m "not slow"<CR>
nmap <Leader>F :wa<CR>:Pytest session<CR>

" ALE
let g:ale_linters = {
\   'python': ['pylint', 'mypy'],
\}

let g:ale_fixers = {
\   'python': ['black'],
\}
let g:ale_fix_on_save=1
map <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

" tagbar
map <leader>t :TagbarToggle<CR>
let g:tagbar_show_linenumbers=1

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
