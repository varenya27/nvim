return {
	"olimorris/persisted.nvim",
	lazy = false, -- must load immediately at startup
	opts = {
		use_git_branch = true,
		autoload = true,
	},
	init = function()
		-- Keymaps (these work because the plugin is loaded immediately)
		vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Session | Save", silent = true })
		vim.keymap.set("n", "<leader>sr", "<cmd>SessionLoad<cr>", { desc = "Session | Restore", silent = true })
		vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<cr>", { desc = "Session | Delete", silent = true })
		vim.keymap.set("n", "<leader>sS", "<cmd>SessionSelect<cr>", { desc = "Session | Search", silent = true })
		vim.keymap.set("n", "<leader>st", "<cmd>SessionToggle<cr>", { desc = "Session | Toggle", silent = true })
	end,
}

