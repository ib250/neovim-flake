if vim.g.did_load_lspconfig_plugin then
  return
end
vim.g.did_load_lspconfig_plugin = true

local none_ls = require('null-ls')
none_ls.setup {
  sould_attach = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):match('^git://')
  end,
  sources = {
    none_ls.builtins.formatting.stylua,
    none_ls.builtins.formatting.shfmt,
    none_ls.builtins.formatting.prettier,
    none_ls.builtins.formatting.black,
    none_ls.builtins.formatting.pg_format,
    none_ls.builtins.formatting.sqlfluff,
    none_ls.builtins.formatting.alejandra,

    none_ls.builtins.diagnostics.cppcheck,
    none_ls.builtins.diagnostics.statix,
    none_ls.builtins.diagnostics.sqlfluff,
    none_ls.builtins.diagnostics.zsh,

    none_ls.builtins.completion.luasnip,
    none_ls.builtins.completion.spell,

    none_ls.builtins.code_actions.statix,
    none_ls.builtins.code_actions.gitsigns,
  },
}

local lspconfig = require('lspconfig')
local servers = {
  { name = 'yamlls' },
  { name = 'jsonls' },
  { name = 'pyright' },
  { name = 'gopls' },
  {
    name = 'clangd',
    extraOptions = {
      on_attach = function(_, _)
        require('clangd_extensions.inlay_hints').setup_autocmd()
        require('clangd_extensions.inlay_hints').set_inlay_hints()
      end,
    },
  },
  { name = 'bashls' },
  { name = 'tsserver' },
  { name = 'vuels' },
  { name = 'dockerls' },
  { name = 'docker_compose_language_service' },
  { name = 'denols' },
  { name = 'volar' },
  { name = 'ruff_lsp' },
  { name = 'gopls' },
}

local default_opts = {
  on_attach = function(_, _)
    print(vim.lsp.buf.list_workspace_folders())
  end,
  capabilities = require('user.lsp').make_client_capabilities(),
}

for _, server in ipairs(servers) do
  local options = server.extraOptions
  if options == nil then
    lspconfig[server.name].setup(default_opts)
  else
    lspconfig[server.name].setup(vim.tbl_extend('keep', options, default_opts))
  end
end

require('nlspsettings').setup {
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = '.nvim',
  local_settings_root_markers_fallback = { '.git', 'Makefile', 'CmakeLists.txt', 'build' },
  append_default_schemas = true,
  loader = 'json',
  open_strictly = false,
  nvim_notify = { enable = false, timeout = 5000 },
  ignored_servers = {},
}
