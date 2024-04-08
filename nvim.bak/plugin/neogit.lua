if vim.g.did_load_neogit_plugin then
  return
end
vim.g.did_load_neogit_plugin = true

local neogit = require('neogit')

neogit.setup {
  disable_builtin_notifications = true,
  disable_insert_on_commit = 'auto',
  integrations = {
    diffview = true,
    telescope = true,
    fzf_lua = true,
  },
  sections = {
    ---@diagnostic disable-next-line: missing-fields
    recent = {
      folded = false,
    },
  },
}
