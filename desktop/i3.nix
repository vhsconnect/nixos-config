{ pkgs, user, ... }:
{
  services.xserver.windowManager.i3 = {
    enable = if user.usei3 then true else false;
    extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock
      i3blocks
    ];
  };
}
