return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("lazy").setup({
            {
                "nvim-treesitter/nvim-treesitter",
                branch = "master",
                lazy = false,
                ensure_installed = { "lua", "javascript", "typescript", "html", "c", "c_sharp" },
                auto_install = true,
                highlight = { enable = true },
                build = ":TSUpdate",
                indent = { enable = true },
            },
        })

        vim.treesitter.language.register("c_sharp", "cs")
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "cs",
            callback = function()
                vim.treesitter.start(0, "c_sharp")
            end,
        })
    end,
}
