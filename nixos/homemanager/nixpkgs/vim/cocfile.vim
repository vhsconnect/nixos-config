" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()


" test >
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dt <Plug>(coc-type-definition)
nmap <silent> <space>h <Plug>(coc-references)
nmap <silent> <leader>di <Plug>(coc-implementation)
nmap <leader>r <Plug>(coc-rename)
nmap <leader>rrr :CocCommand workspace.renameCurrentFile<CR>
nnoremap <silent> U :call <SID>show_documentation()<CR>

" get documentation under cursor
nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
