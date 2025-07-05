return {
    {
        "rcarriga/nvim-notify",
        lazy = false,
        init = function()
            vim.notify = require("notify")
        end,
    },

    {
        "mrded/nvim-lsp-notify",
        lazy = false,
        dependencies = { "rcarriga/nvim-notify" },
        opts = function()
            local symbols = require("main.util.symbols")

            return {
                icons = {
                    spinner = symbols.progress_spinner,
                    done = symbols.checkmark,
                },
            }
        end,
    },
}
