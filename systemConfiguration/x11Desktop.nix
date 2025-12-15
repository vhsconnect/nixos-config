{ ... }:
{

  services.picom = {
    enable = true;
    vSync = true;
    inactiveOpacity = 0.96;
    fade = true;
    fadeDelta = 8;
    fadeSteps = [
      2.8e-2
      3.0e-2
    ];
  };

  programs.i3lock.enable = true;

}
