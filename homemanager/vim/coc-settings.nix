{
  "languageserver" = {
    "nix" = {
      "command" = "rnix-lsp";
      "filetypes" = [ "nix" ];
    };
    "bash" = {
      "command" = "bash-language-server";
      "args" = [ "start" ];
      "filetypes" = [ "sh" "bash" "zsh" ];
      "ignoredRootPaths" = [ "~" ];
    };
    "haskell" = {
      "command" = "haskell-language-server-wrapper";
      "args" = [ "--lsp" ];
      "rootPatterns" = [
        "*.cabal"
        "stack.yaml"
        "cabal.project"
        "package.yaml"
        "hie.yaml"
      ];
      "filetypes" = [ "haskell" "lhaskell" ];
    };
  };
  "yank.highlight.duration" = 700;

  "coc.preferences.extensionUpdateCheck" = "never";
  "coc.preferences.formatOnSaveFiletypes" = [ ];
  "prettier.semi" = false;
  "prettier.singleQuote" = true;
  "prettier.arrowParens" = "avoid";
}
