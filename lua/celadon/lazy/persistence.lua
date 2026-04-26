return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		-- add any custom options here
	},
	-- load the session for the current directory
	vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end),

	-- select a session to load
	vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end),

	-- load the last session
	vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end),

	-- stop Persistence => session won't be saved on exit
	vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end),

    init = function()
        -- Auto-load session for current directory on startup
        vim.api.nvim_create_autocmd("VimEnter", {
            group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
            callback = function()
                -- Only load if nvim was started with no arguments
                if vim.fn.argc() == 0 then
                    require("persistence").load()  -- Remove { last = true } to load current dir session
                end
            end,
            nested = true,
        })
        
        -- Clean up snacks buffers before saving
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) then
                        local ft = vim.bo[buf].filetype
                        if ft:match("^snacks_") then
                            vim.api.nvim_buf_delete(buf, { force = true })
                        end
                    end
                end
            end,
        })
    end,
}
