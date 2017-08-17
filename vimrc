" leblancfg, Aug 2016.

" Show hybrid relative line numbers
set relativenumber
set number

filetype plugin indent on

" Themeing?
" colorscheme paraiso_dark

" Backup (~) files are a hassle, so keep them all in one spot instead.
" set backupdir=~/.vim/backup

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

" vim-sensible - Vim keybindings everyone can agree on.
Plug 'tpope/vim-sensible'

" vim-orgmode - Note taking and well, everything.
" Plug 'jceb/vim-orgmode'
" Plug 'tpope/vim-speeddating'
" Plug 'mattn/calendar-vim'
Plug 'reedes/vim-pencil'

" riv.vim - Restructured Text in Vim
" Plug 'Rykka/riv.vim'

" - Markdown for vim
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'

" Pandoc Markdown
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'

" slimux - Send commands to other tmux panes
Plug 'epeli/slimux'

" Tim Pope extravaganza
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'

" vim-flake8 - Python static syntax, style check, and complexity measures.
Plug 'nvie/vim-flake8', { 'for': 'python' }

" Vim Jedi - Python autocompletion
" Commented out because too buggy on cygwin; 
" TODO: wrap in if statement based on platform
" Plug 'davidhalter/jedi-vim'

" Add plugins to &runtimepath
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug-in specific configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No folding for MD files
let g:vim_markdown_folding_disabled = 1

" Curb riv.vim's folding ALL the things!
let g:riv_disable_folding = 1

" Force vim-orgmode to display leading stars in headers
let g:org_heading_shade_leading_stars = 0

" Taken from dvbuntu for slimux
" 'I have this built into the script, which is not
" what the original has'
nnoremap <C-x> :SlimuxREPLSendLine<CR>
vnoremap <Leader>x :SlimuxREPLSendLine<CR>
nnoremap <Leader>x :SlimuxREPLConfigure<CR>

" Use Enter as "Previous Command" in left tmux pane
nnoremap <CR> :!tmux send-keys -t right Up C-m <CR> <CR>

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

