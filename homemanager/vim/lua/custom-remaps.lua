vim.keymap.set('n', '<space>n', ':NvimTreeToggle<CR>', {noremap = true})
vim.keymap.set('n', '<space><leader>', ':tabnext<CR>', {noremap = true})
vim.keymap.set('n', '<leader><space>', ':tabprevious<cr>', {noremap = true})
vim.keymap.set('n', '<space>s', ':set spell<cr>', {noremap = true})
vim.keymap.set('n', '<space><space>s', ':set nospell<cr>', {noremap = true})
vim.keymap.set('n', '<space>l', ':PrettierAsync<cr>', {noremap = true})


vim.keymap.set('n', 'K', '5k', {noremap = true})
vim.keymap.set('n', 'J', '5j', {noremap = true})
vim.keymap.set('n', 'L', '10l', {noremap = true})
vim.keymap.set('n', 'H', '10h', {noremap = true})

-- move visual block up and down
vim.keymap.set('x', 'J', ':move \'>+1<CR>gv-gv', { noremap = true })
vim.keymap.set('x', 'K', ':move \'<-2<CR>gv-gv', { noremap = true })


-- move split into own tab
vim.keymap.set('n', '<leader><leader>', '<C-W>T',  { noremap = true })

-- leap
vim.keymap.set('n', 's', '<Plug>(leap-forward)',  { noremap = true })
vim.keymap.set('n', 'S', '<Plug>(leap-backward)',  { noremap = true })

-- staging
vim.keymap.set('n', '<space>u', ':tabdo e<CR>', {noremap = true})
vim.keymap.set('n', '<space>e', ':ALEDetail<CR>', {noremap = true})


-- require("which-key").register()
