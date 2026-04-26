return {
	"nvim-treesitter/nvim-treesitter-context",
	opts = {
		enable = true,
		max_lines = 3,        -- max lines the context window can take up
		min_window_height = 0,
		multiline_threshold = 20,
		trim_scope = "outer", -- which context to trim if too many lines: 'inner' or 'outer'
		mode = "cursor",      -- 'cursor' or 'topline'
		separator = nil,      -- separator between context and content (e.g. "-")
		zindex = 20,
	},
}
