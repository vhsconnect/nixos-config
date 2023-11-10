let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  file = ./sandcastle.json;
  colors = compose builtins.fromJSON builtins.readFile file;
in
with colors; {
  main = base09;
  secondary = base07;
  accent = base06;
  accent2 = base0C;
  accent3 = base0C;
  urgent = base0E;
  grey = base04;
  debug = base05;
}
