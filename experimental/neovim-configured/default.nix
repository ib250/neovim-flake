let
  pkgs = import <nixpkgs> {};
in
  import ./neovim-configured.nix {inherit pkgs;}
