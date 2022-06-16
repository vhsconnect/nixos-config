let
  user = (import ../../user.nix);
in
{
  theme = import (./. + "/${user.theme}.nix");
}
