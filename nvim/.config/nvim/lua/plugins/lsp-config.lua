return {
    {
        -- install the language server and its executable in the system
        "williamboman/mason.nvim",
        version = "v1.*",
        -- enabled = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        -- bridges mason and lspconfig plugins
        -- more specifically allow you to (i) automatically install, and (ii) automatically set up a predefined list of servers
        "williamboman/mason-lspconfig.nvim",
        enabled = false,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "clangd", "tailwindcss" },
                -- auto-install configured servers (with lspconfig)
                automatic_installation = true, -- not the same as ensure_installed
            })
        end,
    },
    {
        -- connects the LSPs to the neovim client for use
        "neovim/nvim-lspconfig",
        version = "v1.*",
        -- enabled = false,
        config = function()
            vim.diagnostic.config({ virtual_text = true })
            -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
            -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                -- capabilities = capabilities,
                single_file_support = true,
                root_dir = function(fname)
                    local util = require("lspconfig.util")
                    -- Try to find git root first, otherwise use the file's directory
                    return util.find_git_ancestor(fname) or util.path.dirname(fname)
                end,
            })

            require("nvim-navic") -- or let lazy.nvim load it

            local capabilities2 = vim.lsp.protocol.make_client_capabilities()
            local navic = require("nvim-navic")
            lspconfig.clangd.setup({
                capabilities = capabilities2,
                init_options = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                    },
                },
                on_attach = function(client, bufnr)
                    vim.lsp.inlay_hint.enable(true)

                    -- Attach navic if supported
                    if client.server_capabilities.documentSymbolProvider then
                        navic.attach(client, bufnr)
                    end
                end,
            })

            -- Windows fix: Use "typescript-language-server.cmd"
            local ts_ls_cmd = "/mnt/c/Program Files/nodejs/typescript-language-server"
            if vim.loop.os_uname().sysname == "Windows_NT" then
                ts_ls_cmd = "/mnt/c/Program Files/nodejs/typescript-language-server.cmd"
            end

            -- lspconfig["pyright-langserver"].setup({
            --     capabilities = capabilities,
            --     -- on_attach = on_attach,
            -- })

            lspconfig.ts_ls.setup({
                cmd = { ts_ls_cmd, "--stdio" },
                -- capabilities = capabilities,
                filetypes = {
                    "typescript",
                    "typescriptreact",
                    "javascript",
                    "javascriptreact",
                    "typescript.tsx",
                    "javascript.jsx",
                },                          -- Attach to all types of ts/js files
                single_file_support = true, -- 🔥 Enables LSP for standalone .ts files
                root_dir = function(fname)
                    -- You can check if a `tsconfig.json` exists in the directory and use that as root
                    return require("lspconfig").util.find_git_ancestor(fname) or
                        vim.fn.getcwd() -- fallback to current working directory
                end,
                init_options = {
                    preferences = {
                        disableSuggestions = false,                   -- Allow autocomplete
                        importModuleSpecifierPreference = "relative", -- This is optional
                    },
                },
                on_attach = function(_, bufnr)
                    return vim.lsp.get_clients({ bufnr = bufnr })
                end,
                -- capabilities = vim.lsp.protocol.make_client_capabilities(),
            })

            lspconfig.html.setup({
                cmd = {
                    "/home/asad/.local/share/nvim/mason/packages/html-lsp/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server",
                    "--stdio",
                },
                -- capabilities = capabilities,
            })
            lspconfig.cssls.setup({
                cmd = {
                    "/home/asad/.local/share/nvim/mason/packages/css-lsp/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server",
                    "--stdio",
                },
                -- capabilities = capabilities,
            })
            lspconfig.tailwindcss.setup({
                cmd = {
                    "/home/asad/.local/share/nvim/mason/packages/tailwindcss-language-server/node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server",
                    "--stdio",
                },
                -- capabilities = capabilities,
            })
            -- astro --
            lspconfig["astro"].setup({
                cmd = {
                    "node",
                    "/home/asad/.local/share/nvim/mason/packages/astro-language-server/node_modules/@astrojs/language-server/bin/nodeServer.js",
                    "--stdio",
                },
                -- capabilities = capabilities,
                -- on_attach = on_attach,
                filetypes = { "astro" },
            })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
