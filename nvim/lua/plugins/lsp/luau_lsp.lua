local function rojo_project()
    return vim.fs.root(0, function(name)
        return name:match(".+%.project%.json$")
    end)
end

return function()
    local server_capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
    )

    server_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    local platform = rojo_project() and "roblox" or "standard"

    require("luau-lsp").setup {
        platform = {
            type = platform,
        },
        plugin = {
            enabled = false,
        },
        sourcemap = {
            enabled = (platform == "roblox"),
            autogenerate = true,
        },
        types = {
            definition_files = { "globalTypes.d.luau" },
            documentation_files = { "en-us.json" },
        },
        server = {
            cmd = { "pesde x pesde/luau_lsp", "lsp" },
            root_dir = function(path)
                return vim.fs.root(path, function(name)
                    return name:match(".+%.project%.json$")
                end) or vim.fs.root(path, {
                    ".git",
                    ".luaurc",
                    "stylua.toml",
                    "selene.toml",
                    "selene.yml",
                })
            end,
            capabilities = server_capabilities,
            settings = {
                ["luau-lsp"] = {
                    ignoreGlobs = {
                        "**/luau_packages/**",
                        "**/roblox_packages/**",
                        "**/lune_packages/**",
                        "**/.pesde/**",
                    },
                    completion = {
                        imports = {
                            enabled = true,
                            stringRequires = {
                                enabled = true,
                            },
                            ignoreGlobs = {
                                "**/luau_packages/**",
                                "**/roblox_packages/**",
                                "**/lune_packages/**",
                                "**/.pesde/**",
                            },
                        },
                    },
                },
            },
        },
    }
end
