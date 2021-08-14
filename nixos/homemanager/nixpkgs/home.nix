{ pkgs, lib, config, ... }:
let
  green = "#34eb74";
  yello = "#ebcf34";
  white = "#ffffff";
  black = "#000000";
  gray = "#b8b6bf";
  royalblue = "#3264a8";
  brown = "#664307";
  pink = "#db5e99";
  purple = "#410f7a";
  pathToVimSnippets = "~/Public/snippets/";
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = [
    ./i3.home.nix
    ./dunst.home.nix
    ./rofi.home.nix
    ./i3blocks.home.nix
  ];


  ######## programs ########
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    aliases = {
      amend = "commit --amend -m";
      fixup = "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      init.defaultBranch = "master";
    };
    ignores = [
      "*.direnv"
    ];
    userEmail = "90valentin@gmail.com";
    userName = "vhsconnect";
  };

  programs.zsh = {
    localVariables = {
      SUDO_ASKPASS = "lxqt-openssh-askpass";
    };
  };

  programs.bat.enable = true;
  programs.tmux.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "find . -type d \( -path ./.dbus -o -path ./.cache -o -path ./.gvfs \) -prune -false -o -name '*'";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
  };

  programs.chromium.enable = true;

  ######## home ########
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "xfce4-terminal";
    SUDO_ASKPASS = "lxqt-openssh-askpass";
  };

  home.username = "vhs";
  home.homeDirectory = "/home/vhs";


  ######## packages ########
  home.packages = with pkgs; [
    lxqt.lxqt-sudo
    lxqt.lxqt-openssh-askpass
    gksu

    networkmanagerapplet
    xfce.thunar
    terminator
    lxappearance
    qt5ct
    xss-lock
    awscli2

    rnix-lsp
    nix-doc
    nixpkgs-fmt

    gparted
    gimp
    signal-desktop
    sublime3
    sublime-merge

    audacious
    insomnia
    tdesktop

    gitAndTools.diff-so-fancy
    gitAndTools.tig

    exa
    acpi
    fd
    ag
    pastel
    prettyping
    tree
    zip
    xorg.xev
    unzip
    coreutils

    direnv


    pop-icon-theme
    vivid
    paper-icon-theme
    adapta-gtk-theme
    pop-gtk-theme
    arc-theme

    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "Iosevka"
        "Meslo"
        "3270"
        "Hack"
        "JetBrainsMono"
        "Agave"
        "Cousine"
      ];
    })

    font-awesome
    tldr
    mkcert
    hexchat
    slack
    teams
    mailspring
    thunderbird
  ];

  ######## neovim ########
  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      pynvim
    ]);
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

  ######## fonts ########
  fonts.fontconfig.enable = true;


  ######## services ########
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;

  services.xscreensaver = {
    enable = true;
    settings = {
      timeout = "30";
    };
  };

  services.screen-locker =
    {
      enable = true;
      inactiveInterval = 1;
      lockCmd = ''${pkgs.xscreensaver}/bin/xscreensaver-command -lock'';
    };

  #IMPORTANT
  home.stateVersion = "21.03";

}
