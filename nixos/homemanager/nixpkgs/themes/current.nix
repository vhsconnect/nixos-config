let
  user = (import ../../../../user.nix);
in
{
  theme = import (builtins.toPath "${user.pathToHomeManagerConfigDir}/themes/${user.theme}.nix");
}
