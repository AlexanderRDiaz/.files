local spec = {
    "nvim-telescope/telescope.nvim",
    lazy = true,
}

spec.tag = "0.1.8"

spec.cmd = "Telescope"

spec.keys = {
    { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Telescope: Find files" },
    { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>",  desc = "Telescope: Live grep" },
    { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>",    desc = "Telescope: Buffers" },
    { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>",  desc = "Telescope: Help tags" },
}

spec.dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
}

return spec
