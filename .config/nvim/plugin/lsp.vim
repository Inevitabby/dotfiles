" mason-org/mason: Setup Mason
lua <<EOF
	require('mason').setup()

	-- LanguageTool grammar check
	require("lspconfig").ltex.setup({
		settings = {
			ltex = {
				enabled = { "latex", "tex", "bib", "markdown", "vimwiki" },
				language = "en-US",
				-- completionEnabled = true,
				sentenceCacheSize = 4000,
				additionalRules = {
					enablePickyRules = true,
					motherTongue = "en-US",
				},
				disabledRules = {
					['en-US'] = {
						-- Native spell check has better integration (]s, [s, and z=)
						"MORFOLOGIK_RULE_EN_US",
						-- Keeps lighting up my Markdown tables like a Christmas tree (https://github.com/valentjn/vscode-ltex/issues/605)
						"WHITESPACE_RULE",
						"COMMA_PARENTHESIS_WHITESPACE",
						-- Keeps telling me to replace "criminal" with "kryminalista" for some reason.
						"CRIMINAL",
						-- Too Picky Rules
						"EN_QUOTES",
						"ELLIPSIS", 
						"ARROWS",
						"DASH_RULE", -- Interferes w/ lists
						"CURRENCY", -- Interferes w/ KaTeX/LaTeX embedded in Markdown
					}
				}
			}
		}
	});
EOF

" f3fora/cmp-spell: Add cmp dictionary source
lua <<EOF
require("cmp").setup({
	sources = {
		{
			name = "nvim_lsp"
		},
		{
			name = "spell",
			option = {
				keep_all_entries = false,
				enable_in_context = function()
				return true
				end,
			},
		},
	},
})
EOF
