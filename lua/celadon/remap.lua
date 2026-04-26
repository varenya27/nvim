vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>')
vim.keymap.set('n', '<leader>h', ':qa<cr>')

-- copy paste to clipboard
vim.keymap.set({'n', 'x', 'v'}, '<leader>y', ':OSCYank<CR>')
vim.keymap.set({'n', 'x'}, 'gy', '"+y')
vim.keymap.set({'n', 'x'}, 'gp', '"+p')
vim.keymap.set('n', '<M-a>', ':keepjumps normal! ggVG<cr>', {desc = "select all"})

-- screen splits
vim.keymap.set('n', '<leader>v', '<cmd>vsplit<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>split<cr>')

-- move screen
vim.keymap.set({'n','v'}, '<Up>', '3<C-y>')
vim.keymap.set({'n','v'}, '<Down>', '3<C-e>')

-- toggle window
vim.keymap.set({'n'}, "<C-h>", "<C-w>h", { desc = "switch window left" })
vim.keymap.set({'n'}, "<C-l>", "<C-w>l", { desc = "switch window right" })
vim.keymap.set({'n'}, "<C-j>", "<C-w>j", { desc = "switch window down" })
vim.keymap.set({'n'}, "<C-k>", "<C-w>k", { desc = "switch window up" })


vim.keymap.set({'t'}, "<C-h>", "<C-\\><C-N><C-w>h", { desc = "exit term & switch window left" })
vim.keymap.set({'t'}, "<C-l>", "<C-\\><C-N><C-w>l", { desc = "exit term & switch window right" })
vim.keymap.set({'t'}, "<C-j>", "<C-\\><C-N><C-w>j", { desc = "exit term & switch window down" })
vim.keymap.set({'t'}, "<C-k>", "<C-\\><C-N><C-w>k", { desc = "exit term & switch window up" })

-- resize windows
vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<A-j>", ":resize +2<CR>")
vim.keymap.set("n", "<A-k>", ":resize -2<CR>")

-- code commenting
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- show error floating block
vim.keymap.set("n", "<M-e>", function()
    vim.diagnostic.open_float()
end, { silent = true })

-- terminal stuff
local terminal_window = nil
local terminal_active = false
local current_window = vim.api.nvim_get_current_win()
vim.keymap.set({"n","t"}, "<A-t>", function ()
	if vim.bo.buftype ~= "terminal" then
		current_window = vim.api.nvim_get_current_win()
	end
	if terminal_window and vim.api.nvim_win_is_valid(terminal_window) then
		-- terminal window has been created already
		if terminal_active then
			-- if inside terminal, exit
			vim.api.nvim_win_set_height(terminal_window, 1)
			vim.api.nvim_set_current_win(current_window)
			terminal_active = false
		else
			-- else enter terminal
			vim.api.nvim_win_set_height(terminal_window, math.floor(vim.o.lines * 0.3))
			vim.api.nvim_set_current_win(terminal_window)
			vim.cmd('startinsert')
			terminal_active = true
		end
	else
		-- make new terminal window
		vim.cmd('split')
		terminal_window = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_height(terminal_window, math.floor(vim.o.lines * 0.3))
		vim.cmd('terminal')
		vim.cmd('startinsert')
		terminal_active = true
	end
end, { noremap = true, silent = true, desc = "open terminal" })
vim.keymap.set("t", "<C-;>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
vim.keymap.set("t", "<C-q>", "<C-\\><C-N><cmd>quit<cr>")

-- run python code in current open terminal 
vim.keymap.set({"n"},"<leader>2", function ()
	if terminal_window and not terminal_active then
		local file_path = vim.fn.expand("%:p")
		local file_dir = vim.fn.expand("%:p:h")
		local file_extension = vim.fn.expand("%:e")
		if file_extension ~= "py" then
			print('only works for python files, sorry')
			return
		end
		local cmd = 'cd ' .. file_dir .. '&& python ' .. file_path
		cmd = 'ls'
		vim.api.nvim_win_set_height(terminal_window, math.floor(vim.o.lines * 0.3))
		vim.api.nvim_set_current_win(terminal_window)
		vim.cmd('startinsert')
		terminal_active = true
		local row,col = unpack(vim.api.nvim_win_get_cursor(terminal_window))
		vim.api.nvim_buf_set_text(0,row-1,col-1,row-1,col-1,{cmd})
	else
		print('could not find terminal!')
	end
end,
	{desc="run python code"})

-- Yank current diagnostic to clipboard
vim.keymap.set("n", "<M-y>", function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1  -- 0-indexed
    local diags = vim.diagnostic.get(0, { lnum = line })
    if #diags > 0 then
        local msg = diags[1].message  -- first diagnostic on the line
        vim.fn.setreg("+", msg)      -- copy to system clipboard
        print("Diagnostic copied: " .. msg)
    else
        print("No diagnostic on this line")
    end
end, { desc = "Yank current diagnostic" })
