return {
    {
        "zapling/mason-conform.nvim",
        enabled = false,
        dependencies = {
            "stevearc/conform.nvim",
        },
        opts = {
            ignore_install = {},
        },
    },

    {
        "stevearc/conform.nvim",
        enabled = false,
        cmd = "ConformInfo",
        event = "BufWritePre",
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format { async = true, lsp_format = "never" }
                end,
                mode = "",
                desc = "Format Buffer",
            },
        },
        dependencies = {
            "mason-org/mason.nvim",
        },
        opts = {
            log_level = vim.log.levels.DEBUG,
            formatters = {
                taplo = {
                    inherit = false,
                    command = "taplo",
                    args = {
                        "format",
                        "--config",
                        "~/.config/nvim/lua/plugins/format/taplo.toml",
                        "-",
                    },
                },
                ruff_format = {
                    inherit = true,
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
                },
            },
            formatters_by_ft = {
                lua = { "stylua" },
                luau = { "stylua" },
                python = { "ruff_fix", "ruff_format" },
                toml = { "taplo" },
            },
            default_format_opts = {
                lsp_format = "never",
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "never",
            },
        },
    },
}
