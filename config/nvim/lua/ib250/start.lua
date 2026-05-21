if vim.g.ib250_start then
  return
end

vim.g.ib250_start = true

vim.cmd.packadd "nvim.difftool"

require("vim._core.ui2").enable {}

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
require("nvim-treesitter").setup {
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
  textobjects = {
    select = {
      enable = true,
      lsp_interop = {
        enable = true,
        border = "none",
        floating_preview_opts = {},
        peek_definition_code = {
          ["<leader>cp"] = "@function.outer",
          ["<leader>cP"] = "@class.outer",
        },
      },
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = { query = "@function.outer", desc = "Select around function" },
        ["if"] = { query = "@function.inner", desc = "Select inside function" },
        ["ac"] = { query = "@class.outer", desc = "Select around class" },
        -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      }
    }
  }
}

-- origami
require("origami").setup {}

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd.GuessIndent()
    vim.cmd.colorscheme("rose-pine")
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end
})
