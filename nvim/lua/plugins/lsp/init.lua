return {
    {
        "mason-org/mason-lspconfig.nvim",
        cmd = "LspInstall",
        config = false,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        opts = function()
            local cmp = require("cmp")

            return {
                sources = {
                    { name = "nvim_lsp" },
                },
                mapping = cmp.mapping.preset.insert {
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                },
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            }
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "b0o/schemastore.nvim",
            "lopi-py/luau-lsp.nvim",
        },
        opts = function()
            local symbols = require("util.symbols")

            local result = {
                diagnostics = {
                    underline = true,
                    update_in_insert = true,
                    virtual_text = {
                        spacing = 4,
                        source = "if_many",
                        prefix = "●",
                    },
                    severity_sort = true,
                    signs = {
                        text = {
                            [vim.diagnostic.severity.ERROR] = symbols.diagnostics.error,
                            [vim.diagnostic.severity.WARN] = symbols.diagnostics.warn,
                            [vim.diagnostic.severity.HINT] = symbols.diagnostics.hint,
                            [vim.diagnostic.severity.INFO] = symbols.diagnostics.info,
                        },
                    },
                },
                inlay_hints = {
                    enabled = true,
                    exclude = {},
                },
                format = {
                    formatting_options = nil,
                    timeout_ms = nil,
                },
            }

            return result
        end,
        config = function(_, opts)
            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local options = { buffer = event.buf }

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, options)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, options)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, options)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, options)
                end,
            })

            if type(opts.diagnostics.signs) ~= "boolean" then
                local text, linehl, numhl = {}, {}, {}
                for severity, icon in pairs(opts.diagnostics.signs.text) do
                    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                    name = "DiagnosticSign" .. name
                    text[name], linehl[name], numhl[name] = icon, name, ""
                end
                vim.diagnostic.config { signs = { text = text, linehl = linehl, numhl = numhl } }
            end

            require("mason-lspconfig").setup {
                automatic_installation = true,
                ensure_installed = {
                    "luau_lsp@1.48.0",
                },
                automatic_enable = {
                    exclude = {
                        "ruff",
                        "luau_lsp",
                    },
                },
                handlers = {
                    function(server_name)
                        if vim.fn.findfile(server_name .. ".lua", "~/.config/nvim/lua/plugins/lsp") then
                            require("plugins/lsp/" .. server_name)()
                        else
                            vim.lsp.enable(server_name)
                            vim.lsp.config(server_name, {
                                capabilities = vim.tbl_deep_extend(
                                    "force",
                                    vim.lsp.protocol.make_client_capabilities(),
                                    require("cmp_nvim_lsp").default_capabilities()
                                ),
                            })
                        end
                    end,
                },
            }
        end,
    },

    {
        "lopi-py/luau-lsp.nvim",
        cmd = "LuauLsp",
        config = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
