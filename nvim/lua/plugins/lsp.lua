local function lsp_config()
	local lsp_defaults = require("lspconfig").util.default_config

	lsp_defaults.capabilities =
		vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

	lsp_defaults.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "LSP actions",
		callback = function(event)
			local opts = { buffer = event.buf }

			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		end,
	})
end

local function lua_ls_config()
	require("lspconfig").lua_ls.setup {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	}
end

local function luau_lsp_config()
	local lsp_defaults = require("lspconfig").util.default_config

	local function rojo()
		return vim.fs.root(0, function(name)
			return name:match(".+%.project%.json$")
		end)
	end

	require("luau-lsp").setup {
		platform = {
			type = rojo() and "roblox" or "standard",
		},
		capabilities = lsp_defaults.capabilities,
	}
end

local function pyright_config()
	require("lspconfig").pyright.setup {
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
	}
end

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")

			require("cmp").setup {
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-p>"] = cmp.mapping.scroll_docs(-4),
					["<C-n>"] = cmp.mapping.scroll_docs(4),
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			}
		end,
	},

	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/cmp-nvim-lsp",
		},
		config = lsp_config,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"lopi-py/luau-lsp.nvim",
		},
		opts = {
			automatic_installation = true,
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup {}
				end,
				lua_ls = lua_ls_config,
				luau_lsp = luau_lsp_config,
				pyright = pyright_config,
				taplo = function() end,
				ruff = function() end,
			},
		},
	},

	{
		"lopi-py/luau-lsp.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
}
