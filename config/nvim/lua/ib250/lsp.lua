return {
  setup = function()
    vim.diagnostic.config {
      underline = true,
      signs = true,
      virtual_text = false,
      float = true,
      severity_sort = true
    }

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = vim.api.nvim_create_augroup('ib250Completion', { clear = true }),
      callback = function()
        require('blink.cmp').setup {
          preset = 'default',
          appearance = {
            nerd_font_variant = 'mono',
            kind_icons = {
              Text = 'Text',
              Method = 'Method',
              Function = 'Function',
              Constructor = 'Constructor',

              Field = 'Field',
              Variable = 'Variable',
              Property = 'Property',

              Class = 'Class',
              Interface = 'Interface',
              Struct = 'Struct',
              Module = 'Module',

              Unit = 'Unit',
              Value = 'Value',
              Enum = 'Enum',
              EnumMember = 'EnumMember',

              Keyword = 'Keyword',
              Constant = 'Constant',

              Snippet = 'Snippet',
              Color = 'Color',
              File = 'File',
              Reference = 'Reference',
              Folder = 'Folder',
              Event = 'Event',
              Operator = 'Operator',
              TypeParameter = 'TypeParameter',
            }
          },
          completion = {
            documentation = { auto_show = false },
            list = {
              preselect = false,
              auto_insert = false
            },
            menu = { auto_show = false }
          },
          snippets = { preset = 'default' },
          sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
          fuzzy = { implementation = 'lua' },
          signature = { enabled = true }
        }
      end
    })


    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('Ib250LspMain', { clear = true }),
      callback = function(ev)
        local m = vim.lsp.protocol.Methods
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method(m.textDocument_completion) then
          vim.lsp.completion.enable(true, client.id, ev.buf,
            { autotrigger = true })
          vim.keymap.set("i", "<c-space>", vim.lsp.completion.get)
        end

        if client:supports_method(m.textDocument_formatting) then
          vim.keymap.set(
            "",
            "<leader>f",
            vim.lsp.buf.format,
            { desc = "[F]ormat Buffer/Selection" }
          )
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if
            client and client.server_capabilities.documentHighlightProvider
        then
          local lsp_hl_group = vim.api.nvim_create_augroup("Ib250LspHlGroup",
            { clear = true })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = lsp_hl_group,
            buffer = ev.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = lsp_hl_group,
            buffer = ev.buf,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("Ib250LspDetach",
              { clear = true }),
            callback = function(e2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "Ib250LspHlGroup", buffer = e2.buf }
            end
          })
        end

        if
            client
            and client.server_capabilities.inlayHintProvider
            and vim.lsp.inlay_hint
        then
          vim.keymap.set(
            'n',
            '<leader>th',
            function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end,
            { desc = '[T]oggle Inlay [H]ints' }
          )
        end
      end
    })

    -- servers
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require('ib250.languages').setup { capabilities = capabilities }

  end

}
