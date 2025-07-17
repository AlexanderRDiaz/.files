local spec = {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 999,
}

spec.dependencies = {
    "nvim-tree/nvim-web-devicons",
    "otavioschwanck/arrow.nvim",
}

spec.opts = function()
    local symbols = require("main.util.symbols")
    local colors = require("tokyonight.colors").setup()

    local state_colors = {
        normal = colors.blue,
        insert = colors.green,
        visual = colors.purple,
        replace = colors.red,
        command = colors.yellow,
        inactive = colors.fg_gutter,
    }

    local theme = {}
    local base = { fg = "None", gui = "bold" }
    for state, color in pairs(state_colors) do
        theme[state] = {
            a = { fg = colors.black, bg = color, gui = "bold" },
            b = base,
            c = base,
            x = base,
            y = base,
            z = { fg = colors.black, bg = color, gui = "bold" },
        }
    end

    local mode = {
        "mode",
        separator = { left = "", right = "" },
    }

    local filetype = {
        "filetype",
        colored = true,
        icon_only = true,
        seperator = "",
        padding = { left = 1, right = 0 },
    }

    local filename = {
        "filename",
        file_status = false,
        symbols = {
            unnamed = "[unnamed]",
            newfile = "[new]",
        },
        padding = { left = 0, right = 1 },
        fmt = function(str)
            if vim.bo.filetype == "netrw" then
                return "netrw"
            end

            return string.lower(str)
        end,
    }

    local branch = {
        "branch",
    }

    local diff = {
        "diff",
        diff_color = {
            added = { fg = colors.green, bg = "None" },
            modified = { fg = colors.orange, bg = "None" },
            removed = { fg = colors.red, bg = "None" },
        },
    }

    local diagnostics = {
        "diagnostics",
        sources = { "nvim_lsp", "nvim_diagnostic" },
        symbols = {
            error = symbols.diagnostics.error .. " ",
            warn = symbols.diagnostics.warn .. " ",
            info = symbols.diagnostics.info .. " ",
            hint = symbols.diagnostics.hint .. " ",
        },
        update_in_insert = true,
    }

    local searchcount = {
        "searchcount",
    }

    local selectioncount = {
        "selectioncount",
        fmt = function(str)
            return "󰸱 " .. str
        end,
        cond = function()
            return vim.fn.mode() == "v"
        end,
    }

    local seperator = {
        "%=",
        padding = { left = 0, right = 0 },
    }

    local arrow = {
        "require('arrow.statusline').text_for_statusline_with_icons()",
    }

    local cwd = {
        function()
            return vim.fn.getcwd()
        end,
        fmt = function(str)
            return string.gsub(str, "^/Users/%a+", "~")
        end,
    }

    local encoding = {
        "encoding",
        show_bomb = true,
    }

    local fileformat = {
        "fileformat",
        symbols = {
            unix = "lf",
            dos = "cr-lf",
            mac = "cr",
        },
    }

    local location = {
        function()
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            return string.format("%s:%s | %2d%%%%", r, c, r / vim.fn.line("$") * 100)
        end,
        separator = { left = "", right = "" },
    }

    local result = {
        options = {
            theme = theme,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            fmt = string.lower,
        },
        sections = {
            lualine_a = { mode },
            lualine_b = { filetype, filename },
            lualine_c = { branch, diff },
            lualine_x = { diagnostics, searchcount, selectioncount, seperator },
            lualine_y = { arrow, cwd, encoding, fileformat },
            lualine_z = { location },
        },
    }

    return result
end

return spec
