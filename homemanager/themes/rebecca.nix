let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  colors = compose builtins.fromJSON builtins.readFile ./rebecca.json;
in
with colors;
{
  main = base03; # purple
  secondary = base05; #white
  accent = base0D; # teal
  accent2 = base0F; # pink
  accent3 = base07; # dark-grey
  urgent = base0F; # pink
  grey = base07;
  debug = base0A; # purple
}
