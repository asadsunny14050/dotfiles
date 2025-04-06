return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- for lua
                null_ls.builtins.formatting.stylua,

                null_ls.builtins.completion.spell,

                -- for typescript
                null_ls.builtins.formatting.prettier,
                require("none-ls.diagnostics.eslint").with({
                    command = "/mnt/c/Program Files/nodejs/eslint_d", -- Adjust path to Windows version
                    diagnostics_format = "[eslint] #{m}\n(#{c})",

                    -- only enable eslint if root has .eslintrc.js

                    condition = function(utils)
                        return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
                    end,
                }),
            },
        })
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,
}
