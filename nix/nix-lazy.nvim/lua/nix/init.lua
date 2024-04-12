local manifest = require 'nix.manifest'

local function nixify(config)
  if type(config) == 'string' then
    return { dir = manifest[config:lower()] }
  end

  if config.import ~= nil then
    return config
  end

  if manifest[config[1]:lower()] == nil then
    error(
      'Failed to load plugins '
        .. vim.inspect { config = config, manifest = manifest }
    )
  end

  local top_level_key = table.remove(config, 1)
  local path_opts = { dir = manifest[top_level_key:lower()] }
  local top_level = vim.tbl_extend('keep', config, path_opts)
  if top_level.dependencies == nil then
    return top_level
  end

  for key, dep in ipairs(top_level.dependencies) do
    top_level.dependencies[key] = nixify(dep)
  end

  return top_level
end

return {

  -- Setup nix installed plugins using similar to lazy.nvim
  setup = function(opts)
    local config = {}
    for _, plugin_opts in ipairs(opts) do
      table.insert(config, nixify(plugin_opts))
    end

    require('lazy').setup(config, {
      root = nil,
      install = { missing = false },
      change_detection = { enabled = false },
      performance = {
        cached = false,
        rtp = {
          reset = false,
        },
        reset_packpath = false,
      },
    })
  end,
}
