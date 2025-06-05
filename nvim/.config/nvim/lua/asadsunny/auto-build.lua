local function load_build_config()
    local cwd = vim.fn.getcwd()
    local config_path = cwd .. "/build_config.lua"

    -- Check if file exists
    if vim.fn.filereadable(config_path) == 1 then
        -- Load the lua config as a module
        local ok, config = pcall(dofile, config_path)
        if ok and type(config) == "table" then
            return config
        else
            vim.notify("build_config.lua: invalid config format", vim.log.levels.ERROR)
            return nil
        end
    else
        vim.notify("No build_config.lua found in current directory", vim.log.levels.WARN)
        return nil
    end
end

local function run_build()
    local cwd = vim.fn.getcwd()
    local config = load_build_config()

    if not config then
        vim.notify("Cannot run build: missing or invalid build_config.lua", vim.log.levels.ERROR)
        return
    end

    local build_cmd = config.build_cmd or "make"
    local run_cmd = config.run_cmd or ""
    local tmux_window = config.tmux_window or "build-run"
    local session = vim.fn.system("tmux display-message -p '#S'"):gsub("\n", "")

    local exists =
        vim.fn.system(string.format("tmux list-windows -t '%s' -F '#W' | grep -Fx '%s'", session, tmux_window))

    if exists == "" then
        -- Start shell with working directory
        local shell_full_cmd = string.format("cd '%s' && exec bash --login -i", cwd)
        vim.fn.system(string.format("tmux new-window -d -n '%s' -t '%s' '%s'", tmux_window, session, shell_full_cmd))
        vim.fn.system("sleep 0.2")
    end

    -- Compose full command (clear, build, run)
    local full_cmd = run_cmd ~= "" and string.format(" %s && %s", build_cmd, run_cmd) or string.format(" %s", build_cmd)

    -- Send build/run command to pane 0
    vim.fn.system(string.format("tmux send-keys -t '%s:%s.0' C-c '%s' C-m", session, tmux_window, full_cmd))

    -- Switch to the window so you can see it run
    vim.fn.system(string.format("tmux select-window -t '%s:%s'", session, tmux_window))
end

vim.keymap.set(
    "n",
    "<leader>c",
    run_build,
    { noremap = true, silent = true, desc = "Run project build/run using build_config.lua" }
)
