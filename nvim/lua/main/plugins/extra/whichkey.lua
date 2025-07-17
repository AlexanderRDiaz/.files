return {
    "folke/which-key.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show()
            end,
            desc = "Show which-key help",
        },
    },
    opts = {
        preset = "modern",
        replace = {
            key = {
                { "<leader>", "SPACE" },
                { "<Leader>", "SPACE" },
                { "<space>",  "SPACE" },
                { "<Space>",  "SPACE" },
                { "<cr>",     "RETURN" },
                { "<CR>",     "RETURN" },
                { "<Tab>",    "TAB" },
            },
        },
        win = {
            no_overlap = false,
            padding = { 0, 0 },
        },
        layout = {
            width = { max = 45 },
            spacing = 3,
        },
    },
    config = function(_, opts)
        local which_key = require("which-key")
        which_key.setup(opts)
        which_key.add({
            {
                { "<leader>f", group = "telescope" },
                { "<leader>p", group = "project" },
                { "<leader>t", group = "toggle" },
                { "<leader>x", group = "trouble" },
            },
        })
    end,
}
