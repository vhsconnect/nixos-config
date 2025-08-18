inputs:

let
  user = (import ../user.nix).iso;
  system = "x86_64-linux";
in

{
  system = "x86_64-linux";
  modules = [
    (
      { pkgs
      , modulesPath
      , lib
      , ...
      }:
      {

        imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.supportedFilesystems = lib.mkForce [
          "btrfs"
          "vfat"
          "xfs"
        ];

        nix = {
          package = pkgs.nixVersions.stable;
          registry = {
            nixpkgs = {
              flake = inputs.nixpkgs;
            };
            master = {
              flake = inputs.nixpkgs-master;
            };
          };
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
        };

        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "zsh-abbr"
          ];

        nixpkgs = {
          config.allowUnfree = true;
        };

        users.users.admin = {
          password = "admin";
          isNormalUser = true;
          uid = 1000;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
          shell = pkgs.zsh;
        };
        users.extraUsers.root.password = "admin";

        services.xserver = {
          enable = true;
          autoRepeatDelay = 200;
          autoRepeatInterval = 30;
          exportConfiguration = true;
          displayManager = {
            defaultSession = "none+i3";
          };
          desktopManager = {
            xterm.enable = true;
          };
          xkb.layout = "us";
          xkb.variant = "altgr-intl";
          deviceSection = ''
            Option "TearFree" "true"
          '';
          windowManager.i3.enable = true;
        };

        networking = {
          hostName = "installer";
          useDHCP = false;
          networkmanager.enable = true;
        };

        networking.wireless.enable = false;

        environment.systemPackages = with pkgs; [
          alacritty
          ghostty
          eza
          xorg.xmodmap
          firefox
          git
          magic-womrhole
          neovim
          curl
          arandr
          gparted
          networkmanagerapplet
          coreutils
          nixpkgs-fmt
          silver-searcher
          fd
          rofi
          (nerdfonts.override { fonts = [ "Hack" ]; })
        ];
        programs.zsh.enable = true;
      }
    )

    inputs.home-manager.nixosModules.home-manager
    ({

      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = false;
      home-manager.backupFileExtension = "hmback";
      home-manager.users.admin =
        { lib, config, ... }:
        {
          home = {
            username = lib.mkDefault "admin";
            homeDirectory = lib.mkDefault "/home/${config.home.username}";
            stateVersion = lib.mkDefault "24.11";
          };

          imports = [
            ../homemanager/zsh.nix
            ../homemanager/mimeappsList.nix
            ../homemanager/vim/vim.nix
            ../homemanager/i3/i3blocks.home.nix
            ../homemanager/i3/i3.home.nix
            ../homemanager/modules/dunst.home.nix
            ../homemanager/modules/rofi.home.nix
            ../homemanager/scripts/scripts.nix
            ../homemanager/scripts/templates.nix
          ];
        };
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit user;
        inherit system;
      };
    })

  ];
}
