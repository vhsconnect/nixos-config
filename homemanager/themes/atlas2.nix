let
  white = "#F9F9F9";
  black = "#282430";
  horseradishYellow = "#A4CC3C";
  compose =
    f: g: x:
    f (g x);
  file = ./atlas.json;
  colors = compose builtins.fromJSON builtins.readFile file;
in
with colors;
{
  main = base0C;
  secondary = horseradishYellow;
  accent = base06;
  accent2 = base08;
  accent3 = base00;
  urgent = base0A;
  gray = base06;
  grey = base06;
  debug = base08;
}
