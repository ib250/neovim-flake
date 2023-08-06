{pkgs, ...}:
{
  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    viAlias = false;
    vimAlias = false;
    withPython3 = true;
    withNodeJs = true;
    withRuby = false;
    configure = {
      packages.myVimPacakge = with pkgs.vimPlugins; {
        start = let
          parsers = with pkgs.lib;
            filter isDerivation (builtins.attrValues nvim-treesitter-parsers);
        in
          [nvim-treesitter] ++ parsers;

        opt = [
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
}
