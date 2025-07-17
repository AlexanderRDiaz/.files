local supermaven = {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
}

supermaven.events = {
    "SupermavenStart",
    "SupermavenStop",
    "SupermavenRestart",
    "SupermavenToggle",
    "SupermavenStatus",
    "SupermavenUseFree",
    "SupermavenUsePro",
    "SupermavenLogout",
    "SupermavenShowLog",
    "SupermavenClearLog",
}

supermaven.opts = {
    keymaps = {
        accept_suggestion = "<C-a>a",
        clear_suggestion = "<C-a>c",
        accept_word = "<C-a>w",
    },
}

return supermaven
