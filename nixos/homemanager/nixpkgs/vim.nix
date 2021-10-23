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

  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON (import ./coc-settings.nix);
}

