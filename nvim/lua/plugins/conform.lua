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
				ruff_fix = {
					inherit = false,
					command = "ruff",
					args = {
						"check",
						"--fix",
						"--force-exclude",
						"--exit-zero",
						"--stdin-filename",
						"$FILENAME",
						"-",
					},
					stdin = true,
				},
				ruff_format = {
					inherit = false,
					command = "ruff",
					args = {
						"format",
						"--force-exclude",
						"--stdin-filename",
						"$FILENAME",
						"-",
					},
					range_args = function(_, ctx)
						return {
							"format",
							"--force-exclude",
							"--range",
							string.format(
								"%d:%d-%d:%d",
								ctx.range.start[1],
								ctx.range.start[2] + 1,
								ctx.range["end"][1],
								ctx.range["end"][2] + 1
							),
							"--stdin-filename",
							"$FILENAME",
							"-",
						}
					end,
					stdin = true,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				luau = { "stylua" },
				python = { "ruff_fix", "ruff_format" },
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
		setup = function(_, opts)
			local ruff_cwd = require("conform.util").root_file {
				"pyproject.toml",
				"ruff.toml",
				".ruff.toml",
			}

			opts.formatters.ruff_fix.cwd = ruff_cwd
			opts.formatters.ruff_format.cwd = ruff_cwd
			require("conform").setup(opts)
		end,
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
