return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local api = require("nvim-tree.api")
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
				side = "left",
				number = false,
				relativenumber = true,
				preserve_window_proportions = true,
			},
			renderer = {
				-- root_folder_label = true,
				group_empty = true,
				highlight_git = true,
				highlight_opened_files = "all",
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "⟩",
						edge = "|",
						item = "⟩",
						bottom = "─",
						none = " ",
					},
				},
			},
			filters = {
				dotfiles = false,
				custom = {".git"}
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 500,
			},

			-- on_attach = function(bufnr)
			-- 	local function opts(desc)
			-- 		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			-- 	end
			--
			-- 	-- Custom function to check if there's already an open file
			-- 	local function smart_open()
			-- 		local win_count = #vim.api.nvim_list_wins()  -- Count open windows
			-- 		local node = api.tree.get_node_under_cursor()
			-- 		if node.nodes then
			-- 			api.node.open.edit() -- open directory
			-- 		end
			-- 		if node and not node.nodes then -- If it's a file (not a folder)
			-- 			if win_count > 1 then
			-- 				api.node.open.vertical()  -- Open in vertical split
			-- 			else
			-- 				api.node.open.edit()  -- Open normally
			-- 			end
			-- 		end
			-- 	end
			--
			-- 	-- Set `<CR>` (Enter) to use smart open behavior
			-- 	vim.keymap.set("n", "<CR>", smart_open, opts("Smart Open File"))
			-- end,
			--

			vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>",{noremap=true, silent=true}),
			vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>",{noremap=true, silent=true}),
			-- vim.keymap.set("n", "<leader><CR>", function()
			-- 	local node = api.tree:get_node_under_cursor()
			-- 	if  node.name:match("%.(pdf)$") or node.name:match("%.(djvu)$") then
			-- 		print('opened in okular')
			-- 		vim.system({"okular",node.absolute_path})
			-- 	else
			-- 		api.node.open.edit() -- Default file opening behavior
			-- 	end
			-- end, {noremap=true,silent=true}),
			-- -- vim.keymap.set("n", "<C-CR>", api.tree.change_root_to_node,{noremap=true, silent=true},opts("CD"))
		})
	end
}
