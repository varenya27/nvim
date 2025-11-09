return {
	{
		"ojroques/vim-oscyank",
		event = "VeryLazy", -- load lazily
		keys = {
			{ "<leader>y", ":OSCYank<CR>", mode = "v", desc = "Yank to system clipboard (OSC52)" },
		},
		config = function()
			-- Auto-use OSC52 when yanking into the + register

			vim.api.nvim_create_autocmd("TextYankPost", {
				callback = function()
					if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
						vim.cmd("OSCYankRegister +")
					end
				end,
			})
		end,
	},
}

