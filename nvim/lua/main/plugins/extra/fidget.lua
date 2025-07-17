local spec = {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
}

spec.opts = {
    notification = {
        override_vim_notify = true,
        window = {
            winblend = 0,
            relative = "editor",
        },
    },
}

return { spec }
