vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>')

-- copy paste to clipboard
vim.keymap.set({'n', 'x'}, 'gy', '"+y')
vim.keymap.set({'n', 'x'}, 'gp', '"+p')
vim.keymap.set('n', '<C-a>', ':keepjumps normal! ggVG<cr>', {desc = "select all"})

-- run python
vim.keymap.set('n', '<leader>1', ':!python3 %<cr>')

-- screen splits
vim.keymap.set('n', '<leader>v', '<cmd>vsplit<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>split<cr>')

-- move screen
vim.keymap.set({'n','v'}, '<Up>', '<C-y>')
vim.keymap.set({'n','v'}, '<Down>', '<C-e>')

-- toggle window
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- code commenting
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- terminal stuff
local terminal_window = nil
local terminal_active = false
local current_window = vim.api.nvim_get_current_win()
vim.keymap.set({"n","t"}, "<C-t>", function ()
	if vim.bo.buftype ~= "terminal" then
		current_window = vim.api.nvim_get_current_win()
	end
	if terminal_window and vim.api.nvim_win_is_valid(terminal_window) then
		if terminal_active then
			vim.api.nvim_win_set_height(terminal_window, 1)
			vim.api.nvim_set_current_win(current_window)
			terminal_active = false
		else
			vim.api.nvim_win_set_height(terminal_window, math.floor(vim.o.lines * 0.3))
			vim.api.nvim_set_current_win(terminal_window)
			vim.cmd('startinsert')
			terminal_active = true
		end
	else
		vim.cmd('split')
		terminal_window = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_height(terminal_window, math.floor(vim.o.lines * 0.3))
		vim.cmd('terminal')
		vim.cmd('startinsert')
		terminal_active = true
	end
end, { noremap = true, silent = true, desc = "open terminal" })
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
vim.keymap.set("t", "<C-q>", "<C-\\><C-N><cmd>quit<cr>")

