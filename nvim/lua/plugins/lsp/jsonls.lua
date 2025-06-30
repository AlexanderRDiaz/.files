local function GetSchemas()
    return require("schemastore").json.schemas {
        extras = {
            {
                description = "Rojo Project Schema",
                fileMatch = "*.project.json",
                name = ".project.json",
                url = "https://raw.githubusercontent.com/rojo-rbx/vscode-rojo/master/schemas/project.template.schema.json",
            },
        },
    }
end

return function()
    vim.lsp.enable("jsonls")
    vim.lsp.config("jsonls", {
        capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        ),
        settings = {
            json = {
                schemas = GetSchemas(),
                validate = { enable = true },
            },
        },
    })
end
