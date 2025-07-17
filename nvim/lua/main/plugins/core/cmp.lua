local spec = { "hrsh7th/nvim-cmp" }

spec.event = { "InsertEnter", "CmdlineEnter" }

spec.dependencies = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "supermaven-inc/supermaven-nvim",
}

local _kind_priority = {
    {
        "Field",
        "Property",
    },
    { "Constant" },
    {
        "Enum",
        "EnumMember",
        "Event",
        "Function",
        "Method",
        "Operator",
        "Reference",
        "Struct",
    },
    { "Variable" },
    {
        "File",
        "Folder",
    },
    {
        "Color",
        "Class",
        "Module",
    },
    { "Keyword" },
    {
        "Constructor",
        "Interface",
        "Text",
        "TypeParameter",
        "Unit",
        "Value",
    },
    { "Snippet" },
}

local kind_priority = {}
for i = 1, #_kind_priority do
    local priority = #_kind_priority - i

    for _, kind in ipairs(_kind_priority[i]) do
        kind_priority[kind] = priority
    end
end

local function kind_comparator(entry1, entry2)
    local lspTypes = require("cmp.types").lsp

    if entry1.source.name ~= "nvim_lsp" then
        if entry2.source.name ~= "nvim_lsp" then
            return nil
        else
            return false
        end
    end

    local kind1 = lspTypes.CompletionItemKind[entry1:get_kind()]
    local kind2 = lspTypes.CompletionItemKind[entry2:get_kind()]

    local priority1 = kind_priority[kind1] or 0
    local priority2 = kind_priority[kind2] or 0

    if priority1 == priority2 then
        return nil
    end

    return priority2 < priority1
end

spec.opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    return {
        enabled = function()
            local disabled = (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
                or (vim.fn.reg_recording() ~= "")
                or (vim.fn.reg_executing() ~= "")
                or require("cmp.config.context").in_treesitter_capture("comment")
            return not disabled
        end,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = entry.source.name
                return vim_item
            end,
        },
        sorting = {
            comparators = {
                kind_comparator,
                function(entry1, entry2)
                    return entry1.completion_item.label < entry2.completion_item.label
                end,
            },
        },
        sources = cmp.config.sources({
            {
                name = "nvim_lsp",
                max_item_count = 10,
                priority = 3,
            },
            { name = "path",    max_item_count = 5, priority = 2 },
            { name = "luasnip", keyword_length = 3, max_item_count = 5, priority = 1 },
            --{ name = "supermaven" },
            { name = "lazydev" },
        }, {
            { name = "buffer", keyword_length = 3, max_item_count = 5 },
        }),
        mapping = cmp.mapping.preset.insert {
            ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    else
                        cmp.confirm {
                            select = true,
                        }
                    end
                else
                    fallback()
                end
            end, { "i" }),

            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-u>"] = cmp.mapping.scroll_docs(4),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        },
    }
end

spec.config = function(_, opts)
    local cmp = require("cmp")

    cmp.setup(opts)

    cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        },
    })

    cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })
end

return spec
