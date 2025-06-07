vim.lsp.set_log_level("debug")

require("lspconfig").clangd.setup({
    on_attach = function(client)
        print("Capabilities:", vim.inspect(client.server_capabilities))
    end,
})
