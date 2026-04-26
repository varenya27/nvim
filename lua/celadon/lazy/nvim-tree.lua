return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons", },
	config = function()
		local api = require("nvim-tree.api")
		require("nvim-tree").setup({
			sort = {
				sorter = "filetype",
			},
			view = {
				adaptive_size=false,
				width = 35,
				side = "left",
				number = false,
				relativenumber = true,
				preserve_window_proportions = true,
			},
			renderer = {
				root_folder_label = false,
				full_name = true,
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
				dotfiles = true,
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 500,
			},

			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>",{noremap=true, silent=true}),
			vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>",{noremap=true, silent=true}),
		})
	end
}
