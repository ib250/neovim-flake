{pkgs ? import <nixpkgs> {}, ...}: {
  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    viAlias = false;
    vimAlias = false;
    withPython3 = true;
    withNodeJs = true;
    withRuby = false;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [nvim-treesitter.withAllGrammars];

        opt = [
          editorconfig-nvim
          catppuccin-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-nvim-lsp-document-symbol
          cmp-nvim-lsp-signature-help
          cmp-nvim-lua
          cmp-path
          cmp-spell
          cmp-treesitter
          cmp-zsh
          cmp_luasnip
          comment-nvim
          fidget-nvim
          gitsigns-nvim
          luasnip
          friendly-snippets
          mini-nvim
          nvim-lspconfig
          nlsp-settings-nvim
          null-ls-nvim
          nvim-cmp
          nvim-treesitter-pyfold
          nvim-treesitter-context
          nvim-treesitter-refactor
          nvim-treesitter-textobjects
          nvim-ts-rainbow2
          playground
          plenary-nvim
          popup-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          todo-comments-nvim
          which-key-nvim
        ];
      };
    };
  };

  language-servers = [
    # core language servers
    pkgs.nodePackages.bash-language-server # bash
    pkgs.vscode-langservers-extracted # vscode html, css, etc
    (
      if builtins.hasAttr "lua-language-server" pkgs
      then pkgs.lua-language-server
      else pkgs.sumneko-lua-language-server
    )
    pkgs.nil # amazing nix lsp
    pkgs.nodePackages.typescript-language-server # ts + js
    pkgs.nodePackages.vls # vue
    pkgs.yaml-language-server # yaml
    #  misc formatters + linters
    pkgs.nodePackages.eslint
    pkgs.shellcheck
    pkgs.statix
    pkgs.cppcheck
    pkgs.deadnix
    pkgs.shfmt
    pkgs.sqlfluff
    pkgs.taplo
  ];
}
