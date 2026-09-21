{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default.config = ''
      (defsrc
        lmet muhenkan
        a    s    d
      )

      (defalias
        win (one-shot 1000 (layer-while-held symbols))
        muhenkan (one-shot 1000 (layer-while-held symbols))
      )

      (deflayer base
        @win @muhenkan
        a    s    d
      )

      (deflayer symbols
        _ _
        S-lbrc S-9 lbrc
      )
    '';
  };
}
