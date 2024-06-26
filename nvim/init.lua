--[[

  ib250/neovim-flake is adapted from TJ Devrie's original
  See TJ Devies's original repo, some references and notes retained

  Kickstart.nvim is a starting point for your own configuration.
      - https://learnxinyminutes.com/docs/lua/
  After understanding a bit more about Lua, you can use `:help lua-guide` as a
  reference for how Neovim integrates Lua.
      - :help lua-guide
      - (or HTML version): https://neovim.io/doc/user/lua-guide.html


    - NOTE we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
      which is very useful when you're not exactly sure of what you're looking for.

    - I have left several `:help X` comments throughout the init.lua
      These are hints about where to find more information about the relevant settings,
      plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

    - If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

--]]

-- Set ; as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ';'
vim.g.maplocalleader = ' '

-- enable editorconfig support
vim.g.editorconfig = true

-- autochange directories to the openned files
vim.opt.autochdir = true

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- enable folding
vim.opt.foldenable = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '[d',
  vim.diagnostic.goto_prev,
  { desc = 'Go to previous [D]iagnostic message' }
)
vim.keymap.set(
  'n',
  ']d',
  vim.diagnostic.goto_next,
  { desc = 'Go to next [D]iagnostic message' }
)
vim.keymap.set(
  'n',
  '<leader>e',
  vim.diagnostic.open_float,
  { desc = 'Show diagnostic [E]rror messages' }
)
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set(
  't',
  '<Esc><Esc>',
  '<C-\\><C-n>',
  { desc = 'Exit terminal mode' }
)

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set(
  'n',
  '<C-h>',
  '<C-w><C-h>',
  { desc = 'Move focus to the left window' }
)
vim.keymap.set(
  'n',
  '<C-l>',
  '<C-w><C-l>',
  { desc = 'Move focus to the right window' }
)
vim.keymap.set(
  'n',
  '<C-j>',
  '<C-w><C-j>',
  { desc = 'Move focus to the lower window' }
)
vim.keymap.set(
  'n',
  '<C-k>',
  '<C-w><C-k>',
  { desc = 'Move focus to the upper window' }
)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup(
    'kickstart-highlight-yank',
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Configure nix installed plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
-- `nix` is a lazy.nvim wrapper here that swaps the plugins specified here
-- for their nix derivation paths. All other features are from lazy.nvim
require('nix').setup {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', event = 'VimEnter', opts = {} },

  -- the goat's todo comments plugin
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
      },
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'kkharji/sqlite.lua',
        dependencies = {
          'nvim-lua/plenary.nvim',
        },
      },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ to allow use of sqlite3 db for telescope history
      --    this is configured in the overlay ]]
      vim.g.sqlite_clib_path = require('luv').os_getenv 'LIBSQLITE'

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          layout_strategy = 'vertical',
        },

        history = {
          path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
          limit = 1000,
        },
        set_env = {
          ['COLORTERM'] = 'truecolor',
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf_native')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
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
      vim.keymap.set('n', '<C-f>', function()
        if pcall(builtin.git_files) then
          return
        end
        builtin.find_files()
      end, { desc = 'Smart [F]ind [F]iles' })
      vim.keymap.set(
        'n',
        '<leader>ss',
        builtin.builtin,
        { desc = '[S]earch [S]elect Telescope' }
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
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
      )
      vim.keymap.set(
        'n',
        '<leader><leader>',
        builtin.buffers,
        { desc = '[ ] Find existing buffers' }
      )

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        )
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      vim.keymap.set('n', '<leader>w/', function()
        builtin.live_grep {
          search_dirs = vim.lsp.buf.list_workspace_folders(),
        }
      end, { desc = '[/] Search [W]orkspace [/] all files' })

      -- muscle memory
      vim.keymap.set(
        'n',
        '<C-p>',
        vim.cmd.Telescope,
        { desc = 'Open telescope' }
      )
    end,
  },

  -- justfile support
  { 'noahtheduke/vim-just' },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = 'VimEnter',
    dependencies = {
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
      {
        'p00f/clangd_extensions.nvim',
        event = 'LspAttach',
        ft = { 'c', 'cpp', 'proto' },
        config = function(_)
          local c_inl = require 'clangd_extensions.inlay_hints'
          c_inl.setup_autocmd()
          c_inl.set_inlay_hints()
          vim.keymap.set(
            'n',
            '<leader><tab>',
            vim.cmd.ClangdSwitchSourceHeader,
            { desc = 'Switch Source-Header' }
          )
        end,
      },
      {
        'simrat39/rust-tools.nvim',
        event = 'LspAttach',
        ft = { 'rust' },
        config = function(opts)
          require('rust-tools').setup(opts)
          require('rust-tools.inlay_hints').enable {}
        end,
      },
      {
        'tamago324/nlsp-settings.nvim',
        opts = {
          config_home = vim.fn.stdpath 'config' .. '/nlsp-settings',
          local_settings_dir = '.nvim',
          local_settings_root_markers_fallback = { '.git' },
          append_default_schemas = true,
          loader = 'json',
          open_strictly = false,
          nvim_notify = { enable = false, timeout = 5000 },
          ignored_servers = {},
        },
      },
      {
        'nvimtools/none-ls.nvim',
        config = function()
          local none_ls = require 'null-ls'
          none_ls.setup {
            should_attach = function(bufnr)
              return not vim.api.nvim_buf_get_name(bufnr):match '^git://'
            end,
            sources = {
              -- NOTE: dont enable formatters, confirm handles those
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
        end,
      },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup(
          'kickstart-lsp-attach',
          { clear = true }
        ),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set(
              'n',
              keys,
              func,
              { buffer = event.buf, desc = 'LSP: ' .. desc }
            )
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map(
            'gd',
            require('telescope.builtin').lsp_definitions,
            '[G]oto [D]efinition'
          )

          -- Find references for the word under your cursor.
          map(
            'gr',
            require('telescope.builtin').lsp_references,
            '[G]oto [R]eferences'
          )

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map(
            'gI',
            require('telescope.builtin').lsp_implementations,
            '[G]oto [I]mplementation'
          )

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map(
            '<leader>D',
            require('telescope.builtin').lsp_type_definitions,
            'Type [D]efinition'
          )

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map(
            '<leader>ds',
            require('telescope.builtin').lsp_document_symbols,
            '[D]ocument [S]ymbols'
          )

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map(
            '<leader>ws',
            require('telescope.builtin').lsp_dynamic_workspace_symbols,
            '[W]orkspace [S]ymbols'
          )

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client and client.server_capabilities.documentHighlightProvider
          then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global, etc.
                globals = {
                  'vim',
                  'describe',
                  'it',
                  'assert',
                  'stub',
                },
                disable = { 'duplicate-set-field' },
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              hint = { -- inlay hints (supported in Neovim >= 0.10)
                enable = true,
              },
            },
          },
        },
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        clangd = {
          capabilities = { offsetEncoding = 'utf-16' },
        },
        gopls = {},
        pyright = {},
        ruff = {
          capabilities = {
            hoverProvider = false
          }
        },
        jsonls = {},
        yamlls = {},
        tsserver = {},
        vls = {},
        dockerls = {},
        rust_analyzer = {},
        docker_compose_language_service = {},
        nil_ls = {},
        denols = {
          enable = {},
          root_patterns = require('lspconfig.util').root_pattern 'deno.json',
        },
      }

      for server_name, config in pairs(servers) do
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        config.capabilities = vim.tbl_deep_extend(
          'force',
          {},
          capabilities,
          config.capabilities or {}
        )
        require('lspconfig')[server_name].setup(config)
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = function(bufnr)
          local ruff_ =
            require('conform').get_formatter_info('ruff_format', bufnr)
          if ruff_.available then
            return { 'ruff_format' }
          else
            return { 'isort', 'black' }
          end
        end,
        cpp = { 'clang_format' },
        sh = { 'shfmt' },
        c = { 'clang_format' },
        sql = { 'pg_format', 'sqlfluff' },
        nix = { 'alejandra' },
        just = { 'just' },
        ['*'] = { 'codespell' },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { { 'prettierd', 'prettier' } },
      },
    },
    config = function()
      -- enable format on save by default
      vim.g.disable_autoformat = false

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b[vim.fn.bufnr()].disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b[vim.fn.bufnr()].disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })

      vim.api.nvim_create_user_command('ToggleFormatOnSave', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          local state = vim.b[vim.fn.bufnr()].disable_autoformat
          vim.b[vim.fn.bufnr()].disable_autoformat = not state
        else
          local state = vim.g.disable_autoformat
          vim.g.disable_autoformat = not state
        end
      end, {
        desc = 'Toggle autoformat-on-save',
        bang = true,
      })
    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-buffer',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'tamago324/cmp-zsh',
      'f3fora/cmp-spell',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- reduce completion noise, cap number of entries
        performance = { max_view_entries = 10 },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp_document_symbol', keyword_length = 3 },
          { name = 'nvim_lsp', keyword_length = 3 },
          { name = 'luasnip', keyword_length = 3 },
          { name = 'path', keyword_length = 3 },
          { name = 'buffer', keyword_length = 2 },
        },
      }

      cmp.setup.filetype('lua', {
        sources = cmp.config.sources {
          { name = 'nvim_lua' },
          { name = 'nvim_lsp', keyword_length = 3 },
          { name = 'path' },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'nvim_lsp_document_symbol', keyword_length = 3 },
          { name = 'buffer' },
          { name = 'cmdline_history' },
        },
        view = {
          entries = { name = 'wildmenu', separator = '|' },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'cmdline' },
          { name = 'cmdline_history' },
          { name = 'path' },
        },
      })
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin'
      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-pyfold',
      'nvim-treesitter/nvim-treesitter-refactor',
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
          -- peek bindings
          vim.keymap.set('n', '<leader>cp', function()
            vim.cmd.TSTextobjectPeekDefinitionCode '@function.inner'
          end, { desc = '[C]ode [p]eek function Body' })

          vim.keymap.set('n', '<leader>cP', function()
            vim.cmd.TSTextobjectPeekDefinitionCode '@function.inner'
          end, { desc = '[C]ode [P]eek Class Body' })
        end,
      },
    },
    opts = {
      -- Autoinstall languages that are not installed
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KiB
          local ok, stats =
            pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
      pyfold = { enable = true },
      lsp_interop = { enable = true },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
      require('treesitter-context').setup { max_lines = 4 }
      vim.opt.foldenable = true
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  {
    'neogitorg/neogit',
    keys = '<leader>g',
    dependencies = {
      {
        -- Here is a more advanced example where we pass configuration
        -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
        --    require('gitsigns').setup({ ... })
        --
        -- See `:help gitsigns` to understand what the configuration keys do
        'lewis6991/gitsigns.nvim', -- TODO: configure me
        event = 'VimEnter',
        opts = {
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
          current_line_blame = false,
          current_line_blame_opts = {
            ignore_whitespace = true,
          },
          on_attach = function()
            vim.keymap.set(
              'n',
              '<leader>gbl',
              require('gitsigns').blame_line,
              { desc = '[G]itsigns [b]lame [l]line' }
            )
          end,
        },
      },
      {
        'sindrets/diffview.nvim', -- TODO: configure me
        opts = {
          use_icons = false,
        },
        config = function()
          vim.keymap.set('n', '<leader>gfb', function()
            vim.cmd.DiffviewFileHistory(vim.api.nvim_buf_get_name(0))
          end, {
            desc = 'Diffview [g]it [f]ile history (current [b]uffer)',
          })
          vim.keymap.set(
            'n',
            '<leader>gfc',
            vim.cmd.DiffviewFileHistory,
            { desc = 'Diffview [g]it [f]ile history ([c]wd)' }
          )

          vim.keymap.set(
            'n',
            '<leader>gdo',
            vim.cmd.DiffviewOpen,
            { desc = '[g]it [d]iffview [o]pen' }
          )
          vim.keymap.set(
            'n',
            '<leader>gdc',
            vim.cmd.DiffviewClose,
            { desc = '[g]it [d]iffview [c]lose' }
          )
          vim.keymap.set(
            'n',
            '<leader>gft',
            vim.cmd.DiffviewToggleFiles,
            { desc = '[g]it [d]iffview [f]iles [t]oggle' }
          )
        end,
      },
    },
    opts = {
      integrations = {
        diffview = true,
        telescope = true,
        fzf_lua = true,
      },
    },
    config = function(opts)
      require('neogit').setup(opts)
      vim.keymap.set(
        'n',
        '<leader>go',
        require('neogit').open,
        { desc = 'Neo[G]it [O]pen' }
      )
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
