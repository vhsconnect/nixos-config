{ pkgs, ... }: {
  services.xserver.windowManager.i3 = {
    package = pkgs.i3-gaps;
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock
      i3blocks
    ];
  };
}
windowManager





