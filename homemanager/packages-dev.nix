{ pkgs, ... }:
{
  ps = with pkgs; [
    lua54Packages.fennel
    clojure
    fennel-ls
    clojure-lsp
    gleam
    erlang_28
    dart
    android-studio
    sqlite
    duckdb
    prettier
    git-absorb

    # claude push to speak dep
    sox

  ];

}
