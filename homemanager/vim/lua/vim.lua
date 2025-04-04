function interop(str)
	local outer_env = _ENV
	return (
		str:gsub("%b{}", function(block)
			local code = block:match("{(.*)}")
			local exp_env = {}
			setmetatable(exp_env, {
				__index = function(_, k)
					local stack_level = 5
					while debug.getinfo(stack_level, "") ~= nil do
						local i = 1
						repeat
							local name, value = debug.getlocal(stack_level, i)
							if name == k then
								return value
							end
							i = i + 1
						until name == nil
						stack_level = stack_level + 1
					end
					return rawget(outer_env, k)
				end,
			})
			local fn, err = load("return " .. code, "expression `" .. code .. "`", "t", exp_env)
			if fn then
				return tostring(fn())
			else
				error(err, 0)
			end
		end)
	)
end
local x = os.getenv("VIM_THEME")

--------------
-- nvim-cmp --
--------------
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "vsnip" }, -- For vsnip users.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

------------------
-- leap
------------------

require("leap").setup({
	case_insensitive = true,
	-- Leaving the appropriate list empty effectively disables "smart" mode,
	-- and forces auto-jump to be on or off.
	-- These keys are captured directly by the plugin at runtime.
	special_keys = {
		repeat_search = "<enter>",
		next_match = "<enter>",
		prev_match = "<tab>",
		next_group = "<space>",
		prev_group = "<tab>",
		eol = "<space>",
	},
})

require("leap").init_highlight(true)

-- Searching in all windows (including the current one) on the tab page:
local function get_windows_on_tabpage()
	local t = {}
	local ids = string.gmatch(vim.fn.string(vim.fn.winlayout()), "%d+")
	for id in ids do
		t[#t + 1] = vim.fn.getwininfo(id)[1]
	end
	return t
end
function leap_all_windows()
	require("leap").leap({ ["target-windows"] = get_windows_on_tabpage() })
end

-- Bidirectional search in the current window is just a specific case of the
-- multi-window mode - set `target-windows` to a table containing the current
-- window as the only element:
function leap_bidirectional()
	require("leap").leap({
		["target-windows"] = { vim.fn.getwininfo(vim.fn.win_getid())[1] },
	})
end

-- Map them to your preferred key, like:
vim.keymap.set("n", "s", leap_all_windows, { silent = true })

------------------
-- neoterm
------------------
vim.g["neoterm_autoinsert"] = 1
vim.g["neoterm_default_mod"] = "vertical"
vim.keymap.set("n", "<c-q>", ":Ttoggle<CR>", { noremap = true })
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>:Ttoggle<CR>", { noremap = true })
vim.keymap.set("i", "<c-q> <Esc>", "<c-q>:Ttoggle<CR>", { noremap = true })

------------------
-- markdown
------------------

vim.g["mkdp_auto_start"] = 0
vim.g["mkdp_refresh_slow"] = 1
vim.g["mkdp_browser"] = "firefox"

------------------
-- colorscheme
------------------
vim.keymap.set("n", "<space>1", ":colorscheme OceanicNext<CR>", { noremap = true })
vim.keymap.set("n", "<space>2", ":colorscheme gruvbox<CR>", { noremap = true })
vim.keymap.set("n", "<space>3", ":colorscheme horseradish256<CR>", { noremap = true })
vim.keymap.set("n", "<space>4", ":colorscheme softblue<CR>", { noremap = true })
vim.keymap.set("n", "<space>5", ":colorscheme ailscasts<CR>", { noremap = true })
vim.keymap.set("n", "<space>6", ":colorscheme Tomorrow<CR>", { noremap = true })
vim.keymap.set("n", "<space>7", ":colorscheme lightning<CR>", { noremap = true })
vim.keymap.set("n", "<space>8", ":colorscheme seoul256-light<CR>", { noremap = true })
vim.keymap.set("n", "<space>9", ":colorscheme summerfruit256<CR>", { noremap = true })
vim.keymap.set("n", "<space>0", ":colorscheme PaperColor<CR>", { noremap = true })

------------------
-- navigation
------------------

vim.keymap.set("n", "<C-J>", ":TmuxNavigateDown<CR>", { noremap = true })
vim.keymap.set("n", "<C-K>", ":TmuxNavigateUp<CR>", { noremap = true })
vim.keymap.set("n", "<C-L>", ":TmuxNavigateRight<CR>", { noremap = true })
vim.keymap.set("n", "<C-H>", ":TmuxNavigateLeft<CR>", { noremap = true })

------------------
-- git gutter
------------------

vim.g["gitgtter_signs"] = 1
vim.g["gitgutter_sign_added"] = ""
vim.g["gitgutter_sign_modified"] = ""
vim.g["gitgutter_sign_removed"] = ""
vim.g["gitgutter_sign_removed_first_line"] = ""
vim.g["gitgutter_sign_removed_above_and_below"] = ""
vim.g["gitgutter_sign_modified_removed"] = ""
vim.api.nvim_call_function("gitgutter#highlight#define_signs", {})
------------------
-- vue vim
------------------
vim.g["vue_pre_processors"] = "detect-on-enter"

------------------
-- nvim-tree
------------------
require("nvim-tree").setup()

------------------
-- nvim-surround
------------------
require("nvim-surround").setup()
