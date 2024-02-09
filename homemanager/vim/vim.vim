let g:mapleader = " "
packloadall
syntax enable
set nocompatible
set nobackup
set nowritebackup
set hidden
set nu rnu
set updatetime=300
set noshowmode
set cursorline
set autoindent
set autoread
set incsearch
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set shiftwidth=2
set smartindent
set mouse=
set autowrite
set inccommand=split
set foldmethod=expr
set foldnestmax=10
set foldlevel=2
set tabstop=2
set shiftwidth=2
set expandtab
set cmdheight=2
set shortmess+=c
set signcolumn=auto
set dictionary+=~/Public/words.txt
set complete+=k
set dir=~/Public/tmp
set laststatus=3
set completeopt=menu,menuone,noselect
set noswapfile
retab!


" ----------- Auto Pairs ----------
let g:AutoPairsShortcutToggle = '<M-P>'
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"`", '```':'```', '"""':'"""', "'''":"'''"}


nnoremap <leader>s :r ~/Public/snippets/

"----------- global subs with confirm ------------
nnoremap <space>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <space>R :%s/\<<C-r><C-w>\>//gci<Left><Left><Left><Left>
vnoremap <space>r y :%s/<C-r>"//gc<Left><Left><Left>


" --------------- NERDTREE --------------
let NERDTreeShowHidden = 1

" --------------- FZF --------------
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
"  redefine Ag to not include filenames in search
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" --------------- REMAPS FZF --------------
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)
nnoremap <silent> <c-p> :GFiles<CR>
" TODO Search open buffers with ag
nnoremap <leader>p :BLines<CR>
nnoremap <space>b :Buffer<CR>
nnoremap <silent> <c-g> :Ag<CR>
inoremap <expr> <c-x><c-f> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . expand("%:h"))

