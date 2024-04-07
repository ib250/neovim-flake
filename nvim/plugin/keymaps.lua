if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

require("which-key").register({
  ["<leader>c"] = { name = "+code" },
  ["<leader>cR"] = { vim.lsp.buf.rename, "Rename" },
  ["<leader>ca"] = { vim.lsp.buf.code_action, "Code Action" },
  ["<leader>ct"] = { vim.lsp.buf.type_definition, "Jump to type" },
  ["<leader>cD"] = { vim.lsp.buf.declaration, "Jump to declaration" },
  ["<leader>cd"] = { vim.lsp.buf.definition, "Jump to definition" },
  ["<leader>cr"] = { vim.lsp.buf.references, "Jump to references" },
  ["<leader>ci"] = { vim.lsp.buf.implementation, "Jump to implementation" },
  ["<leader>cf"] = { vim.lsp.buf.format, "Format buffer" },
  ["<leader>cp"] = {
    "<cmd>TSTextobjectPeekDefinitionCode @function.outer<cr>",
    "Peek function definition",
  },
  ["<leader>cP"] = {
    "<cmd>TSTextobjectPeekDefinitionCode @class.outer<cr>",
    "Peek class definition",
  },
  ["K"] = { vim.lsp.buf.hover, "Lsp Hover doc" },
  ["<leader>f"] = { name = "+file" },
  ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
  ["<leader>f."] = { "<cmd>Telescope find_files cwd=%s<cr>", "Browse cwd" },
  ["<leader>f/"] = { require("telescope.builtin").grep_string, "Telescrope Grep string" },
  ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  ["<leader>fg"] = { "<cmd>Telescope git_files<cr>", "Open Git File" },
  ["<C-f>"] = {
    function()
      local tb = require("telescope.builtin")
      if pcall(tb.git_files) then
        return
      end
      tb.find_files()
    end,
    "Smart Find files",
  },
  ["<leader>b"] = { name = "+buffers" },
  ["<leader>bl"] = { "<cmd>Telescope buffers<cr>", "Find File" },
  ["<leader>bn"] = { vim.cmd.bnext, "Next Buffer" },
  ["<leader>bp"] = { vim.cmd.bprevious, "Previous Buffer" },
  ["<C-b>"] = { require("telescope.builtin").buffers, "Browse buffers" },
  ["<leader>g"] = { name = "+git" },
  ["<leader>gS"] = { "<cmd>Telescope git_status<CR>", "Status" },
  ["<leader>gB"] = { "<cmd>Telescope git_branches<CR>", "Branches" },
  ["<leader>gC"] = { "<cmd>Telescope git_commits<CR>", "Commits" },
})
