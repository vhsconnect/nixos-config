inputs:
let
  p2111 = import inputs.nixpkgs-2111 { system = builtins.currentSystem; };
  unstable = import inputs.nixpkgs-unstable { system = builtins.currentSystem; };

  exa-overlay = self: prev: { exa = p2111.exa; };

  ollama-overlay = self: prev: { ollama = unstable.ollama; };

  leap-nvim-overlay = self: prev: {
    leap-nvim = prev.vimUtils.buildVimPlugin {
      pname = "leap.nvim";
      version = "2022-10-01";
      src = prev.fetchFromGitHub {
        owner = "ggandor";
        repo = "leap.nvim";
        rev = "5a09c30bf676d1392ff00eb9a41e0a1fc9b60a1b";
        sha256 = "xmqb3s31J1UxifXauBzBo5EkhafBEnq2YUYKRXJLGB0=";
      };

      meta.homepage = "https://github.com/ggandor/leap.nvim/";
    };
  };

  codeium-overlay = self: prev: {
    _codeium = prev.vimUtils.buildVimPlugin {
      name = "codeium.vim";
      version = "1.2.26";
      src = prev.fetchFromGitHub {
        owner = "Exafunction";
        repo = "codeium.vim";
        rev = "b7946996e1f34fff4f3adb639c0fb5bffc157092";
        sha256 = "gc4BP4ufE6UPJanskhvoab0vTM3t5b2egPKaV1X5KW0=";
      };
      patches = [ ../patches/codeium-vim.patch ];
      meta = {
        description = "Free, ultrafast Copilot alternative for Vim and Neovim";
        homepage = "https://codeium.com/";
      };
    };
  };

  coc-nvim-overlay = self: prev: {
    coc-nvim-fixed = prev.vimUtils.buildVimPlugin {
      pname = "coc.nvim";
      version = "2021-09-04";
      src = prev.fetchFromGitHub {
        owner = "neoclide";
        repo = "coc.nvim";
        rev = "0d84bcdec47bcef553b54433bf8372ca4964a7f9";
        sha256 = "0zz6lbbvrm3jx8yb096hb3jd4g4ph4abyrbs2gwv39flfyw9yqjp";
      };
      meta.homepage = "https://github.com/neoclide/coc.nvim/";
    };
  };
in
[
  exa-overlay
  coc-nvim-overlay
  leap-nvim-overlay
  codeium-overlay
  ollama-overlay
]
