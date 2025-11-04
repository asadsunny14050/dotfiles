return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("lazy").setup({
            {
                "nvim-treesitter/nvim-treesitter",
                branch = "master",
                lazy = false,
                ensure_installed = { "lua", "javascript", "typescript", "html", "c" },
                auto_install = true,
                highlight = { enable = true },
                build = ":TSUpdate",
            },
        })
    end,
}
