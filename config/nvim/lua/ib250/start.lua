if vim.g.ib250_start then
  return
end

vim.g.ib250_start = true

-- which-key
require("which-key").setup {
  preset = 'helix',
  spec = {
    { '<leader>c', group = '[C]ode',     mode = { 'n', 'x' } },
    { '<leader>d', group = '[D]ocument' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
  icons = { mappings = false },
  -- annoyingly icons are defaulted in a number of places
  replace = {
    key = {
      function(key)
        return tostring(key)
        -- return require('which-key.view').format(key)
      end,
    },
  },
}

-- oil.nvim, guess-indent colors
require("oil").setup {
  default_file_explorer = true,
  view_options = { show_hidden = true },
  float = {
    padding = 2,
    max_width = 60,
    max_height = 30,
    border = 'rounded',
  },
}

vim.keymap.set(
  'n',
  '-',
  '<CMD>Oil --float<CR>',
  { desc = 'Open parent directory (float)' }
)
vim.keymap.set(
  'n',
  '<leader>-',
  '<CMD>Oil<CR>',
  { desc = 'Open parent directory (full screen)' }
)

-- guess-indent
require("guess-indent").setup {}

-- comment
require("Comment").setup {}

-- todo-comments
require("todo-comments").setup {}

-- nvim-treesitter
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KiB
      ---@diagnostic disable-next-line: undefined-field
      local ok, stats =
          pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  context = { enable = true, max_lines = 4 },
  indent = { enable = true },
  lsp_interop = { enable = true },
}

-- origami
require("origami").setup {
  useLspFoldsWithTreesitterFallback = true,
  pauseFoldsOnSearch = true,
  foldtext = {
    enabled = true,
    padding = 3,
    lineCount = {
      template = "%d lines", -- `%d` is replaced with the number of folded lines
      hlgroup = "Comment",
    },
    diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
    gitsignsCount = true,    -- requires `gitsigns.nvim`
  },
  autoFold = {
    enabled = true,
    kinds = { "comment", "imports" },
  },
  foldKeymaps = {
    setup = false, -- modifies `h`, `l`, and `$`
    hOnlyOpensOnFirstColumn = false,
  },
}

vim.cmd.colorscheme("rose-pine")
