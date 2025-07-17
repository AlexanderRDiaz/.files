local function lint_config(_, opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft

    for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
            lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
            lint.linters[name] = linter
        end
    end

    local function try_lint()
        local names = vim.tbl_filter(function(name)
            local linter = lint.linters[name]
            if type(linter) == "table" and linter.condition then
                return linter:condition(vim.api.nvim_get_current_buf())
            end
            return true
        end, lint._resolve_linter_by_ft(vim.bo.filetype))
        if #names > 0 then
            lint.try_lint(names)
        end
    end

    vim.api.nvim_create_autocmd({ "TextChanged", "BufReadPost", "BufWritePost" }, {
        callback = try_lint,
    })
end

return {
    {
        "rshkarin/mason-nvim-lint",
        enabled = false,
        dependancies = { "williamboman/mason.nvim" },
        opts = {
            automatic_installation = true,
            quiet_mode = false,
            ignore_install = {},
        },
    },

    {
        "mfussenegger/nvim-lint",
        enabled = false,
        dependencies = { "rshkarin/mason-nvim-lint" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            linters_by_ft = {
                lua = { "selene" },
                luau = { "selene" },
                python = { "ruff" },
            },
            linters = {},
        },
        config = lint_config,
    },
}
