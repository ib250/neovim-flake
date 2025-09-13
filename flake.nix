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
        name = drv.pname or drv.name;
        value = drv;
      };
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # NOTE: this allows the queries to be bundled into nvim-treesitter
        # for the parsers themselves, we need to handle that separately
        nvim-treesitter-package = with pkgs.vimPlugins; nvim-treesitter.withAllGrammars;

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
          paths =
            let
              start = pkgs.linkFarm "opt-start-contents" (builtins.listToAttrs plugins.start);

              opt = pkgs.linkFarm "opt-opt-contents" (builtins.listToAttrs plugins.opt);

              # NOTE: bundle the parsers in a single directory
              # so we can add it somewhere in packpath/start
              ts-grammars =
                with nvim-treesitter-package.passthru;
                pkgs.symlinkJoin {
                  name = "nvim-treesitter-grammars";
                  paths = dependencies;
                };

              packdir = pkgs.runCommand "neovim-nightly-env-plugins" { } ''
                mkdir -p $out/opt/pack/nightly-plugin/{start,opt}

                ln -snf ${start}/* $out/opt/pack/nightly-plugin/start/
                ln -snf ${ts-grammars} \
                  $out/opt/pack/nightly-plugin/start/${ts-grammars.name}

                ln -snf ${opt}/* $out/opt/pack/nightly-plugin/opt/
              '';

              cfgdir = pkgs.runCommand "neovim-nightly-appconfig" { } ''
                mkdir -p $out/opt/config/nvim
                ln -snf ${./config}/nvim/* $out/opt/config/nvim/
                ln -snf ${packdir}/opt/pack $out/opt/config/nvim/
              '';
            in
            [
              neovim-nightly.default
              pkgs.nixfmt
              pkgs.nil
              pkgs.lua-language-server
              pkgs.stylua
              pkgs.statix
              packdir
              cfgdir
            ];
        };

        shell = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            # Tools for Lua and Nix development, useful for editing files in this repo
            nil
            statix
            nixfmt
            lua-language-server
            stylua
            luajitPackages.luacheck
            (pkgs.writeScriptBin "nvim.test" ''
              export NVIM_APPNAME=nightly
              ${neovim-env}/bin/nvim "$@"
            '')
          ];
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
        formatter = pkgs.nixfmt;
      }
    );
}
