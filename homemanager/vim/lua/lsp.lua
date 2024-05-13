---------------
-- lsp config --
----------------
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
  Spell = "",
  String = "",
  Copilot = "",
  Comment = "",
  TextTitle1 = "",
  TextTitle2 = "",
  TextTitle3 = "",
}

local cmp = require'cmp'

require'cmp'.setup {
  performance = {
    throttle = 100,
    fetching_timeout = 50,
    debounce = 20,
    async_budget = 1,
    max_view_entries = 50
  },
  sources = cmp.config.sources({
     { name = 'treesitter' },
     { name = 'nvim_lsp' },
     { name = 'buffer' },
     { name = 'path' },
     { name = 'vsnip' },
   }),
  formatting = {
      format = function(entry, vim_item)
        vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
        vim_item.menu = ({
          buffer = "📝",
          cmdline = " ",
          cmdline_history = "history",
          fuzzy_buffer = " Fuzzy",
          nvim_lsp = "LSP",
          nvim_lsp_document_symbol = "LSP",
          path = "PATH",
          otter = " Otter",
          pandoc_references = " Pandoc",
          rg = " Search",
          tags = "笠Tags",
          treesitter = " Tree",
          tmux = " Tmux",
          luasnip = " Snippet",
          look = " Spell",
          copilot = " Copilot",
        })[entry.source.name]
        return vim_item
  end

}}

cmp.setup.cmdline('/', {
  -- Disable all of the prior settings for nvim-cmp
  -- so that completion supported by luasnip not triggered;
  -- note that if this extra line is not added then
  -- tab completion does not work for this mode
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'buffer', max_item_count = 5, priority = 10},
    {name = 'fuzzy_buffer', max_item_count = 5, priority = 5},
  }, {
      {name = 'cmdline'},
    })
})
-- Use completion sources when backward-searching with "?"
cmp.setup.cmdline('?', {
  -- Disable all of the prior settings for nvim-cmp
  -- (see previous note for full explanation)
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'buffer', max_item_count = 5},
    {name = 'fuzzy_buffer', max_item_count = 5, priority = 5},
  }, {
          {name = 'cmdline'},
        })
    })
require'cmp'.setup.cmdline(':', {
  -- Disable all of the prior settings for nvim-cmp
  -- (see previous note for full explanation)
  mapping = cmp.mapping.preset.cmdline(),
  -- Use both the cmdline source (i.e., all valid
  -- commands) and the cmdline_history source (i.e.,
  -- all commands previously used in command prompt)
  sources = cmp.config.sources({
    {name = 'cmdline', max_item_count = 5},
    {name = 'cmdline_history', max_item_count = 5}
  }, {
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()


function noFloatingWins()
   for _, win in ipairs(vim.api.nvim_list_wins()) do
       local width = vim.api.nvim_win_get_width(win)
       local height = vim.api.nvim_win_get_height(win)
       if width > 0 and height > 0 then
           return true 
       end

   end
   return false
end

open_diag = function ()
  if noFloatingWins() then
  vim.diagnostic.open_float(nil, opts)
  end
end

vim.o.updatetime = 320
vim.cmd [[ autocmd! CursorHold,CursorHoldI * lua open_diag() ]]

vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = false,
  update_in_insert = false,
  severity_sort = false,
})


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '"', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>h', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      if noFloatingWins() then
       vim.diagnostic.open_float(nil, opts)
      end
    end
  })

end

local lsp_flags = {
  debounce_text_changes = 150,
}

require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}

require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}

require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
      ["rust-analyzer"] = {}
    }
}

require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

require'lspconfig'.cssls.setup {
  capabilities = capabilities,
}

require'lspconfig'.bashls.setup{
  capabilities = capabilities,
}

require'lspconfig'.jsonls.setup {
  capabilities = capabilities,
}

require'lspconfig'.nil_ls.setup{}

-- require'lspconfig'.nixd.setup{}
----------------------
-- nvim-treesitter --
-----------------------

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "<leader>[",
      scope_incremental = "gnm",
      node_decremental = "<leader>]",
    },
  },
}


----------------------
-- float colors -- 
-----------------------

vim.api.nvim_set_hl(0, 'NormalFloat', {bg='#6e7c8c', fg='#081019'})
vim.api.nvim_set_hl(0, 'FloatBorder', {bg='#289173' })


----------------------
-- tshjkl -- 
-----------------------

require('tshjkl').setup {
  keymaps = {
    toggle = '<C-w>',
    toggle_outer = '<S-C-w>',

    parent = 'h',
    next = 'j',
    prev = 'k',
    child = 'l',
    toggle_named = '<S-M-n>', -- named mode skips unnamed nodes
  }

}




--



