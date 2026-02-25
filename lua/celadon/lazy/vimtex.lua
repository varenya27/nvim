return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_indent_on_enter = 1
		vim.g.vimtex_indent_lists={'enumerate','itemize'}
		vim.keymap.set("n","<leader><CR>",vim.cmd.VimtexCompile,{desc = "compile tex file"})
	end
}
