{ ... }:
{
  fonts = [
    { _0xproto = "0xProto"; }
    { anonymice = "AnonymicePro"; }
    { atkynson-mono = "AtkynsonMono"; }
    { aurulent-sans-mono = "AurulentSansM"; }
    { bitstream-vera-sans-mono = "BitstromWera"; }
    { caskaydia-mono = "CaskaydiaMono"; }
    { commit-mono = "CommitMono"; }
    { envy-code-r = "EnvyCodeR"; }
    { fira-code = "FiraCode"; }
    { fira-mono = "FiraMono"; }
    { geist-mono = "GeistMono"; }
    { hack = "Hack"; }
    { hurmit = "Hurmit"; }
    { iosevka = "Iosevka"; }
    { iosevka-term-slab = "Iosevka"; }
    { jetbrains-mono = "JetBrainsMono"; }
    { lekton = "Lekton"; }
    { meslo-lg = "MesloLG"; }
    { roboto-mono = "RobotoMono"; }
    { space-mono = "SpaceMono"; }
    { victor-mono = "VictorMono"; }
    { zed-mono = "ZedMono"; }
  ];

  generateFontTemplate = font_name: ''
    [font.bold]
    family = "${font_name} Nerd Font"

    [font.italic]
    family = "${font_name} Nerd Font"

    [font.normal]
    family = "${font_name} Nerd Font"

    [font.bold_italic]
    family = "${font_name} Nerd Font"
  '';

}
