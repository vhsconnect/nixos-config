{ ... }:

with builtins;
{
  fonts = [
    { Meslo = "MesloLG"; }
    { FiraCode = "FiraCode"; }
    { "0xProto" = "0xProto"; }
    { CommitMono = "CommitMono"; }
    { Hack = "Hack"; }
    { SpaceMono = "SpaceMono"; }
    { Iosevka = "Iosevka"; }
    { IosevkaTermSlab = "Iosevka"; }
    { JetBrainsMono = "JetBrainsMono"; }
    { VictorMono = "VictorMono"; }
    { EnvyCodeR = "EnvyCodeR"; }
    { Hermit = "Hurmit"; }
    { Lekton = "Lekton"; }
    { BitstreamVeraSansMono = "BitstromWera"; }
    { AurulentSansMono = "AurulentSansM"; }
    { AnonymousPro = "AnonymicePro"; }
    { GeistMono = "GeistMono"; }
    { RobotoMono = "RobotoMono"; }
  ];

  generateFontTemplate = font_name: ''
    [font.bold]
    family = "${font_name} Nerd Font"
    style = "Italic"

    [font.italic]
    family = "${font_name} Nerd Font"
    style = "Regular"

    [font.normal]
    family = "${font_name} Nerd Font"
    style = "Light"
  '';

}
