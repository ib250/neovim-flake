require("oil").setup({
  default_file_explorer = true,
  float = {
    max_width = 80,
    max_height = 20,
  },
})

vim.keymap.set("n", "-", vim.cmd.Oil, { desc = "Open Oil" })
vim.keymap.set(
  "n",
  "<leader>-",
  require("oil").open_float,
  { desc = "Open Oil" }
)
