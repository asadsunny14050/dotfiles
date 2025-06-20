return {
    "fgheng/winbar.nvim",
    enabled = true,
    dependencies = {
        "utilyre/barbecue.nvim",
    },
    config = function()
        require("barbecue").setup({
            attach_navic = true, -- ✅ This is the magic line
            show_modified = true,
            show_navic = true, -- Ensures navic symbols are used
            symbols = {
                separator = " > ",
            },
        })
        require("winbar").setup({
            enabled = true,

            show_file_path = true,
            show_symbols = true,
            position = "right",

            colors = {
                path = "", -- You can customize colors like #c946fd
                file_name = "",
                symbols = "",
            },

            icons = {
                file_icon_default = "",
                seperator = ">",
                editor_state = "●",
                lock_icon = "",
            },

            exclude_filetype = {
                "help",
                "startify",
                "dashboard",
                "packer",
                "neogitstatus",
                "NvimTree",
                "Trouble",
                "alpha",
                "lir",
                "Outline",
                "spectre_panel",
                "toggleterm",
                "qf",
            },
        })
    end,
}
