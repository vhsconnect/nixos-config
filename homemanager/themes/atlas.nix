let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  file = ./atlas.json;
  colors = compose builtins.fromJSON builtins.readFile file;
in
with colors;
{
  main = base0E; # purple
  secondary = base0D; # teal
  accent = base06; # purplegray
  accent2 = base0A; # yellow
  accent3 = black;
  urgent = base08;
  gray = base06;
  grey = base06;
  debug = base08;

}
