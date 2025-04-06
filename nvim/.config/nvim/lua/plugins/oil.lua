return {
	"stevearc/oil.nvim",
	-- enabled = false,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			keymaps = {
				["<C-p>"] = "actions.preview",
			},
		
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
			},
		})
	end,
}
