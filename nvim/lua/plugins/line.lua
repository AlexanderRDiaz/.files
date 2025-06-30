local function opts()
    local symbols = require("util.symbols")

    local result = {
        options = {
            theme = "auto",
            component_separators = "",
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    separator = { left = "" },
                    right_padding = 2,
                },
            },
            lualine_b = {
                {
                    "filename",
                    file_status = false,
                },
                "require(\"arrow.statusline\").text_for_statusline_with_icons()",
                "branch",
            },
            lualine_c = {
                "%=",
            },
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_lsp", "nvim_diagnostic" },
                    symbols = {
                        error = symbols.diagnostics.error .. " ",
                        warn = symbols.diagnostics.warn .. " ",
                        info = symbols.diagnostics.info .. " ",
                        hint = symbols.diagnostics.hint .. " ",
                    },
                    update_in_insert = true,
                    always_visible = true,
                },
            },
            lualine_y = {
                {
                    "filetype",
                    icon_only = true,
                },
                {
                    "fileformat",
                    symbols = {
                        unix = "",
                        dos = "",
                        mac = "",
                    },
                    "progress",
                },
            },
            lualine_z = {
                {
                    "location",
                    separator = { right = "" },
                    left_padding = 2,
                },
            },
        },
    }

    return result
end

return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 999,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "otavioschwanck/arrow.nvim",
    },
    opts = opts,
}
