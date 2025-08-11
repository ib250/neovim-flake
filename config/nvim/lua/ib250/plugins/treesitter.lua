---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = vim.g.ts_max_filesize_kb * 1024 -- 100 KiB
      ---@diagnostic disable-next-line: undefined-field
      local ok, stats =
          pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  incremental_selection = { enable = true },
  pyfold = { enable = true },
  textobjects = {
    enable = true,
    select = {
      enable = true,
      ["af"] = { query = "@function.outer", desc = "Select [a]round [f]unction" },
      ["if"] = { query = "@function.inner", desc = "Select [i]nside [f]unction" },
      ["ac"] = { query = "@class.outer", desc = "Select [a]round [c]lass" },
      ["ic"] = { query = "@class.inner", desc = "Select [i]nner part of a [c]lass region" },
    },
    lsp_interop = {
      enable = true,
      border = "none",
    }
  },
  indent = { enable = true },
  lsp_interop = { enable = true },
}

require('treesitter-context').setup { max_lines = 4 }
vim.opt.foldenable = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

vim.keymap.set('v', 'af',
  function() vim.cmd.TSTextobjectSelect("@function.outer") end,
  { desc = "Select [a]round [f]unction" })
vim.keymap.set('v', 'if',
  function() vim.cmd.TSTextobjectSelect("@function.inner") end,
  { desc = "Select [i]nside [f]unction" })
vim.keymap.set('v', 'ac',
  function() vim.cmd.TSTextobjectSelect("@class.outer") end,
  { desc = "Select [a]round [c]lass" })
vim.keymap.set('v', 'ic',
  function() vim.cmd.TSTextobjectSelect("@class.inner") end,
  { desc = "Select [i]nside [c]lass" })
