{
  description = "Neovim derivation based on nightly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      neovim-nightly-overlay,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      named = drv: {
        inherit (drv) name;
        value = drv;
      };
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };


        plugins =
          with pkgs.vimPlugins;
          (map named [
            nvim-treesitter-context
            nvim-treesitter-pyfold
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars

            comment-nvim
            oil-nvim
            todo-comments-nvim
            guess-indent-nvim

            gitsigns-nvim

            telescope-frecency-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            telescope-ui-select-nvim

            nvim-lspconfig
            blink-cmp

            clangd_extensions-nvim
            rust-tools-nvim
            vim-just

            rose-pine

            plenary-nvim
            sqlite-lua
            which-key-nvim
          ]);

        neovim-nightly = neovim-nightly-overlay.packages.${system};
        neovim-env = pkgs.buildEnv {
          pname = "nvim";
          inherit (neovim-nightly.default) version;
          name = "neovim-nightly-env";
          paths = [
            neovim-nightly.default
            (
              let

                farm = pkgs.linkFarm "opt-contents" (builtins.listToAttrs plugins);

              in
              pkgs.runCommand "neovim-nightly-env-plugins" { } ''
                mkdir -p $out/opt/pack/nightly-plugin/
                ln -snf ${farm} $out/opt/pack/nightly-plugin/start
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
          ''
          ;
        };
      in
      {
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
