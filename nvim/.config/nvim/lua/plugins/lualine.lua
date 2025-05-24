return {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
                require("lualine").setup({
                        options = {
                                icons_enabled = true,
                                theme = "nightfly",
                                globalstatus = true,
                        },
                        sections = {
                                lualine_c = {
                                        {
                                                "filetype",
                                                icon_only = true,
                                                separator = "",
                                                padding = { left = 1, right = 0 }, -- optional: reduce spacing
                                        },
                                        {
                                                "filename",
                                                file_status = true, -- displays file status (readonly status, modified status)
                                                path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                                        },
                                },
                        },
                })
        end,
}
