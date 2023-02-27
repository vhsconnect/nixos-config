vim.g["ale_sign_error"] ='🦈'
vim.g["ale_sign_warning"] ='⚡️'
vim.g["ale_lint_on_insert_leave"] = 0
vim.g["ale_lint_on_enter"] = 0
vim.g["ale_fix_on_save"] = 1
vim.g["ale_lint_on_save"] = 1
vim.g["ale_set_highlights"] = 1
vim.g["ale_lint_on_text_changed"] = 1
-- vim.g["g:ale_fixers"] = {
--   nix: ['nixpkgs-fmt'],
--   haskell: ['hlint', 'ormolu', 'hindent', 'floskell'],
--   python: ['yapf'],
-- }

vim.g.ale_fixers = {nix = {'nixpkgs-fmt'}, rust = {'rustfmt'}}
