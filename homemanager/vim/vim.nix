{ pkgs, lib, config, user, ... }:

let
  pathToVimSnippets = "~/Public/snippets/";
  ifThenElse = x: y: z: (if x then y else z);
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
    ];

    plugins = (with pkgs.vimPlugins; [
      ale
      auto-pairs
      colorizer
      emmet-vim
      editorconfig-vim
      fzf-vim
      markdown-preview-nvim
      nerdtree
      neoterm
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
      vim-prettier
      vim-tmux-navigator
      vim-vue
      vimproc
      vim-gitgutter
      nvim-treesitter
      nvim-lspconfig
      completion-nvim
    ]) ++ [
      pkgs.coc-nvim-fixed
    ];


    extraConfig = ''
      set t_Co=256
      set background=light
      colorscheme PaperColor
      ${builtins.readFile ./vim.vim}
      nnoremap <leader>s :r ${pathToVimSnippets}
      ${builtins.readFile (ifThenElse user.isDarwin ./mac.vim ./linux.vim) }
      ""
      set completeopt=menu,menuone,noselect
      lua <<EOF
      ${builtins.readFile ./vim.lua}
      EOF
    '';
  };
  xdg.configFile."nvim/parser/javascript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
  xdg.configFile."nvim/parser/typescript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
  xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";

  home.packages = with pkgs.nodePackages; [
    # coc-tsserver
    # coc-css
    # coc-json
  ];

  #writes to file
  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON (import ./coc-settings.nix);
  xdg.configFile."nvim/coc-file.vim".source = ./cocfile.vim;
}

