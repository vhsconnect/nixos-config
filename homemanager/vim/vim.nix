{ pkgs, lib, config, user, ... }:

let
  pathToVimSnippets = "~/Public/snippets/";
  ifThenElse = x: y: z: (if x then y else z);
  toJSON = builtins.toJSON;
in
{
  #writes to file
  xdg.configFile =
    {
      "nvim/coc-settings.json".text = toJSON (import ./coc-settings.nix);
      "nvim/coc-file.vim".source = ./cocfile.vim; #uneeded
    };

  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = (with pkgs.vimPlugins; [
      ale
      auto-pairs
      colorizer
      emmet-vim
      editorconfig-vim
      fzf-vim
      markdown-preview-nvim
      neoterm
      papercolor-theme
      tcomment_vim
      tmuxline-vim
      tsuquyomi
      typescript-vim
      vim-colorschemes
      lualine-nvim
      vim-devicons
      vim-easy-align
      vim-fugitive
      vim-nix
      vim-prettier
      vim-tmux-navigator
      vim-vue
      vimproc
      vim-gitgutter
      vim-repeat
      yuck-vim

      nvim-tree-lua
      nvim-web-devicons
      nvim-surround

      # codeium-vim
      neodev-nvim

    ] ++ [
      pkgs.leap-nvim
    ]
    ++
    (if user.useCoc then [ ] else [
      # completion-nvim
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      vim-vsnip
    ])
    );

    extraConfig = ''
      set t_Co=256
      set background=light
      ${builtins.readFile ./vim.vim}
      nnoremap <leader>s :r ${pathToVimSnippets}
      ${builtins.readFile (ifThenElse user.isDarwin ./mac.vim ./linux.vim) }
      set completeopt=menu,menuone,noselect
      ${
        if user.useCoc 
        then (builtins.readFile ./cocfile.vim)
        else "\" using treesitter"
      }
      lua <<EOF
      ${if user.useCoc 
      then "-- using coc-nvim" 
      else (builtins.concatStringsSep "\n" (map builtins.readFile [ 
        ./lua/vim.lua 
        ./lua/lsp.lua 
        ./lua/ale.lua 
        ./lua/lualine.lua 
        ./lua/custom-remaps.lua
        ]))}
      EOF
    '';
  };

  home.packages =
    if user.useCoc then [
      pkgs.coc-nvim-fixed
      pkgs.nodePackages.coc-tsserver
      pkgs.nodePackages.coc-css
      pkgs.nodePackages.coc-json
    ] else [ ];
}

