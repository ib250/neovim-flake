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

  manifestLua = with builtins;
  # lua
    ''
      local nix_prefix = os.getenv("NIX_PREFIX") or ""
      Manifest = {
       ${concatStringsSep "\n" (map pluginManifestEntry plugins)}
      }

      function Manifest:use(opt)
        if opt.external then
          self[opt.key] = opt.path
        else
          self[opt.key] = nix_prefix .. opt.path
        end
      end

      return Manifest
    '';
in
  pkgs.vimUtils.buildVimPlugin {
    name = "nix-lazy-nvim";
    src = ./nix-lazy.nvim;
    postInstall = ''
      echo '${manifestLua}' > $out/lua/nix/manifest.lua
    '';
  }
