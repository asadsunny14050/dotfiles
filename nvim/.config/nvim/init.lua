require("asadsunny")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
            -- open Oil on the directory you started Neovim with
            require("oil").open()
        end
    end,
})
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim

require("lazy").setup("plugins")

-- vim.cmd("colorscheme cyberdream")
require("netrw").setup({
    use_devicons = true,
})

-- File: lua/my_plugins/tmux_runner.lua
-- Or directly in your init.lua if you prefer

local M = {}

-- Function to run a command in a new tmux WINDOW
function M.run_in_tmux_window(cmd_str)
    -- The command string that will be executed by the target shell.
    -- We wrap the original cmd_str in 'sh -c "..."' so it's interpreted as a full shell command.
    -- This also requires escaping the inner double quotes for the Lua string.
    -- We also use vim.fn.shellescape on the entire command_to_execute for send-keys.
    local command_to_execute_in_tmux_shell = string.format("sh -c '%s'", cmd_str:gsub("'", "'\\''"))

    -- Now, this *entire* string needs to be escaped for `tmux send-keys` itself,
    -- as `send-keys` will receive it as one argument.
    local escaped_final_command = vim.fn.shellescape(command_to_execute_in_tmux_shell)

    -- Get the current working directory from Neovim
    local current_dir = vim.fn.getcwd()

    -- Determine the default shell for the new tmux window
    local default_shell = os.getenv("SHELL") or "sh"

    -- Create a unique window name
    local window_name = "nvim-cmd-" .. os.time()

    -- Step 1: Create the new tmux window
    local create_window_cmd = string.format("tmux new-window -d -c '%s' -n '%s'", current_dir, window_name)
    vim.fn.system(create_window_cmd)

    -- Step 2: Send the command to the newly created window
    -- The `escaped_final_command` now contains `sh -c 'git status'` (escaped).
    -- When `send-keys` types this, the target shell will execute `sh -c 'git status'`,
    -- which in turn correctly runs `git status`.
    local send_command_cmd = string.format(
        "tmux send-keys -t '%s' %s C-m", -- Removed single quotes around %s because escaped_final_command already handles its own quoting
        window_name,
        escaped_final_command      -- This string is already properly quoted/escaped by vim.fn.shellescape
    )
    vim.fn.system(send_command_cmd)

    -- Step 3: Send the default shell command to drop into interactive mode
    -- This ensures that after the initial command finishes, you get a fresh prompt.
    -- Sending it as a separate `send-keys` is cleaner than chaining.
    local send_default_shell_cmd = string.format("tmux send-keys -t '%s' '%s' C-m", window_name, default_shell)
    vim.fn.system(send_default_shell_cmd)

    -- Step 4: Select the newly created window
    local select_window_cmd = string.format("tmux select-window -t '%s'", window_name)
    vim.fn.system(select_window_cmd)

    vim.notify(" Command sent to new tmux window!", vim.log.levels.INFO)
end

-- Function to run a command in a new tmux PANE
function M.run_in_tmux_pane(cmd_str)
    -- The command string that will be executed by the target shell in the new pane.
    local final_command_for_tmux_shell = string.format(
        "%s -c '%s; exec %s'",
        os.getenv("SHELL") or "sh", -- The shell to run the command in
        cmd_str:gsub("'", "'\\''"), -- The user's command, with single quotes escaped for the inner single-quoted string
        os.getenv("SHELL") or "sh" -- The shell to exec into after the command
    )
    local tmux_split_command_arg = vim.fn.shellescape(final_command_for_tmux_shell)

    -- Get the current working directory from Neovim
    local current_dir = vim.fn.getcwd()

    -- Decide on the split direction (horizontal or vertical)
    local split_direction = "-v" -- Default to vertical split (new pane below)

    -- Step 1: Create the new tmux pane AND run the command within it
    local create_and_run_cmd =
        string.format("tmux split-window %s -c '%s' %s", split_direction, current_dir, tmux_split_command_arg)
    vim.fn.system(create_and_run_cmd)

    -- Step 2: Select the newly created pane (this is implicitly done by `split-window`
    --          but explicitly selecting ensures focus in all cases).
    local select_pane_cmd = "tmux select-pane -t :.+" -- Selects the next pane
    vim.fn.system(select_pane_cmd)

    vim.notify(" Command sent to new tmux pane!", vim.log.levels.INFO)
end

-- Create the user command for new WINDOW
vim.api.nvim_create_user_command("ShellRunWin", function(opts)
    if opts.args == "" then
        vim.ui.input({ prompt = "Enter shell in new window: " }, function(input)
            if input and input ~= "" then
                M.run_in_tmux_window(input)
            else
                M.run_in_tmux_window("")
            end
        end)
    else
        M.run_in_tmux_window(opts.args)
    end
end, { nargs = "?", complete = "shellcmd", desc = "Run command in a new tmux window" })

-- Create the user command for new PANE
vim.api.nvim_create_user_command("ShellRunPane", function(opts)
    if opts.args == "" then
        vim.ui.input({ prompt = "Enter shell command for new pane: " }, function(input)
            if input and input ~= "" then
                M.run_in_tmux_pane(input)
            else
                M.run_in_tmux_pane("")
            end
        end)
    else
        M.run_in_tmux_pane(opts.args)
    end
end, { nargs = "?", complete = "shellcmd", desc = "Run command in a new tmux pane" })
return M
