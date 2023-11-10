let
  white = "#F9F9F9";
  black = "#282430";
  compose = f: g: x: f (g x);
  file = ./brogrammer.json;
  colors = compose builtins.fromJSON builtins.readFile file;
in
with colors; {
  main = base0B;
  secondary = base00;
  accent = base00;
  accent2 = base00;
  accent3 = base05;
  urgent = base03;
  grey = base08;
  debug = base0E;
}
