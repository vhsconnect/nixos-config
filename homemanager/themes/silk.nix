let
  compose =
    f: g: x:
    f (g x);
  file = ./silk.json;
  colors = compose builtins.fromJSON builtins.readFile file;
in
with colors;
{
  main = base08;
  secondary = base01;
  accent = base09;
  accent2 = base08;
  accent3 = base00;
  urgent = base0A;
  gray = base01;
  grey = base01;
  debug = base0B;
}
