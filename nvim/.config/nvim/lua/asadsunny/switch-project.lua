local M = {}

local Path = "/mnt/d/Coding"

local function list_projects()
    local fd = vim.fn.executable("fd") == 1 and "fd" or "fdfind"
    local cmd = string.format('%s -t d -d 3 . "%s"', fd, Path)
    local results = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        print("Error running fd/fdfind command")
        return {}
    end

    return results
end

local function open_in_tmux_window(path)
    local tmux_socket = os.getenv("TMUX")
    if not tmux_socket then
        print("Not inside tmux")
        return
    end

    local project_path = path:gsub("/$", "") -- remove trailing slash if any
    local project_name = vim.fn.fnamemodify(path, ":t")
    if project_name == "" or project_name == nil then
        project_name = "project"
    end
    local project_name = vim.fn.fnamemodify(project_path, ":t")
    if project_name == "" or project_name == nil then
        project_name = "project"
    end
    local cmd = string.format(
        "tmux new-window -n '%s' -c '%s' 'nvim %s' && tmux select-window -t '%s'",
        project_name,
        project_path,
        project_path,
        project_name
    )

    -- Optional debug print
    print("Opening project in tmux window:", path)
    os.execute(cmd)
end

function M.switch_project()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local conf = require("telescope.config").values

    local projects = list_projects()
    if #projects == 0 then
        print("No projects found in " .. Path)
        return
    end

    pickers
        .new({}, {
            prompt_title = "Select a Project",
            finder = finders.new_table({
                results = projects,
            }),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = { { vim.fn.fnamemodify(entry, ":t"), "TelescopeNormal" } },
                    ordinal = entry,
                }
            end,
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection and selection.value then
                        open_in_tmux_window(selection.value)
                    end
                end)
                return true
            end,
        })
        :find()
end

-- Keymap (optional — or just test with :lua require("switch_project").switch_project())
vim.keymap.set("n", "<leader>pf", M.switch_project, { desc = "Switch project in tmux" })

return M
