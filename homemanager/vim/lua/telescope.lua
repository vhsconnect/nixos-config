 require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "fd",
            },
          },
        }
      }

vim.keymap.set('n', "<leader>ff", "<cmd> Telescope find_files<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fg", "<cmd> Telescope live_grep<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fb", "<cmd> Telescope buffers<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fh", "<cmd> Telescope help_tags<CR>", {noremap = true})
vim.keymap.set('n', "<leader>ft", "<cmd> Telescope<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fvcw", "<cmd> Telescope git_commits<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fvcb", "<cmd> Telescope git_bcommits<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fvb", "<cmd> Telescope git_branches<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fvs", "<cmd> Telescope git_status<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fvx", "<cmd> Telescope git_stash<CR>", {noremap = true})
vim.keymap.set('n', "<leader>flsb", "<cmd> Telescope lsp_document_symbols<CR>", {noremap = true})
vim.keymap.set('n', "<leader>flsw", "<cmd> Telescope lsp_workspace_symbols<CR>", {noremap = true})
vim.keymap.set('n', "<leader>flr", "<cmd> Telescope lsp_references<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fli", "<cmd> Telescope lsp_implementations<CR>", {noremap = true})
vim.keymap.set('n', "<leader>flD", "<cmd> Telescope lsp_definitions<CR>", {noremap = true})
vim.keymap.set('n', "<leader>flt", "<cmd> Telescope lsp_type_definitions<CR>", {noremap = true})
vim.keymap.set('n', "<leader>fld", "<cmd> Telescope diagnostics<CR>", {noremap = true})
