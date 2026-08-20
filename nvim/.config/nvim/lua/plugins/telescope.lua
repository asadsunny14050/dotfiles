return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
        cmd = "Telescope",
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local fb = require("telescope").extensions.file_browser
            -- local action_set = require("telescope.actions.set")

            telescope.setup({
                defaults = {
                    layout_strategy = "bottom_pane",
                    layout_config = {
                        height = 0.5,
                    },
                    -- border = true,
                    borderchars = {
                        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
                        results = { " " },
                        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    },
                    file_browser = {
                        hijack_netrw = true,
                        hidden = true,
                    },
                    mappings = {
                        n = {
                            ["<leader><CR>"] = actions.select_vertical,
                        },
                        i = {
                            ["<leader><CR>"] = actions.select_vertical,
                        },
                    },
                },
            })

            telescope.load_extension("file_browser")

            LAST_BROWSER_PATH = vim.fn.expand("~")

            local function attach_file_browser_mappings(prompt_bufnr)
                -- local actions = require("telescope.actions")
                -- local action_state = require("telescope.actions.state")
                -- local telescope = require("telescope")

                local function open_entry(entry_bufnr)
                    local entry = action_state.get_selected_entry()
                    actions.close(entry_bufnr)
                    vim.cmd("split")
                    if vim.fn.isdirectory(entry.path) == 1 then
                        require("oil").open(entry.path)
                    else
                        vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
                        vim.cmd("filetype detect") -- optional
                        vim.cmd("setlocal buflisted") -- make sure buffer is listed
                    end
                end

                local function tab_autocomplete()
                    local entry = action_state.get_selected_entry()
                    if not entry or not entry.path then
                        return
                    end

                    if vim.fn.isdirectory(entry.path) == 1 then
                        actions.close(prompt_bufnr)
                        telescope.extensions.file_browser.file_browser({
                            path = entry.path,
                            cwd = entry.path,
                            hidden = true,
                            respect_gitignore = false,
                            prompt_title = entry.path,
                            attach_mappings = attach_file_browser_mappings,
                        })
                    else
                        local picker = action_state.get_current_picker(prompt_bufnr)
                        picker:reset_prompt(entry.path)
                    end
                end

                local map = function(mode, key, fn)
                    vim.keymap.set(mode, key, fn, { buffer = prompt_bufnr })
                end

                map("i", "<CR>", function()
                    open_entry(prompt_bufnr)
                end)
                map("n", "<CR>", function()
                    open_entry(prompt_bufnr)
                end)
                map("i", "<Tab>", tab_autocomplete)

                return false --  disables Telescope's default mappings (so our <Tab> works)
            end

            vim.keymap.set("n", "<leader>sf", function()
                require("telescope").extensions.file_browser.file_browser({
                    path = vim.fn.expand("~"),
                    cwd = vim.fn.expand("~"),
                    hidden = true,
                    respect_gitignore = false,
                    prompt_title = "System File Search",
                    attach_mappings = attach_file_browser_mappings, -- <---- add this line
                })
            end)

            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>t", builtin.find_files, {})
            vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
            vim.keymap.set("n", "<leader>f", builtin.live_grep, {})
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
            vim.keymap.set("n", "<leader>v", function()
                builtin.find_files({
                    attach_mappings = function(prompt_bufnr, _)
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
