local spec = {
    "L3MON4D3/LuaSnip",
}

spec.build = "make install_jsregexp"

spec.event = { "InsertEnter" }

spec.keys = {
    {
        "<C-s>e",
        "<cmd>lua require('luasnip').expand()<cr>",
        silent = true,
        mode = "i",
        desc = "Expand snippet",
    },
    {
        "<C-s>;",
        "<cmd>lua require('luasnip').jump(1)<cr>",
        silent = true,
        mode = { "i", "s" },
        desc = "Jump to next node in snippet",
    },
    {
        "<C-s>,",
        "<cmd>lua require('luasnip').jump(-1)<cr>",
        silent = true,
        mode = { "i", "s" },
        desc = "Jump to previous node in snippet",
    },
    {
        "<C-E>",
        function()
            if require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
            end
        end,
        silent = true,
        mode = { "i", "s" },
        desc = "Change snippet choice",
    },
}

spec.dependencies = { "rafamadriz/friendly-snippets" }

spec.opts = function()
    local types = require("luasnip.util.types")

    return {
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "●", "GruvboxOrange" } },
                },
            },
            [types.insertNode] = {
                active = {
                    virt_text = { { "●", "GruvboxBlue" } },
                },
            },
        },
    }
end

spec.config = function(_, opts)
    local luasnip = require("luasnip")
    luasnip.config.setup(opts)
    require("luasnip.loaders.from_vscode").lazy_load()
end

return spec
