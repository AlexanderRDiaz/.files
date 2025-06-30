return function()
    vim.lsp.enable("pyright")
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
end
