return {
    "nexcov/compile-mode.nvim",
    config = function()
        -- Opens the compile prompt
        vim.keymap.set("n", "<leader>cm", function()
            vim.cmd("CompileMode")
        end)
        -- Or run a command directly:
        -- :CompileMode echo hi!
    end,
}
