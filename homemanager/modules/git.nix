{ host, ... }:
let user = (import ../../user.nix).${host}; in
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = { side-by-side = true; };
    };
    aliases = {
      amend = "commit --amend -m";
      fixup = "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      dif = "diff -- . ':(exclude)yarn.lock' ':(exclude)package-lock.json'";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      color.diff-highlight.newNormal = "68 bold";
      color.diff-highlight.newHighlight = "27 bold";
      init.defaultBranch = "master";
    };
    ignores = [
      "*.direnv"
    ];
    userEmail = user.email;
    userName = user.handle;
  };
}
