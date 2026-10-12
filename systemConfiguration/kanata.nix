{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      # grab mice too so their motion and the emitted mfwd come from the same
      # "kanata" device, which sway's on_button_down scrolling requires.
      # the thinkpad pointers are left alone: kanata can't relay the touchpad's
      # absolute events, and the trackpoint would lose its native middle-button scroll
      extraDefCfg = ''
        linux-device-detect-mode keyboard-mice
        linux-dev-names-exclude (
          "TPPS/2 Elan TrackPoint"
          "ELAN0676:00 04F3:3195 Mouse"
          "ELAN0676:00 04F3:3195 Touchpad"
        )
      '';
      config = ''
        (defsrc
          lmet muhenkan del
          a    s    d
        )

        (defalias
          scroll mfwd
          del (tap-hold-press 200 200 del (layer-while-held symbols))
        )

        (deflayer base
          @scroll @scroll @del
          a    s    d
        )

        (deflayer symbols
          _ _ _
          S-lbrc S-9 lbrc
        )
      '';
    };
  };
}
