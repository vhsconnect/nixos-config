let
  white = "#F9F9F9"; #flipped
  black = "#282430"; #fliipped
  compose = f: g: x: f (g x);
  colors = compose builtins.fromJSON builtins.readFile ./brogrammer.nix;
in
with colors;
{
  main = base04;
  secondary = base03;
  accent = base00;
  accent2 = base01;
  accent3 = base0E;
  urgent = base0F;
  grey = base07;
  debug = base0A;
}
