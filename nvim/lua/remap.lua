-- Arrow key remaps
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")

vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("i", "<Left>", "<nop>")
vim.keymap.set("i", "<Right>", "<nop>")

vim.keymap.set("v", "<Up>", "<nop>")
vim.keymap.set("v", "<Down>", "<nop>")
vim.keymap.set("v", "<Left>", "<nop>")
vim.keymap.set("v", "<Right>", "<nop>")

function EscapePair()
    local closers = { ")", "]", "}", ">", "'", "\"", "`", "," }
    local line = vim.api.nvim_get_current_line()
    local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    local after = line:sub(col + 1, -1)
    local closer_col = #after + 1
    local closer_i = nil
    for i, closer in ipairs(closers) do
        local cur_index, _ = after:find(closer)
        if cur_index and (cur_index < closer_col) then
            closer_col = cur_index
            closer_i = i
        end
    end
    if closer_i then
        vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
    else
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
    end
end

vim.keymap.set("i", "<C-l>", EscapePair)

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Go to explorer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ'z", { desc = "Move line below up to end of current line" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump half the of the screen up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump half the of the screen down" })

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste over selection" })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Copy options into OS clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Copy selection into OS clipboard" })

vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Copy line into OS clipboard" })

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" }
)

vim.keymap.set("i", "<C-e>", "<C-o>A")
