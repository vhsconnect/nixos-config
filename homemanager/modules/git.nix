{ user, lib, ... }:
{
  programs.git =
    let
      excludeFiles = [
        "yarn.lock"
        "package-lock.json"
        "flake.lock"
      ];
      difOptions = lib.strings.concatMapStrings (x: " ':(exclude)${x}'") excludeFiles;
    in
    {
      enable = true;
      delta = {
        enable = true;
        options = {
          side-by-side = true;
        };
      };
      aliases = {
        amend = "commit --amend -m";
        fixup = "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        dif = "diff -- .${difOptions}";
        sta = "stash --include-untracked";
        c = "commit -S";
      };
      extraConfig = {
        safe.directory = "*";
        core = {
          editor = "nvim";
        };
        color.diff-highlight.newNormal = "68 bold";
        color.diff-highlight.newHighlight = "27 bold";
        init.defaultBranch = "master";
        gpg.format = "ssh";
      };
      signing = {
        signByDefault = false;
        key = builtins.readFile "${user.homeDir}/.ssh/id_ed25519.pub";
      };
      ignores = [ "*.direnv" ];
      userEmail = user.email;
      userName = user.handle;
    };
}
