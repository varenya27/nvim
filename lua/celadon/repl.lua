-- Pick terminal where the code will be run
local function activate_terminal()
	local job = vim.b.terminal_job_id
	if job then
		vim.g.active_terminal_job = job
		vim.g.active_terminal_buf = vim.api.nvim_get_current_buf()
		vim.g.ipython_active = false
		print("Terminal added")
		return true
	end
	print("Not inside a terminal")
	return false
end

-- Helper function to send text to registered terminal
local function send_to_terminal(text)
	if not vim.g.active_terminal_job then
		print("No terminal registered. Press Alt+Enter inside a terminal.")
		return false
	end

	-- Use IPython's exec to run as a single block
	local cmd = string.format('exec("""%s""")\n', text)
	vim.fn.chansend(vim.g.active_terminal_job, cmd)


	-- Use IPython's cpaste mode for safe multi-line execution
	-- vim.fn.chansend(vim.g.active_terminal_job, "%cpaste -q\n")
	-- vim.wait(10)  -- Give IPython time to enter paste mode
	-- vim.fn.chansend(vim.g.active_terminal_job, text .. "\n")
	-- vim.fn.chansend(vim.g.active_terminal_job, "--\n")

	return true
end

-- Run code block in the assigned terminal 
local function run_block()
	local cur = vim.fn.line(".") - 1  -- 0-based
	local start = 0

	-- search upward for nearest "# %%"
	for i = cur, 0, -1 do
		local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
		if line:match("^# %%") or line:match("^#%%") then
			start = i + 1
			break
		end
	end

	local lines = vim.api.nvim_buf_get_lines(0, start, -1, false)

	local block = {}
	for _, line in ipairs(lines) do
		if line:match("^# %%") or line:match("^#%%") then
			break
		end
		table.insert(block, line)
	end

	send_to_terminal(table.concat(block, "\n") .. "\n")
end

-- Activate terminal or run code block
vim.keymap.set("n", "<M-CR>", function()
	local terminal_job_id = vim.b.terminal_job_id

	-- If not inside terminal, try running block
	if not terminal_job_id then
		local ext = vim.fn.expand("%:e")
		if ext == "py" then
			if vim.g.ipython_active then
				run_block()
			else
				print('Activate ipython first!')
				return
			end
		else
			print('Not a python file!')
		end
	-- otherwise activate terminal 
	else
		activate_terminal()
		vim.fn.chansend(vim.g.active_terminal_job, "ipython --no-autoindent\n")
		vim.g.ipython_active = true
	end
end, { desc = "Activate terminal or run code block" })

-- Run file in activated terminal
vim.keymap.set("n", "<C-CR>", function ()
	local ext = vim.fn.expand("%:e")
	local terminal = vim.g.active_terminal_job

	if activate_terminal() then
		return
	end

	if #vim.fn.win_findbuf(vim.g.active_terminal_buf) <= 0 then
		-- print(vim.fn.win_findbuf(terminal))
		print("Terminal isn't visible, consider reactivating another one")
		return
	end

	if ext == "py" then
		if vim.g.ipython_active then
			vim.fn.chansend(terminal, "%run " .. vim.fn.expand("%:p") .. "\n")
		else
			vim.fn.chansend(terminal, "cd " .. vim.fn.expand("%:p:h") .. " && python3 " .. vim.fn.expand("%:p") .. "\n")
		end
		print('Running ' .. vim.fn.expand("%"))
	else
		print('Python files only for now')
	end
end, { noremap = true, silent = true })

-- Override iron keymaps to use registered terminal
vim.keymap.set("n", "<space>sl", function()
	local line = vim.api.nvim_get_current_line()
	send_to_terminal(line .. "\n")
end, { desc = "Send line to terminal" })

vim.keymap.set("v", "<space>sc", function()
	local lines = vim.api.nvim_buf_get_lines(0, vim.fn.line("'<")-1, vim.fn.line("'>"), false)
	send_to_terminal(table.concat(lines, "\n") .. "\n")
end, { desc = "Send selection to terminal" })

