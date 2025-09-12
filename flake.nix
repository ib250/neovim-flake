{
  description = "Neovim derivation based on nightly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    neovim-nightly-overlay,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    named = drv: {
      name = drv.pname or drv.name;
      value = drv;
    };
  in
    flake-utils.lib.eachSystem supportedSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};

        nvim-treesitter-package = with pkgs.vimPlugins;
          nvim-treesitter.withAllGrammars;

        plugins = with pkgs.vimPlugins; {
          start = map named [
            nvim-treesitter-package
            nvim-treesitter-context
            nvim-treesitter-textobjects

            nvim-origami

            oil-nvim
            guess-indent-nvim
            rose-pine

            which-key-nvim
            comment-nvim
            todo-comments-nvim

            plenary-nvim
          ];

          opt = map named [
            gitsigns-nvim

            telescope-nvim
            telescope-frecency-nvim
            telescope-fzf-native-nvim
            telescope-ui-select-nvim

            nvim-lspconfig
            blink-cmp

            clangd_extensions-nvim
            rust-tools-nvim
            vim-just

            sqlite-lua
          ];
        };

        neovim-nightly = neovim-nightly-overlay.packages.${system};
        neovim-env = pkgs.buildEnv {
          pname = "nvim";
          inherit (neovim-nightly.default) version;
          name = "neovim-nightly-env";
          paths = [
            neovim-nightly.default
            pkgs.alejandra
            pkgs.nil
            pkgs.lua-language-server
            pkgs.stylua
            (
              let
                start =
                  pkgs.linkFarm "opt-start-contents" (builtins.listToAttrs
                    plugins.start);

                opt =
                  pkgs.linkFarm "opt-opt-contents" (builtins.listToAttrs
                    plugins.opt);

                ts-grammars = with nvim-treesitter-package.passthru;
                  pkgs.symlinkJoin {
                    name = "nvim-treesitter-grammars";
                    paths = dependencies;
                  };

              in
                pkgs.runCommand "neovim-nightly-env-plugins" {} ''
                  mkdir -p $out/opt/pack/nightly-plugin/{start,opt}

                  ln -snf ${start}/* $out/opt/pack/nightly-plugin/start/
                  ln -snf ${ts-grammars} \
                    $out/opt/pack/nightly-plugin/start/${ts-grammars.name}

                  ln -snf ${opt}/* $out/opt/pack/nightly-plugin/opt/
                ''
            )
          ];
        };

        shell = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            # Tools for Lua and Nix development, useful for editing files in this repo
            lua-language-server
            nil
            stylua
            luajitPackages.luacheck
            alejandra
            (
              pkgs.writeScriptBin "nvim.test" ''
                export NVIM_APPNAME=nightly
                ${neovim-env}/bin/nvim "$@"
              ''
            )
          ];
          shellHook = ''
            ln -snf $(pwd)/result/opt/pack $(pwd)/config/nvim/pack
            ln -snf $(pwd)/config/nvim ~/.config/nightly
          '';
        };
      in {
        packages = rec {
          default = neovim-env;
          nvim = default;
        };

        devShells = {
          default = shell;
        };
        formatter = pkgs.alejandra;
      }
    );
}
