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
      ale
      auto-pairs
      coc-nvim
      colorizer
      # ctrlp-vim
      emmet-vim
      editorconfig-vim
      fzf-vim
      haskell-vim
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


    " test >
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


    nmap <silent> <leader>dd <Plug>(coc-definition)
    nmap <silent> <leader>dt <Plug>(coc-type-definition)
    nmap <silent> <space>h <Plug>(coc-references)
    nmap <silent> <leader>di <Plug>(coc-implementation)
    nmap <leader>r <Plug>(coc-rename)
    nnoremap <silent> U :call <SID>show_documentation()<CR>
   
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction
  '';
}

