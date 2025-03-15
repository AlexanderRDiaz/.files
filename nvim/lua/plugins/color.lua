local tokyo = {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night",
		transparent = true,
		terminal_colors = true,
		styles = {
			comments = { italic = false },
			keywords = { italic = false },
			functions = { italic = false },
			variables = { italic = false },
			sidebars = "dark",
			floats = "dark",
		},
		dim_inactive = true,
		cache = true,
		plugins = {
			all = true,
			auto = true,
		},
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd([[colorscheme tokyonight]])
	end,
}

return tokyo
