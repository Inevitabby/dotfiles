" nvim-treesitter/nvim-treesitter: Enable modules
lua << EOF
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			-- Config Files
			"json",
			"json5",
			"yaml",
			-- Web & Node
			"twig",
			"html",
			"javascript",
			"css",
			"typescript",
			-- Markup
			"markdown",
			"markdown_inline",
			"todotxt",
			-- Portable Scripting Languages
			"bash", 
			"lua",
			-- C
			"c",
			-- Git
			"diff",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
		},
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
