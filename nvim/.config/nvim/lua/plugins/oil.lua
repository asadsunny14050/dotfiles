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
    config = function()
        require("oil").setup({
            watch_for_changes = true,
            columns = {
                "icon",
                -- "size",
                -- "mtime",
                -- "permissions",
            },
            -- keymaps = {
            -- 	["<C-p>"] = "actions.preview",
            -- },
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            },
            on_attach = function(bufnr)
                local api = vim.api
                local dir = require("oil").get_current_dir()
                api.nvim_buf_set_lines(bufnr, 0, 0, false, { dir }) -- insert at top
                -- optionally make it read-only so you don't accidentally modify
                api.nvim_buf_set_option(bufnr, "modifiable", false)
            end,
        })
    end,
}
