let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = [pkgs.nodePackages.pyright pkgs.python311];
  }
