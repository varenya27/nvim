return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 25,
				side = "left",
				number = false,
				relativenumber = true,
				preserve_window_proportions = true,
			},
			renderer = {
				root_folder_label = false,
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
			vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>",{noremap=true, silent=true}),
			vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>",{noremap=true, silent=true}),
		})
	end
}
