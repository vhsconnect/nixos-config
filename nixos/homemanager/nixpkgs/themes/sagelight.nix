let
  black = "#F9F9F9"; #flipped
  white = "#282430"; #fliipped
  compose = f: g: x: f (g x);
  colors = compose builtins.fromJSON builtins.readFile ./sagelight.json;
in
with colors;
{
  main = base0B;
  secondary = base06;
  accent = base09;
  accent2 = base0C;
  accent3 = base0E;
  urgent = base0F;
  grey = base07;
  debug = base08;
}
