{ pkgs, ... }:
let
  ttheme1 = pkgs.writeScriptBin "ttheme1" ''
    #! /usr/bin/env bash
    CURRENT=$(${pkgs.ag}/bin/ag "profile =" --nonumbers ~/.config/terminator/config | xargs)
    X="profile = light"
    sed -i "s/$CURRENT/$X/" ~/.config/terminator/config
  '';
  ttheme2 = pkgs.writeScriptBin "ttheme2" ''
    #! /usr/bin/env bash
    CURRENT=$(${pkgs.ag}/bin/ag "profile =" --nonumbers ~/.config/terminator/config | xargs)
    X="profile = purple"
    sed -i "s/$CURRENT/$X/" ~/.config/terminator/config
  '';
  ttheme3 = pkgs.writeScriptBin "ttheme3" ''
    #! /usr/bin/env bash
    CURRENT=$(${pkgs.ag}/bin/ag "profile =" --nonumbers ~/.config/terminator/config | xargs)
    X="profile = dark"
    sed -i "s/$CURRENT/$X/" ~/.config/terminator/config
  '';
in
{
  home.packages = [ ttheme1 ttheme2 ttheme3 ];
}
