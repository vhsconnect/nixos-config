let
  user = (import ../../user.nix);
in
host:
let
  userTheme = user.${host}.theme; in
{
  theme = import (./. + "/${userTheme}.nix");
}
