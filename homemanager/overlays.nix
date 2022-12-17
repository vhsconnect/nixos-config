inputs:
let
  packages-2111 = import inputs.nixpkgs-2111 {
    system = builtins.currentSystem;
  };

  neovim-nightly-overlay = import (builtins.fetchTarball {
    url = https://github.com/vhsconnect/neovim-nightly-overlay/archive/master.tar.gz;
    sha256 = "184lc8s5rpm9w2x7ygbwwzn4hsd0xidp8y6i9aqjkkdry4bv7l74";
  });

  insomnia-overlay = self: prev: {
    insomnia = packages-2111.insomnia;
  };

  leap-nvim-overlay = serlf: prev:
    {
      leap-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
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
[
  insomnia-overlay
  coc-nvim-overlay
  # neovim-nightly-overlay
  leap-nvim-overlay
]
