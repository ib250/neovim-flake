-- options.nix
do
  vim.g.mapleader = ";"
  vim.g.editorconfig = true
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.foldenable = false
  vim.opt.foldminlines = 2
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.wrap = false
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.undofile = true
  vim.opt.wildmenu = true
  vim.opt.encoding = "utf8"
  vim.opt.ruler = true
  vim.opt.hidden = true
  vim.opt.autoindent = true
  vim.opt.backspace = { "indent", "eol", "start" }
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.hlsearch = true
  vim.opt.incsearch = true
  vim.opt.shellslash = true
  vim.opt.clipboard = "unnamedplus"
  vim.opt.lazyredraw = true
  vim.opt.cursorline = false
  vim.opt.errorbells = false
  vim.opt.visualbell = false
  vim.opt.completeopt = { "menuone", "menu", "longest" }
  vim.opt.autochdir = true
end

-- plugins: lib
local packadd = function(opts)
  local plugins = opts.plugins
  local config = opts.config

  for _, plugin_name in ipairs(plugins) do
    local cmd = ":packadd " .. plugin_name
    vim.cmd(cmd)
  end

  if config ~= nil then
    config()
  end
end

-- plugins
packadd({
  plugins = {
    "plenary.nvim",
    "catppuccin-nvim",
    "nvim-cmp",
    "luasnip",
    "friendly-snippets",
    "cmp_luasnip",
    "cmp-nvim-lua",
    "cmp-nvim-lsp",
    "cmp-buffer",
    "cmp-path",
    "cmp-nvim-lsp-document-symbol",
    "cmp-nvim-lsp-signature-help",
    "cmp-spell",
    "cmp-treesitter",
    "cmp-zsh",
    "comment.nvim",
    "fidget.nvim",
    "gitsigns.nvim",
    "mini.nvim",
    "nvim-lspconfig",
    "nlsp-settings.nvim",
    "null-ls.nvim",
    "nvim-treesitter-pyfold",
    "nvim-treesitter-context",
    "nvim-treesitter-refactor",
    "nvim-treesitter-textobjects",
    "nvim-ts-rainbow2",
    "playground",
    "popup.nvim",
    "telescope.nvim",
    "telescope-fzf-native.nvim",
    "todo-comments.nvim",
    "which-key.nvim",
  },

  config = function()
    vim.cmd([[:colorscheme  catppuccin]])

    require("gitsigns").setup({})
    require("mini.doc").setup()
    require("mini.sessions").setup()
    require("mini.starter").setup()
    require("mini.surround").setup()

    require("telescope").setup({})
    require("telescope").load_extension("fzf")

    require("which-key").setup({})
    require("todo-comments").setup({})
    require("Comment").setup({})
    require("fidget").setup()

    require("nlspsettings").setup({
      config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
      local_settings_dir = ".nvim",
      local_settings_root_markers_fallback = { ".git", "Makefile", "CmakeLists.txt", "build" },
      append_default_schemas = true,
      loader = "json",
    })

    require("catppuccin").setup({
      integrations = {
        mini = true,
        native_lsp = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    })

    require("null-ls").setup({
      should_attach = function(bufnr)
        return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      end,

      sources = {
        require("null-ls").builtins.formatting.taplo,
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.shfmt,
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.formatting.alejandra,
        require("null-ls").builtins.diagnostics.statix,
        require("null-ls").builtins.diagnostics.shellcheck,
        require("null-ls").builtins.diagnostics.gitlint,
        require("null-ls").builtins.diagnostics.flake8,
        require("null-ls").builtins.diagnostics.deadnix,
        require("null-ls").builtins.diagnostics.cppcheck,
        require("null-ls").builtins.code_actions.statix,
        require("null-ls").builtins.code_actions.shellcheck,
      },
    })

    local lsp_servers = {
      { name = "yamlls" },
      { name = "tsserver" },
      { name = "pyright" },
      { name = "nil_ls" },
      { name = "jsonls" },
      { name = "gopls" },
      { name = "clangd" },
      { name = "bashls" },
      {
        name = "pylsp",
        extraOptions = {
          settings = {
            pylsp = {
              plugins = {
                pylsp_mypy = { enabled = true },
                ruff = { enabled = true },
              },
            },
          },
        },
      },
      {
        name = "lua_ls",
        extraOptions = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              runtime = { version = "LuaJIT" },
              telemetry = { enable = false },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          },
        },
      },
    }

    local lsp_capabilities = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      return capabilities
    end

    local lsp_setup_options = {
      on_attach = function(_client, _bufnr) end,
      capabilities = lsp_capabilities(),
    }

    for _, server in ipairs(lsp_servers) do
      if type(server) == "string" then
        require("lspconfig")[server].setup(lsp_setup_options)
      else
        local options = server.extraOptions
        if options == nil then
          require("lspconfig")[server.name].setup(lsp_setup_options)
        else
          require("lspconfig")[server.name].setup(
            vim.tbl_extend("keep", options, lsp_setup_options)
          )
        end
      end
    end

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip").config.setup()
    require("cmp").setup({
      formatting = { fields = { "kind", "abbr", "menu" } },
      mapping = require("cmp").mapping.preset.insert({
        ["<C-n>"] = require("cmp").mapping.select_next_item(),
        ["<C-p>"] = require("cmp").mapping.select_prev_item(),
        ["<C-d>"] = require("cmp").mapping.scroll_docs(-4),
        ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
        ["<C-Space>"] = require("cmp").mapping.complete({}),
        ["<CR>"] = require("cmp").mapping.confirm({
          behavior = require("cmp").ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = require("cmp").mapping(function(fallback)
          if require("cmp").visible() then
            require("cmp").select_next_item()
          elseif require("luasnip").expand_or_locally_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = require("cmp").mapping(function(fallback)
          if require("cmp").visible() then
            require("cmp").select_prev_item()
          elseif require("luasnip").locally_jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      performance = { max_view_entries = 10 },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = {
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_document_symbol" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      },
      window = {
        completion = { winhighlight = "Normal:Penu,FloatBorder:Pmenu,Search:None" },
        documentation = { winhighlight = "Normal:Penu,FloatBorder:Pmenu,Search:None" },
      },
    })

    require("nvim-treesitter.configs").setup({
      autotag = { enable = true },
      context = { trim_scope = "outer" },
      highlight = { enable = true },
      indent = { enable = true },
      playground = { enable = true },
      rainbow = { enable = true },
      refactor = {
        highlight_current_scope = { enable = false },
        highlight_definitions = { clear_on_cursor_move = true, enable = false },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = "gnd",
            goto_next_usage = "<C-.>",
            goto_previous_usage = "<C-,>",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
          },
        },
        smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
      },
      textobjects = {
        lsp_interop = {
          enable = true,
          border = "none",
          floating_preview_opts = {},
        },
      },
    })

    -- muscle memory things...
    vim.keymap.set("i", "jk", "<ESC>")
    vim.keymap.set("i", "kj", "<ESC>")
    vim.keymap.set("c", "jk", "<ESC>")
    vim.keymap.set("c", "kj", "<ESC>")
    vim.keymap.set("v", "jk", "<ESC>")
    vim.keymap.set("v", "kj", "<ESC>")
    vim.keymap.set("n", "<c-p>", "<cmd>Telescope<cr>", { desc = "Telescope command pallete" })
    vim.keymap.set("n", "qq", "<ESC>")
    vim.keymap.set("n", "<leader> ", "<cmd>noh<cr>", { desc = "Clear all highlights" })

    -- files
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
      ["<leader>bn"] = { "<cmd>bnext<cr>", "Next Buffer" },
      ["<leader>bp"] = { "<cmd>bprevious<cr>", "Previous Buffer" },
      ["<C-b>"] = { require("telescope.builtin").buffers, "Browse buffers" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>gS"] = { "<cmd>Telescope git_status<CR>", "Status" },
      ["<leader>gB"] = { "<cmd>Telescope git_branches<CR>", "Branches" },
      ["<leader>gC"] = { "<cmd>Telescope git_commits<CR>", "Commits" },
    })
  end,
})
