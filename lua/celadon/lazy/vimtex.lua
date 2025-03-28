return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.keymap.set("n","<leader><CR>",vim.cmd.VimtexCompile,{desc = "compile tex file"})
	end
}
