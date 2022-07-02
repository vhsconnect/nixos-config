let g:mapleader = "\\"
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
set mouse=a
set autowrite
set inccommand=split
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
set tabstop=2
set shiftwidth=2
set expandtab
set cmdheight=2
set shortmess+=c
set signcolumn=number
set dictionary+=~/Public/words.txt
set complete+=k
set dir=~/Public/tmp
retab!


" ----------- THEME ----------
" let g:dracula_italic = 0
colorscheme horseradish256
let g:airline_theme='hybrid'
" hi! Normal ctermbg=none


" ----------- highlighting ----------
highlight Visual ctermfg=238 ctermbg=84

" ----------- markdown preview ----------
let g:mkdp_auto_start = 1
let g:mkdp_refresh_slow = 1
let g:mkdp_browser = 'firefox'

" ----------- Auto Pairs ----------
let g:AutoPairsShortcutToggle = '<M-P>'

" ----------- copy to system clipboard ----------

function! ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

vnoremap <silent> <space>y y:call ClipboardYank()<cr>
vnoremap <silent> <space>d d:call ClipboardYank()<cr>
nnoremap <silent> <space>p :call ClipboardPaste()<cr>p
"copy the current visual selection to ~/.vbuf
vmap <y> :w! ~/.vbuf<CR>
"copy the current line to the buffer file if no visual selection
nmap <Y> :.w! ~/.vbuf<CR>
"paste the contents of the buffer file
nmap <p> :r ~/.vbuf<CR>

"-----------  snippets ------------
nnoremap <leader>s :r ~/Public/snippets/

"----------- global subs with confirm ------------
nnoremap <space>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <space>R :%s/\<<C-r><C-w>\>//gci<Left><Left><Left><Left>
vnoremap <space>r y :%s/<C-r>"//gc<Left><Left><Left>


" --------------- NERDTREE --------------
let NERDTreeShowHidden = 1

" --------------- REMAPS  MISC--------------
nnoremap <space>n :NERDTreeToggle<CR>
nnoremap <space>u :tabdo e<CR> "re-read from filesystem current tab
nnoremap <space><space>u :bufdo e<CR> "re-read from filesystem all
nnoremap <space>e :ALEDetail<CR>
nnoremap <space>g :call CocAction('jumpDefinition')<CR>
nnoremap <space><space>g :call CocActionAsync('jumpDefinition', 'tab drop')<CR>
nnoremap <space><leader> :tabnext<CR>
nnoremap <leader><space> :tabprevious<CR>
nnoremap <space>s :set spell<CR>
nnoremap <space><space>s :set nospell<CR>
nnoremap <space>l :PrettierAsync<CR>
nnoremap <space>b <C-W>z      "close info buffer
"close info buffer
nnoremap <space>b <C-W>z
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv
nnoremap K 5k
nnoremap J 5j
nnoremap L 10l
nnoremap H 10h
"move split to own tab
nnoremap <leader><leader> <C-W>T
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

" --------------- REMAPS COLORS --------------
nnoremap <space>1 :colorscheme OceanicNext<CR>
nnoremap <space>2 :colorscheme gruvbox<CR>
nnoremap <space>3 :colorscheme seoul256<CR>
nnoremap <space>4 :colorscheme zenburn<CR>
nnoremap <space>5 :colorscheme railscasts<CR>
nnoremap <space>6 :colorscheme kellys<CR>
nnoremap <space>7 :colorscheme seoul256-light<CR>
nnoremap <space>8 :colorscheme wikipedia<CR>
nnoremap <space>9 :colorscheme summerfruit256<CR>
nnoremap <space>0 :colorscheme PaperColor<CR>

" --------------- navigate splits --------------
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" --------------- ALE --------------
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_fixers = {
  \   '*': ['trim_whitespace'],
  \   'javascript': [],
  \   'typescript': [],
  \   'nix': ['nixpkgs-fmt'],
  \   'haskell': ['hlint', 'ormolu', 'hindent', 'floskell'],
  \   'python': ['yapf']
  \}
set omnifunc=ale#completion#OmniFunc
highlight ALEWarning ctermbg=Blue ctermfg=Yellow
highlight ALEError ctermbg=Blue ctermfg=White
let g:ale_sign_error = '🚨'
let g:ale_sign_warning = '⚡️'

" --------------- Airline --------------
let g:airline#extensions#ale#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = ''
let g:airline_section_a = ''
let g:airline_section_b = ''

" ---------------  TSUQOYOMI --------------
autocmd FileType typescript setlocal completeopt+=menu,preview
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

" ---------------  GitGutter --------------
let g:gitgutter_signs = 1
let g:gitgutter_sign_added = ""
let g:gitgutter_sign_modified = ""
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_removed_first_line = ''
let g:gitgutter_sign_removed_above_and_below = ''
let g:gitgutter_sign_modified_removed = ''


" ---------------  vue syntax highlighting | vim-vue --------------
let g:vue_pre_processors = 'detect-on-enter'
" ---------------  markdown --------------
let g:mkdp_auto_start = 0
" ---------------  COC --------------
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
source /home/$USER/.config/nvim/coc-file.vim
" ---------------  EXTRA --------------
call gitgutter#highlight#define_signs()

