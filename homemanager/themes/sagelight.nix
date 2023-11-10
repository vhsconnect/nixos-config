let
  black = "#F9F9F9"; #flipped
  white = "#282430"; #fliipped
  compose = f: g: x: f (g x);
  colors = compose builtins.fromJSON builtins.readFile ./sagelight.json;
in
with colors; {
  main = base0F;
  secondary = base06;
  accent = base0C;
  accent2 = base0C;
  accent3 = base0B;
  urgent = base08;
  grey = base04;
  debug = base04;
}
