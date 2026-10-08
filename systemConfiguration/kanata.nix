{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      # grab mice too so their motion and the emitted mfwd come from the same
      # "kanata" device, which sway's on_button_down scrolling requires
      extraDefCfg = "linux-device-detect-mode any";
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
