# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {};

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars
    vim-sleuth

    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    # nvim-cmp (autocompletion) and extensions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-nvim-lsp-document-symbol
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-treesitter
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    cmp-zsh
    cmp-spell
    # ^ nvim-cmp extensions

    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    # ^ git integration plugins

    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzf-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    telescope-ui-select-nvim
    telescope-frecency-nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions

    # UI.lua
    # statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    # catppuccin-nvim
    rose-pine
    nvim-treesitter-context # nvim-treesitter-context
    oil-nvim
    # ^ UI

    # language support
    nvim-lspconfig
    fidget-nvim
    none-ls-nvim
    conform-nvim
    clangd_extensions-nvim
    rust-tools-nvim
    nlsp-settings-nvim
    vim-just
    # ^ language support

    # navigation/editing enhancement plugins
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    # nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    nvim-treesitter-pyfold
    nvim-treesitter-refactor
    # ^ navigation/editing enhancement plugins

    # Useful utilities
    comment-nvim
    todo-comments-nvim
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim
  ];

  # TODO a little hacky but hey...
  nixPluginManifest = pkgs.callPackage ./nix-lazy-nvim.nix {plugins = all-plugins;};

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    nodePackages_latest.yaml-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.bash-language-server
    nodePackages_latest.prettier
    nodePackages_latest.dockerfile-language-server-nodejs
    docker-compose-language-service
    clang-tools_17
    pyright
    ruff

    gopls
    rust-analyzer

    # none-ls extras
    statix
    alejandra
    shellcheck
    cppcheck
    shfmt
    stylua
    pgformatter
    nodePackages_latest.sql-formatter
    sqlfluff

    # extra stuff for telescope
    git
    fzf
    fd
    ripgrep
  ];

  # final plugins, lazy-nvim required for nixPluginManifest
  finalPlugins =
    all-plugins
    ++ [
      nixPluginManifest
      pkgs.vimPlugins.lazy-nvim
    ];
in rec {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg =
    mkNeovim {
      plugins = finalPlugins;
      withNodeJs = true;
      withPython3 = true;
      inherit extraPackages;
    }
    // {
      show-nix-plugin-manifest = prev.writeScriptBin "show-nix-plugin-manifest" ''
        ${prev.bat}/bin/bat ${nixPluginManifest}/lua/nix/manifest.lua
      '';

      show-luarc-json = prev.writeScriptBin "show-luarc-json" ''
        ${prev.bat}/bin/bat ${nvim-luarc-json}
      '';
    };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = finalPlugins;
  };

  nvim-overlay-env = prev.buildEnv {
    name = "nvim-overlay-env";
    paths =
      extraPackages
      ++ [
        nvim-pkg
        nvim-pkg.show-nix-plugin-manifest
        nvim-pkg.show-luarc-json
        (prev.vimUtils.packDir nvim-pkg.packpathDirs)
      ];
  };
}
