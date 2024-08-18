{ pkgs, config, ... }:
{
  users.users.vhs.home = "/Users/vhs";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ ];

  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages =
    with pkgs;
    let
      myPy3Packages =
        python-packages: with python-packages; [
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
      gnupg
      htop
      jq
      nmap
      neovim
      nodejs_20
      #docker-compose
      #docker
      ponysay
    ];

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
}
