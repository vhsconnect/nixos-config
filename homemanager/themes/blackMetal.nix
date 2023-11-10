let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  colors = compose builtins.fromJSON builtins.readFile ./blackMetal.json;
in
with colors; {
  main = base01;
  secondary = base0A;
  accent = base08;
  accent2 = base0C;
  accent3 = base0D;
  urgent = base0F;
  grey = base0E;
  debug = base0F;
}
