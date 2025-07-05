return {
    {
        "mason-org/mason-lspconfig.nvim",
        cmd = "LspInstall",
        config = false,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        keys = {
            { "<C-s>e", "<cmd>lua require('luasnip').expand()<cr>", silent = true, mode = "i" },
            { "<C-s>;", "<cmd>lua require('luasnip').jump(1)<cr>", silent = true, mode = { "i", "s" } },
            { "<C-s>,", "<cmd>lua require('luasnip').jump(-1)<cr>", silent = true, mode = { "i", "s" } },
            {
                "<C-E>",
                function()
                    if require("luasnip").choice_active() then
                        require("luasnip").change_choice(1)
                    end
                end,
                silent = true,
                mode = { "i", "s" },
            },
        },
        event = { "InsertEnter" },
        build = "make install_jsregexp",
        opts = function()
            local types = require("luasnip.util.types")

            return {
                ext_opts = {
                    [types.choiceNode] = {
                        active = {
                            virt_text = { { "●", "GruvboxOrange" } },
                        },
                    },
                    [types.insertNode] = {
                        active = {
                            virt_text = { { "●", "GruvboxBlue" } },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local luasnip = require("luasnip")

            luasnip.config.setup(opts)
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local kind_priority = {}
            do
                local _kind_priority = {
                    {
                        "Field",

                        "Property",
                    },
                    {
                        "Constant",
                    },
                    {
                        "Enum",
                        "EnumMember",
                        "Event",
                        "Function",
                        "Method",
                        "Operator",
                        "Reference",
                        "Struct",
                    },
                    {
                        "Variable",
                    },
                    {
                        "File",
                        "Folder",
                    },
                    {
                        "Color",
                        "Class",
                        "Module",
                    },
                    {
                        "Keyword",
                    },
                    {
                        "Constructor",
                        "Interface",
                        "Text",
                        "TypeParameter",
                        "Unit",
                        "Value",
                    },
                    {
                        "Snippet",
                    },
                }

                for i = 1, #_kind_priority do
                    local priority = #_kind_priority - i

                    for _, kind in ipairs(_kind_priority[i]) do
                        kind_priority[kind] = priority
                    end
                end
            end

            return {
                enabled = function()
                    local disabled = (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
                        or (vim.fn.reg_recording() ~= "")
                        or (vim.fn.reg_executing() ~= "")
                        or require("cmp.config.context").in_treesitter_capture("comment")
                    return not disabled
                end,
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = entry.source.name
                        return vim_item
                    end,
                },
                sorting = {
                    comparators = {
                        function(entry1, entry2)
                            local lspTypes = require("cmp.types").lsp

                            if entry1.source.name ~= "nvim_lsp" then
                                if entry2.source.name ~= "nvim_lsp" then
                                    return nil
                                else
                                    return false
                                end
                            end

                            local kind1 = lspTypes.CompletionItemKind[entry1:get_kind()]
                            local kind2 = lspTypes.CompletionItemKind[entry2:get_kind()]

                            local priority1 = kind_priority[kind1] or 0
                            local priority2 = kind_priority[kind2] or 0

                            if priority1 == priority2 then
                                return nil
                            end

                            return priority2 < priority1
                        end,
                        function(entry1, entry2)
                            return entry1.completion_item.label < entry2.completion_item.label
                        end,
                    },
                },
                sources = cmp.config.sources({
                    { name = "lazydev", group_index = 0 },
                    {
                        name = "nvim_lsp",
                        max_item_count = 10,
                        priority = 5,
                    },
                    { name = "path", max_item_count = 5 },
                    { name = "luasnip", keyword_length = 3, max_item_count = 5, priority = 1 },
                }, {
                    { name = "buffer", keyword_length = 3, max_item_count = 5 },
                }),
                mapping = cmp.mapping.preset.insert {
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm {
                                    select = true,
                                }
                            end
                        else
                            fallback()
                        end
                    end, { "i" }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-u>"] = cmp.mapping.scroll_docs(4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                },
            }
        end,
        config = function(_, kind_priority)
            local cmp = require("cmp")

            cmp.setup(kind_priority)

            cmp.setup.cmdline("/", {
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "folke/lazydev.nvim",
            "b0o/schemastore.nvim",
            "lopi-py/luau-lsp.nvim",
        },
        cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local symbols = require("main.util.symbols")

            return {
                capabilities = {
                    workspace = {
                        didChangeWatchedFiles = {
                            dynamicRegistration = false,
                        },
                    },
                },
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
        end,
        config = function(_, kind_priority)
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

            if type(kind_priority.diagnostics.signs) ~= "boolean" then
                local text, linehl, numhl = {}, {}, {}
                for severity, icon in pairs(kind_priority.diagnostics.signs.text) do
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
                        if vim.fn.findfile(server_name .. ".lua", "~/.config/nvim/lua/main/plugins/lsp") then
                            require("main.plugins.lsp" .. server_name)()
                        else
                            vim.lsp.config(server_name, {
                                capabilities = vim.tbl_deep_extend(
                                    "force",
                                    vim.lsp.protocol.make_client_capabilities(),
                                    require("cmp_nvim_lsp").default_capabilities()
                                ),
                            })

                            vim.lsp.enable(server_name)
                        end
                    end,
                },
            }
        end,
    },

    -- Extras
    {
        "lopi-py/luau-lsp.nvim",
        cmd = "LuauLsp",
        config = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "folke/lazydev.nvim",
        opts = {
            debug = true,
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
