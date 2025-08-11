local telescope = require 'telescope'
local themes = require 'telescope.themes'

telescope.setup({
  defaults = {
    layout_strategy = 'flex',
  },

  history = { limit = 1000, },
  set_env = { ['COLORTERM'] = 'truecolor', },
  -- pickers = {}
  extensions = {
    ['ui-select'] = {
      themes.get_dropdown {},
    },
    frecency = {
      db_safe_mode = false,
    },
  },
})

pcall(telescope.load_extension, 'fzf_native')
pcall(telescope.load_extension, 'ui-select')
pcall(telescope.load_extension, 'frecency')
local builtin = require 'telescope.builtin'
vim.keymap.set(
  'n',
  '<leader>sh',
  builtin.help_tags,
  { desc = '[S]earch [H]elp' }
)
vim.keymap.set(
  'n',
  '<leader>sk',
  builtin.keymaps,
  { desc = '[S]earch [K]eymaps' }
)
vim.keymap.set(
  'n',
  '<leader>sf',
  builtin.find_files,
  { desc = '[S]earch [F]iles' }
)
vim.keymap.set(
  'n',
  '<leader>sw',
  builtin.grep_string,
  { desc = '[S]earch current [W]ord' }
)
vim.keymap.set(
  'n',
  '<leader>sg',
  builtin.live_grep,
  { desc = '[S]earch by [G]rep' }
)
vim.keymap.set(
  'n',
  '<leader>sd',
  builtin.diagnostics,
  { desc = '[S]earch [D]iagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>sr',
  builtin.resume,
  { desc = '[S]earch [R]esume' }
)
vim.keymap.set(
  'n',
  '<leader>s.',
  function()
    vim.cmd [[Telescope frecency theme=dropdown]]
  end,
  { desc = '[S]earch Recent Files ("." for repeat)' }
)

vim.keymap.set(
  'n',
  '<leader><leader>',
  builtin.buffers,
  { desc = '[ ] Find existing buffers' }
)

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(themes.get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sn', function()
end, { desc = '[S]earch [N]eovim files' })

vim.keymap.set(
  "n",
  "<c-p>",
  vim.cmd.Telescope,
  { desc = "Open Telescope [P]alette" }
)
