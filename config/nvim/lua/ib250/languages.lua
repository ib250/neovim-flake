return {
  setup = function(opts)
    vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
      callback = function()
        if vim.bo.filetype == nil then return end

        local status, lsps = pcall(require, 'ib250.languages.' .. vim.bo.filetype)
        if not status then return end

        for server, cfg in ipairs(lsps) do
            cfg.capabilities = vim.tbl_deep_extend('force', {}, opts.capabilities, lsps.capabilities or {})
            vim.lsp.config(server, cfg)
            vim.lsp.enable(server)
        end

      end
    })
  end
}
