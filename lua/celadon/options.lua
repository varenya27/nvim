vim.opt.rnu = true		-- show relative line numbers
vim.opt.mouse = 'a'			-- use mouse in all modes 
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.hlsearch = false
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.linebreak = true  -- soft break lines 
vim.opt.foldenable = true -- fold indented code blocks
vim.opt.foldmethod = 'indent' -- fold based on indentations
vim.opt.foldlevelstart = 0 -- fold all chunks 
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.undodir" -- make the directory first
vim.opt.termguicolors = true
