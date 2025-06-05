local M = {}

-- Only run once for side-effects (e.g., remaps or settings)
require("asadsunny.remap")
require("asadsunny.set")
require("asadsunny.auto-build")

-- Import and expose switch-project
M.switch_project = require("asadsunny.switch-project")

return M
