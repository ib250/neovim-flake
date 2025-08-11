return {
  setup = function()
    require('ib250.plugins.oil')
    require('ib250.plugins.treesitter')
    require('ib250.plugins.telescope')
    require('ib250.lsp_mappings').setup()

    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("Ib250", { clear = true }),
      callback = function()
        vim.cmd.colorscheme("rose-pine")
        vim.cmd.hi("Comment gui=none")

        require("todo-comments").setup()
        require("Comment").setup()
        require("which-key").setup({
          preset = "helix",
          spec = {
            { "<leader>c", group = "[C]ode",     mode = { "n", "x" } },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>r", group = "[R]ename" },
            { "<leader>s", group = "[S]earch" },
            { "<leader>w", group = "[W]orkspace" },
            { "<leader>t", group = "[T]oggle" },
            { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
          },
          icons = { mappings = false },
          -- annoyingly icons are defaulted in a number of places
          replace = {
            key = {
              function(key)
                return tostring(key)
              end,
            },
          },
        })
      end,
    })

    require('gitsigns').setup {}
  end
}
