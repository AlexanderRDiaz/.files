return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    keys = {
        { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { desc = "Telescope: Find files" } },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { desc = "Telescope: Live grep" } },
        { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { desc = "Telescope: Buffers" } },
        { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", { desc = "Telescope: Help tags" } },
    },
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
}


