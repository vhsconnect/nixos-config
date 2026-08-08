inputs: system:
let

  master = import inputs.nixpkgs-master { inherit system; };

  master-overlay = self: prev: {
    self.signal = master.signal;
    self.gleam = master.gleam;
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

in
[
  codeium-overlay
  master-overlay
]
