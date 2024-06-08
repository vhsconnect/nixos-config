let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  file = ./summerFruit.json;
  colors = compose builtins.fromJSON builtins.readFile file;
in
with colors; {
  main = base08; # pink
  secondary = base06; # white
  accent = base0D; # purplegray
  accent2 = base09; # yellow
  accent3 = black;
  urgent = base0E;
  gray = base06;
  grey = base06;
  debug = base0B;
}
