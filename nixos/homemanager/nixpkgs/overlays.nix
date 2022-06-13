let

  neovim-nightly-overlay = import (builtins.fetchTarball {
    url = https://github.com/vhsconnect/neovim-nightly-overlay/archive/master.tar.gz;
  });

  coc-nvim-overlay = self: prev:
    {
      coc-nvim-fixed = prev.vimUtils.buildVimPluginFrom2Nix {
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
[ neovim-nightly-overlay coc-nvim-overlay ]
