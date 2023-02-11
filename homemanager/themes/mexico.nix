let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  colors = compose builtins.fromJSON builtins.readFile ./mexico.json;
in
with colors;
{
  main = base0A;
  secondary = base08;
  accent = base01;
  accent2 = base0C;
  accent3 = base0D;
  urgent = base0F;
  grey = base0E;
  debug = base0F;
}
