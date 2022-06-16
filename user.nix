let
  user = (import ../user.nix); in
{
  efiBoot = user.efiBoot;
  mbrDevice = user.mbrDevice;
  email = user.email;
  handle = user.handle;
  theme = user.theme;
  foreground = user.foreground;
  font = user.font;
  secondaryFont = user.secondaryFont;
  liberaPass = user.liberaPass;
  liberaUser = user.liberaUser;
  pathToHomeManagerConfigDir = user.pathToHomeManagerConfigDir;
  withgtk = user.withgtk;
}
