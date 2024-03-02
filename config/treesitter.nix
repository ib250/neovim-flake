{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      indent = true;
      moduleConfig.autotag.enable = true;
      nixvimInjections = true;
    };
    treesitter-context = {
        enable = false;
        maxLines = 3;
    };
    treesitter-playground.enable = true;
    treesitter-refactor = {
      enable = true;
      navigation.enable = true;
      smartRename.enable = true;
    };
  };
}
