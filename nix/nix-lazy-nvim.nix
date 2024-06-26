{
  pkgs,
  lib,
  plugins,
}: let
  pluginManifestEntry = attr: let
    drv = attr.plugin or attr;
    owner = lib.toLower drv.src.owner;
    repo = lib.toLower drv.src.repo;
  in ''["${owner}/${repo}"] = nix_prefix .. "${drv}",'';

  manifestLua = with builtins; ''
    local nix_prefix = os.getenv("NIX_PREFIX") or ""
    return {
     ${concatStringsSep "\n" (map pluginManifestEntry plugins)}
    }
  '';
in
  pkgs.vimUtils.buildVimPlugin {
    name = "nix-lazy-nvim";
    src = ./nix-lazy.nvim;
    postInstall = ''
      echo '${manifestLua}' > $out/lua/nix/manifest.lua
    '';
  }
