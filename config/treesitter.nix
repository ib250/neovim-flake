{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      indent = true;
      moduleConfig.autotag.enable = true;
      nixvimInjections = true;
    };
    treesitter-context.enable = true;
    treesitter-playground.enable = true;
    treesitter-refactor = {
      enable = true;
      navigation.enable = true;
      smartRename.enable = true;
    };
  };
}
