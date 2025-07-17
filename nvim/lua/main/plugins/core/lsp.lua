local spec = { "mason-org/mason-lspconfig.nvim" }

local _ = vim.lsp.config.lua_ls

spec.cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" }

spec.event = { "BufReadPre", "BufNewFile" }

spec.keys = {
    {
        "<leader>fm",
        function()
            vim.lsp.buf.format({ async = true })
        end,
        mode = "n",
        desc = "Format buffer",
    },
}

spec.dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "zeioth/none-ls-autoload.nvim",
    "folke/lazydev.nvim",
    "lopi-py/luau-lsp.nvim",
    "b0o/SchemaStore.nvim",
    "hrsh7th/cmp-nvim-lsp",
}

spec.opts = function()
    local luau_platform = vim.fs.root(0, function(name)
        return name:match(".+%.project%.json$")
    end) and "roblox" or "standard"

    local extra = {
        {
            description = "Rojo project schema",
            fileMatch = { "*.project.json" },
            name = "project.json",
            url = "https://raw.githubusercontent.com/rojo-rbx/vscode-rojo/master/schemas/project.template.schema.json",
        },
        {
            description = "Lua reconfiguration schema",
            fileMatch = { ".luarc.json", ".luarc.jsonc" },
            name = "luarc.json",
            url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
        },
    }

    return {
        pyright = {
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
            },
            python = {
                analysis = {
                    ignore = { "*" },
                },
            },
        },
        jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas({
                        extra = extra,
                    }),
                    validate = { enable = true },
                    format = { enable = true },
                },
            },
        },
        luau_lsp = {
            server = {
                ignoreGlobs = {
                    "*.d.luau",
                    "**/luau_packages/**",
                    "**/roblox_packages/**",
                    "**/lune_packages/**",
                    "**/.pesde/**",
                    "**/network/**",
                },
                completion = {
                    imports = {
                        enable = true,
                        stringRequires = {
                            enabled = true,
                        },
                        ignoreGlobs = {
                            "*.d.luau",
                            "**/luau_packages/**",
                            "**/.pesde/**",
                            "**/lune_packages/**",
                        },
                    },
                },
                fflags = {
                    enableNewSolver = true,
                },
            },
            opts = {
                platform = {
                    type = luau_platform,
                },
                plugin = {
                    enabled = false,
                },
                sourcemap = {
                    enabled = (luau_platform == "roblox"),
                    autogenerate = true,
                },
                types = {
                    definition_files = { "globalTypes.d.luau" },
                    documentation_files = { "en-us.json" },
                },
            },
        },
        mason_lspconfig = {
            automatic_enable = {
                exclude = {
                    "luau_lsp",
                },
            },
            ensure_installed = {
                "lua_ls",
                "jsonls",
                "pyright",
                "luau_lsp@1.48.0",
            },
        },
    }
end

spec.config = function(_, opts)
    local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
    )
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
    })

    vim.lsp.config("jsonls", opts.jsonls)
    vim.lsp.config("luau_lsp", opts.luau_lsp.server)

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", {}),
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            if client.supports_method(client, "textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = args.buf,
                    callback = function(_)
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                    end,
                })
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Hover" })
            vim.keymap.set(
                "n",
                "gd",
                vim.lsp.buf.definition,
                { buffer = args.buf, desc = "Go to definition" }
            )
            vim.keymap.set(
                "n",
                "gD",
                vim.lsp.buf.declaration,
                { buffer = args.buf, desc = "Go to declaration" }
            )
            vim.keymap.set(
                "n",
                "gi",
                vim.lsp.buf.implementation,
                { buffer = args.buf, desc = "Go to implementation" }
            )
            vim.keymap.set(
                "n",
                "go",
                vim.lsp.buf.type_definition,
                { buffer = args.buf, desc = "Go to type definition" }
            )
            vim.keymap.set(
                "n",
                "gr",
                vim.lsp.buf.references,
                { buffer = args.buf, desc = "Go to references" }
            )
            vim.keymap.set(
                "n",
                "gs",
                vim.lsp.buf.signature_help,
                { buffer = args.buf, desc = "Signature help" }
            )
            vim.keymap.set(
                "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                { buffer = args.buf, desc = "Rename word under cursor" }
            )
            vim.keymap.set(
                "n",
                "<leader>ca",
                vim.lsp.buf.code_action,
                { buffer = args.buf, desc = "Code action" }
            )
        end,
    })

    require("mason-lspconfig").setup(opts.mason_lspconfig)
    require("none-ls-autoload").setup {}

    require("luau-lsp").setup(opts.luau_lsp.opts)
end

return spec
