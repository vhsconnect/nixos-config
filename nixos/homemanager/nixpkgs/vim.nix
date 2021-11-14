{ pkgs, lib, config, ... }:

let
  pathToVimSnippets = "~/Public/snippets/";
in
{

  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-gitgutter
      vim-nix
      vim-easy-align
      vim-fugitive
      vim-javascript-syntax
      emmet-vim
      vim-devicons
      nerdtree
      ale
      tcomment_vim
      vim-vue
      editorconfig-vim
      typescript-vim
      vim-tmux-navigator
      auto-pairs
      vimproc
      tsuquyomi
      haskell-vim
      fzf-vim
      vim-colorschemes
      papercolor-theme
      coc-nvim
    ];
    extraConfig = ''
      set t_Co=256
      set background=light
      colorscheme PaperColor
      ${builtins.readFile ./vim.vim}
      nnoremap <leader>s :r ${pathToVimSnippets}
    '';
  };

  #writes to file
  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON (import ./coc-settings.nix);
  xdg.configFile."nvim/coc-file.vim".text = ''
    " use <tab> for trigger completion and navigate to the next complete item
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()
  '';
}

