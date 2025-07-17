local spec = {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
}

spec.opts = {
    style = "night",
    transparent = vim.g.transparent_enabled,
    terminal_colors = true,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
        sidebars = vim.g.transparent_enabled and "transparent" or "dark",
        floats = "dark",
    },
    dim_inactive = true,
    cache = true,
    plugins = {
        all = true,
        auto = true,
    },
}

spec.config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
end

return spec
