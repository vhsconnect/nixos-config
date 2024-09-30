{
  pkgs,
  inputs,
  user,
  ...
}:

let
  fintech = inputs.fintech.utils.${pkgs.system} {
    fintech = {
      mercurydb = {
        enable = true;
        awsProfile = "fintech";
        exportConnectionStringAs = "DBUI_URL";
        extraEnvVariables = {
          DBUI_NAME = "f-p";
        };
      };
      docs = {
        enable = true;
        path = (user.homeDir "office") + "/Repos/fintech-shareware";
        alias = "docs";
      };
    };
  };
in

{

  environment.systemPackages = [
    fintech.docs
    fintech.mercurydb
  ];

}
