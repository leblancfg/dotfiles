" leblancfg, Aug 2016.

" Show hybrid relative line numbers
set relativenumber
set number

filetype plugin indent on


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set custom maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
let maplocalleader="\\"
" Copy-paste, works with Cygwin and mouse-enabled X Server on Linux
map <leader>y "*y
map <leader>p "*p

" Map Ctrl-j & Ctrl-k to move lines around
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Easier .vimrc refresh
nmap <Leader>r :so $MYVIMRC<CR>

" Run tests from leader-space
nmap <Leader><Space> :!pytest tests.py<CR>

" Handy way to insert UTC timestamp
nmap <Leader>d :r! date "+\%Y-\%m-\%d \%H:\%M:\%S"<CR>

" Markdown to PDF and launch
map <Leader>z :w<CR> :AsyncRun pandoc % -o %:r.pdf --variable urlcolor=cyan && start %:r.pdf<CR>


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

" vim-sensible - Vim keybindings everyone can agree on.
Plug 'tpope/vim-sensible'

" vim-orgmode - Note taking and well, everything.
Plug 'reedes/vim-pencil'

" AsyncRun
 Plug 'skywind3000/asyncrun.vim'

" - Markdown for vim
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'

" Tim Pope extravaganza
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'

" vim-flake8 - Python static syntax, style check, and complexity measures.
Plug 'nvie/vim-flake8', { 'for': 'python' }

" Prose - Wordy
Plug 'reedes/vim-wordy'

" Vim Jedi - Python autocompletion
" Commented out because too buggy? 
" Plug 'davidhalter/jedi-vim'

" Add plugins to &runtimepath
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug-in specific configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No folding for MD files
let g:vim_markdown_folding_disabled = 1

" Open NERDTree with C-N
map <C-n> :NERDTreeToggle<CR>


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
