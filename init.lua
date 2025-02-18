-- ========================================================================== --
-- ==                           	EDITOR SETTINGS                        == --
-- ========================================================================== --

vim.opt.number = true		-- show line numbers
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
-- ========================================================================== --
-- ==                         KEYBINDINGS                                  == --
-- ========================================================================== --


vim.g.mapleader = ','
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>')
vim.keymap.set({'n', 'x'}, 'gy', '"+y')
vim.keymap.set({'n', 'x'}, 'gp', '"+p')
vim.keymap.set({'n'}, '<leader>z', ':undo<cr>')
vim.keymap.set({'n'}, '<leader>y', ':redo<cr>')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
vim.keymap.set('n', '<space><space>', '<cmd>Lexplore<cr>')

--THIS IS TEMPORARY, USE LSP TO WRITE A MORE GENERAL WAY TO RUN CODE---------
vim.keymap.set('n', '<leader><CR>',':!python3 %<cr>')
-----------------------------------------------------------------------------

-- ========================================================================== --
-- ==                         BOILERPLATES                                 == --
-- ========================================================================== --

-- C files --
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.c",                    -- Trigger only for new .c files
	callback = function()
		vim.fn.append(0, {                 -- Insert lines at the top of the file
			'#include <stdio.h>',
			'#include <stdlib.h>',
			'',
			'int main() {',
			'    ',
			'    ',
			'    return 0;',
			'}',
		})
		vim.api.nvim_win_set_cursor(0, {5, 5}) -- set cursor inside the main function
	end,
})

-- Python Files --

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.py",                    -- Trigger only for new .py files
	callback = function()
		vim.fn.append(0, {                 -- Insert lines at the top of the file
			'import numpy as np',
			'import matplotlib.pyplot as plt',
			''      
		})
		vim.api.nvim_win_set_cursor(0, {4, 0}) -- set cursor inside the main function
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.sh",
	callback = function()
		vim.fn.append(0, {'#!/bin/bash',''})
		vim.api.nvim_win_set_cursor(0,{3,0})
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = {"*.md"},                    -- Trigger only for .md files in the seminars folder
	callback = function()
		local file_path = vim.fn.expand("%:p")  -- Get the full path of the current file
		if file_path:match(vim.fn.expand("~/OneDrive/onedrive/seminars/")) then
			vim.fn.append(0, {                 -- Insert lines at the top of the file
				'Speaker: ',
				"Date: " .. os.date("%Y-%m-%d"),
				'Topic:' ,
				'Location:',
				'',
				'# notes',
				'- '
			})
			vim.api.nvim_win_set_cursor(0, {7, 2}) -- set cursor inside the main function
		end	
	end,
})


vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.tex",
	callback = function()
		local boilerplate = [[
		\documentclass{article}

		\usepackage{graphicx} 
		\usepackage{color}
		\usepackage{float}
		\usepackage{amsfonts,amsmath,amssymb}
		\usepackage{enumitem}
		\usepackage{multirow}
		\usepackage{array}
		\usepackage{caption}
		\usepackage{subcaption}

		\title{Title}
		\author{Varenya Upadhyaya}
		\date{December 2024}

		\begin{document}
		\maketitle
		\section{Introduction}

		\end{document}
		]]
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(boilerplate, "\n"))
		vim.api.nvim_win_set_cursor(0,{20,0})
	end,
})

-- ========================================================================== --
-- ==                         PLUGINS                                      == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
	if not vim.loop.fs_stat(path) then
		print('Installing lazy.nvim....')
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable', -- latest stable release
			path,
		})
	end
end

function lazy.setup(plugins)
	if vim.g.plugins_ready then
		return
	end

	-- You can "comment out" the line below after lazy.nvim is installed
	--  lazy.install(lazy.path)

	vim.opt.rtp:prepend(lazy.path)

	require('lazy').setup(plugins, lazy.opts)
	vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
	--	{'folke/tokyonight.nvim'},
	--
	{'nvim-lualine/lualine.nvim'}, -- bottom right bar 
	{'windwp/nvim-autopairs'}, -- autopairing quotes and brackets
	{
		'sainnhe/everforest', --theme
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('everforest')
		end
	},
	-- Autocompletion plugin
	{
		"hrsh7th/nvim-cmp", dependencies = {
			"hrsh7th/cmp-nvim-lsp",          -- LSP source for nvim-cmp
			"hrsh7th/cmp-buffer",            -- Buffer completions
			"hrsh7th/cmp-path",              -- Path completions
			"hrsh7th/cmp-cmdline",           -- Command line completions
			"L3MON4D3/LuaSnip",              -- Snippet engine
			"saadparwaiz1/cmp_luasnip",      -- Snippet completions
		},
	},
	{"neovim/nvim-lspconfig"}, -- LSP Configurations for Neovim
	{
		"dccsillag/magma-nvim",
		build = ":UpdateRemotePlugins",  -- Required for remote plugins
		config = function()
			vim.g.magma_automatically_open_output = false -- Example config, adjust as needed
		end
	},
	--	{
		--		"meatballs/notebook.nvim"
		--	},
		{
			"lukas-reineke/indent-blankline.nvim", -- indentation lines
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},
		{
			"lervag/vimtex",
			lazy = false,     -- we don't want to lazy load VimTeX
			-- tag = "v2.15", -- uncomment to pin to a specific release
			init = function()
				-- VimTeX configuration goes here, e.g.
				vim.g.vimtex_view_method = "zathura"
			end
		},
		{
			"nvim-treesitter/nvim-treesitter"
		}
	})
	require('lualine').setup({
		options = {
			icons_enabled = false,
			section_separators = '',
			component_separators = '|'
		}
	}) -- bottom right bar
	require('nvim-treesitter')
	require('nvim-autopairs').setup{} -- autopair brackets and quotes
	require('ibl').setup()
	--[[require('notebook').setup{
		-- Whether to insert a blank line at the top of the notebook
		insert_blank_line = true,

		-- Whether to display the index number of a cell
		show_index = true,

		-- Whether to display the type of a cell
		show_cell_type = true,

		-- Style for the virtual text at the top of a cell
		virtual_text_style = { fg = "lightblue", italic = true },
	}
	local api = require("notebook.api")
	local settings = require("notebook.settings")

	function _G.define_cell(extmark)
		if extmark == nil then
			local line = vim.fn.line(".")
			extmark, _ = api.current_extmark(line)
		end
		local start_line = extmark[1] + 1
		local end_line = extmark[3].end_row
		pcall(function() vim.fn.MagmaDefineCell(start_line, end_line) end)
	end

	function _G.define_all_cells()
		local buffer = vim.api.nvim_get_current_buf()
		local extmarks = settings.extmarks[buffer]
		for id, cell in pairs(extmarks) do
			local extmark = vim.api.nvim_buf_get_extmark_by_id(
			0, settings.plugin_namespace, id, { details = true }
			)
			if cell.cell_type == "code" then
				define_cell(extmark)
			end
		end
	end

	vim.api.nvim_create_autocmd(
	{ "BufRead", },
	{ pattern = { "*.ipynb" }, command = "MagmaInit" }
	)
	vim.api.nvim_create_autocmd(
	"User",
	{ pattern = { "MagmaInitPost", "NBPostRender" }, callback = _G.define_all_cells }
	)--]]
	vim.g.netrw_banner = 0
	vim.g.netrw_winsize = 10
	vim.g.python3_host_prog = '/usr/bin/python3'
	vim.g.vimtex_view_method = 'zathura'
	vim.g.vimtex_compiler_method = 'latexmk'

	vim.g.vimtex_compiler_latexmk = {
		build_dir = 'build',
		options = {
			'-pdf',
			'-interaction=nonstopmode',
			'-synctex=1'
		}
	}
	-- ========================================================================== --
	-- ==                         AUTOCOMPLETE STUFF                           == --
	-- ========================================================================== --
	-- Reserve a space in the gutter
	vim.opt.signcolumn = 'yes'

	-- Add cmp_nvim_lsp capabilities settings to lspconfig
	-- This should be executed before you configure any language server
	local lspconfig_defaults = require('lspconfig').util.default_config
	lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lspconfig_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
	)

	-- This is where you enable features that only work
	-- if there is a language server active in the file
	vim.api.nvim_create_autocmd('LspAttach', {
		desc = 'LSP actions',
		callback = function(event)
			local opts = {buffer = event.buf}

			vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
			vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
			vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
			vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
			vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
			vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
			vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
			vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
			vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
			vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		end,
	})

	-- These are just examples. Replace them with the language
	-- servers you have installed in your system
	require('lspconfig').gleam.setup({})
	require('lspconfig').rust_analyzer.setup({})

	local cmp = require('cmp')

	cmp.setup({
		sources = {
			{name = 'nvim_lsp'},
		},
		snippet = {
			expand = function(args)
				-- You need Neovim v0.10 to use vim.snippet
				vim.snippet.expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({}),
	})








	-- ========================================================================== --
	-- ==                        COMMENTED OUT CHUNKS                          == --
	-- ========================================================================== --

	--[[ catpuccin themes
	{
		"catppuccin/nvim", --theme
		lazy = true,
		name = "catppuccin",
		opts = {
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		}, 
	} 
	]]
	--[[
	-- Set up nvim-cmp.
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	cmp.setup({
		snippet = {
			-- Use LuaSnip for snippets
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept selected item with Enter
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },         -- LSP source
			{ name = "luasnip" },          -- Snippet source
			{ name = "buffer" },           -- Buffer source
			{ name = "path" },             -- Path source
		}),
	})

	-- Set up completion for command line
	cmp.setup.cmdline(":", {
		sources = {
			{ name = "cmdline" }
		}
	})

	local lspconfig = require("lspconfig")

	-- Configure LSP for Python using pyright
	lspconfig.pyright.setup({
		on_attach = function(client, bufnr)
			-- Set up buffer-specific keymaps for LSP features 
		end,
	})


	]]
