{ pkgs, lib, config, ... }:

let
  pathToVimSnippets = "~/Public/snippets/";
in
{

  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      ale
      auto-pairs
      coc-nvim
      colorizer
      # ctrlp-vim
      emmet-vim
      editorconfig-vim
      fzf-vim
      # haskell-vim
      markdown-preview-nvim
      nerdtree
      papercolor-theme
      tcomment_vim
      tsuquyomi
      typescript-vim
      vim-colorschemes
      vim-airline
      vim-airline-themes
      vim-devicons
      vim-easy-align
      vim-fugitive
      vim-javascript-syntax
      vim-nix
      vim-tmux-navigator
      vim-vue
      vimproc
      vim-gitgutter
    ];
    extraConfig = ''
      set t_Co=256
      set background=light
      colorscheme PaperColor
      ${builtins.readFile ./vim.vim}
      nnoremap <leader>s :r ${pathToVimSnippets}
    '';
  };

  home.packages = with pkgs.nodePackages; [
    coc-tsserver
    coc-prettier
    coc-css
    coc-json
  ];

  #writes to file
  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON (import ./coc-settings.nix);
  xdg.configFile."nvim/coc-file.vim".source = ./cocfile.vim;
}

