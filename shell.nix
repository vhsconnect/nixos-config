let
  sources = import ./nix/sources.nix;
  pinned = import sources.nixpkgs { };
in
pinned.mkShell {
  name = "system-build-shell";
  buildInputs = [ pinned.git-crypt ];
  shellHook = "ponysay \"hello world\"";
}
