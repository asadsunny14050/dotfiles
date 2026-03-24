return {
	"fgheng/winbar.nvim",
	"SmiteshP/nvim-navic",
	"LunarVim/breadcrumbs.nvim",
	config = function()
		require("winbar").setup({
			enabled = true,

			show_file_path = true,
			show_symbols = true,

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
		require("nvim-navic").setup({
			lsp = {
				auto_attach = true,
			},
		})

		require("breadcrumb").setup({
			disabled_filetype = {
				"",
				"help",
			},
			icons = {
				File = " ",
				Module = " ",
				Namespace = " ",
				Package = " ",
				Class = " ",
				Method = " ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "練",
				Interface = "練",
				Function = " ",
				Variable = " ",
				Constant = " ",
				String = " ",
				Number = " ",
				Boolean = "◩ ",
				Array = " ",
				Object = " ",
				Key = " ",
				Null = "ﳠ ",
				EnumMember = " ",
				Struct = " ",
				Event = " ",
				Operator = " ",
				TypeParameter = " ",
			},
			separator = ">",
			depth_limit = 0,
			depth_limit_indicator = "..",
			color_icons = true,
			highlight_group = {
				component = "BreadcrumbText",
				separator = "BreadcrumbSeparator",
			},
		})

		local breadcrumb = function()
			local breadcrumb_status_ok, breadcrumb = pcall(require, "breadcrumb")
			if not breadcrumb_status_ok then
				return
			end
			return breadcrumb.get_breadcrumb()
		end

		local config = {
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { breadcrumb },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { breadcrumb },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		}

		lualine.setup(config)
	end,
}
