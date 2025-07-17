local none_spec = { "nvimtools/none-ls.nvim", enabled = true }

none_spec.cmd = {
    "NullLsInfo",
    "NullLsLog",
}

none_spec.opts = function()
    return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
    }
end

local autoload_spec = {
    "zeioth/none-ls-autoload.nvim",
    enabled = true,
    dependencies = {
        "mason-org/mason.nvim",
        "nvimtools/none-ls.nvim",
    },
    config = false,
}

return { none_spec, autoload_spec }
