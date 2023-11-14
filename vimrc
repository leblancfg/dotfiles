" Swapfiles are more trouble than they're worth
set noswapfile

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
    autocmd FileType cue set tabstop=4 shiftwidth=4 softtabstop=0 noexpandtab
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
" let maplocalleader="\\"
map <Bslash> gt

" Copy-paste, works with Cygwin and mouse-enabled X Server on Linux
map <leader>y "+y
map <leader>p "+p

" Avoid RSI writing ERB files
inoremap <C-l> <%<space>
inoremap <C-f> %><space>

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

" DBT expand <schema.table_name> to {{ source('schema', 'table_name') }}
function! ExpandString()
    " Check if the character on the left of the cursor isn't a space
    if getline('.')[col('.') - 2] !~ '\s'
        " Move the cursor to the beginning of the WORD
        execute "normal! B"
    endif

    execute "normal! i{{ source('"
    execute "normal! f.s', '"
    execute "normal! lea') }}"
    execute "normal! \<Esc>"
endfunction

nnoremap <leader>e :call ExpandString()<CR>

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

" Prose and Markdown
Plug 'reedes/vim-pencil', { 'for': 'markdown' }
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/vim-easy-align'

" Cuelang
Plug 'jjo/vim-cue'

" JS
Plug 'jxnblk/vim-mdx-js'
Plug 'pantharshit00/vim-prisma'
Plug 'ianks/vim-tsx'
 
" Tim Pope extravaganza
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'github/copilot.vim'
let g:copilot_filetypes = {
            \ 'markdown': ['markdown', 'gfm', 'md', 'mkd', 'mkdn', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'mdx', 'mk', 'ron', 'textile', 'txt'],
            \ }

"" Python
Plug 'dense-analysis/ale'
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

"" SQL
" Plug 'erhickey/bigquery-vim', { 'for': 'sql' }
" Plug 'mbhynes/vim-dadbod'
" Plug 'mbhynes/vim-dadbod-ui'

" Fancy glyphs
Plug 'ryanoasis/vim-devicons'

" vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'

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
" Projections
nnoremap <Leader>a :A<CR>
nnoremap <Leader>as :AS<CR>
nnoremap <Leader>av :AV<CR>
nnoremap <Leader>at :AT<CR>

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
\   'js': ['eslint'],
\   'python': ['ruff'],
\   'sql': ['sqlfluff'],
\   'yaml': ['yamllint'],
\}
let g:ale_python_auto_virtualenv = 1

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'python': ['black', 'isort'],
\   'ruby': ['rubocop'],
\   'sql': ['sqlfluff', 'remove_trailing_lines'],
\   'yaml': ['yamlfix'],
\}
let b:ale_sql_pgformatter_options = '--function-case 2 --keyword-case 2 --spaces 2 --no-extra-line'
let g:ale_yaml_yamllint_options = '-d "{extends: default, rules: {document-start: disable, line-length: disable, indentation: {indent-sequences: whatever}}}"'
map <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

" Lightline
set noshowmode
let g:lightline = { 
       \ 'colorscheme': 'srcery_drk',
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

" Vim-Tmux-Runner
nnoremap <leader>v- :VtrOpenRunner { "orientation": "v", "percentage": 30 }<cr>
nnoremap <leader>v\ :VtrOpenRunner { "orientation": "h", "percentage": 30 }<cr>
nnoremap <leader>vk :VtrKillRunner<cr>
"nnoremap <leader>va :VtrAttachToPane<cr>

nnoremap <leader>v0 :VtrAttachToPane 0<cr>:call system("tmux clock-mode -t 0 && sleep 0.1 && tmux send-keys -t 0 q")<cr>
nnoremap <leader>v1 :VtrAttachToPane 1<cr>:call system("tmux clock-mode -t 1 && sleep 0.1 && tmux send-keys -t 1 q")<cr>
nnoremap <leader>v2 :VtrAttachToPane 2<cr>:call system("tmux clock-mode -t 2 && sleep 0.1 && tmux send-keys -t 2 q")<cr>
nnoremap <leader>v3 :VtrAttachToPane 3<cr>:call system("tmux clock-mode -t 3 && sleep 0.1 && tmux send-keys -t 3 q")<cr>
nnoremap <leader>v4 :VtrAttachToPane 4<cr>:call system("tmux clock-mode -t 4 && sleep 0.1 && tmux send-keys -t 4 q")<cr>
nnoremap <leader>v5 :VtrAttachToPane 5<cr>:call system("tmux clock-mode -t 5 && sleep 0.1 && tmux send-keys -t 5 q")<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
noremap <leader>q :VtrSendLinesToRunner<cr>

nnoremap <leader>sq :VtrSendKeysRaw q<cr>
nnoremap <leader>sd :VtrSendKeysRaw ^U ^D<cr>
nnoremap <leader>ss :VtrSendKeysRaw ^U ^D<cr>:sleep 100m<cr>:VtrSendKeysRaw C-p C-m<cr>
nnoremap <leader>sl :VtrSendKeysRaw ^L<cr>
nnoremap <leader>sc :VtrSendKeysRaw ^C<cr>
nnoremap <leader>su  :VtrSendKeysRaw C-p C-m<cr>
nnoremap <leader>vs :VtrSendCommandToRunner<space>

" I'd rather not use a color scheme, but can't get decent colors when I run in
" tmux+iterm2
colorscheme base16-paraiso
hi VertSplit guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
set fillchars=vert:\│
" Don't overwrite the background color, use black foreground instead
hi Normal guibg=NONE ctermbg=NONE guifg=black ctermfg=black
