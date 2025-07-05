return function()
    vim.lsp.config("pyright", {
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
    })

    vim.lsp.enable("pyright")
end
