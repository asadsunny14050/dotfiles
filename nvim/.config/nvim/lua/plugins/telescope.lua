return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            -- local action_set = require("telescope.actions.set")

            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>t", builtin.find_files, {})
            vim.keymap.set("n", "<leader>f", builtin.live_grep, {})
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
            vim.keymap.set("n", "<leader>v", function()
                builtin.find_files({
                    attach_mappings = function(prompt_bufnr, map)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            vim.cmd("vsp " .. vim.fn.fnameescape(selection.path))
                        end)
                        return true
                    end,
                })
            end, { desc = "Telescope find_files in vertical split" })

            vim.keymap.set("n", "<leader>w", function()
                -- 'lsp_workspace_symbols' searches for all symbols defined in your project
                -- that your Language Server Protocol (LSP) server knows about.
                require("telescope.builtin").lsp_document_symbols()
            end, { desc = "[W]orkspace [S]ymbols (LSP)" })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            -- This is your opts table
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            -- even more opts
                        }),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-project.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("project")
        end,
    },
}
