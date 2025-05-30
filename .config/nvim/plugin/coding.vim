" nvim-treesitter/nvim-treesitter: Enable modules
lua << EOF
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "markdown_inline" }, -- required: auto_install misses parser needed for small help popup
		auto_install = true,
		highlight = { 
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		matchup = { -- (andymass/vim-matchup)
			enable = true,
		}
	})
EOF

" numToStr/Comment.nvim: Setup
lua require('Comment').setup()
