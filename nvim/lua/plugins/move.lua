return {
	"kovetskiy/neovim-move",
	cmd = { "Move" },
	opts = {},
	config = function()
		vim.cmd([[:UpdateRemotePlugins]])
		require("move").setup {}
	end,
}
