return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup {
			auto_install = true,
			sync_install = true,
			ensure_installed = {
				"c",
				"cpp",
				"c_sharp",
				"lua",
				"luau",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"html",
				"css",
				"php",
				"python",
			},
			highlight = { enable = true },
			indent = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
		}
	end,
}
