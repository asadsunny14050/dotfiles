return {
    "stevearc/oil.nvim",
    -- enabled = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    command = "Oil",
    config = function()
        require("oil").setup({
            watch_for_changes = true,
            columns = {
                -- "permissions",
                -- "mtime",
                -- "size",
                "icon",
            },
            -- keymaps = {
            -- 	["<C-p>"] = "actions.preview",
            -- },
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            },
            lsp_file_methods = {
                -- Enable or disable LSP file operations
                enabled = true,
                -- Time to wait for LSP file operations to complete before skipping
                timeout_ms = 1000,
                -- Set to true to autosave buffers that are updated with LSP willRenameFiles
                -- Set to "unmodified" to only save unmodified buffers
                autosave_changes = false,
            },
        })
    end,
}
