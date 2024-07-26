{ pkgs, ... }:
{
  users.users.vhs.home = "/Users/vhs";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ ];

  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  # nix.package = pkgs.nix;
  nix.nixPath = [ "/nix/store/06698sliqs2bc33w87039s61r3162czv-nix-2.18.1" ];
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
      nodejs-18_x
      #docker-compose
      #docker
      ponysay
    ];

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
}
