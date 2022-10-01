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
