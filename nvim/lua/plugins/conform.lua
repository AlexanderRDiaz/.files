return {
	{
		"stevearc/conform.nvim",
		cmd = "ConformInfo",
		event = "BufWritePre",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format { async = true }
				end,
				mode = "n",
				desc = "Format",
			},
		},
		dependencies = {
			"zapling/mason-conform.nvim",
		},
		opts = {
			log_level = vim.log.levels.DEBUG,
			formatters = {
				taplo = {
					inherit = false,
					command = "taplo",
					args = {
						"fmt",
						"-o",
						"indent_string=    ",
						"-",
					},
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				luau = { "stylua" },
				python = { "ruff" },
				toml = { "taplo" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},

	{
		"zapling/mason-conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ignore_install = {},
		},
	},
}
