{ config, pkgs, ... }:

{
  users.users.valentin.home = "/Users/valentin";
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;
  nix.nixPath = [ "darwin=/nix/store/lql1bfyxnzqadchvascc6vxj3gmj5dr9-nix-darwin" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs;
    let
      myPy3Packages = python-packages: with python-packages; [
        pandas
        pynvim
        virtualenv
      ];
      python3Plus = python3.withPackages myPy3Packages;
    in
    [
      python3Plus
      wget
      curl
      #  vlc
      gnupg
      htop
      jq
      nmap
      neovim
      nodejs-16_x
      #docker-compose
      #docker
      ponysay
    ];

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
}

