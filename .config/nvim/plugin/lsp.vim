lua <<EOF
-- hrsh7th/nvim-cmp: Load capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities();

-- mason-org/mason: Setup Mason
require('mason').setup()
require("mason-lspconfig").setup {
	automatic_enable = true
}

-- LanguageTool grammar check
vim.lsp.config("ltex", {
	cmd = { "env", "_JAVA_OPTIONS=-Djdk.xml.totalEntitySizeLimit=2500000 -Djdk.xml.entityExpansionLimit=2500000", "ltex-ls" },
	settings = {
		ltex = {
			enabled = { "latex", "tex", "bib", "markdown", "vimwiki" },
			language = "en-US",
			languageToolHttpServerUri = "http://lily:8081", -- (see: ~/.config/LanguageTool/)
			completionEnabled = true,
			-- sentenceCacheSize = 4000,
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

-- Dartls
-- Note: To disable analytics, you must run:
-- $ dart language-server --protocol=lsp --disable-analytics
vim.lsp.enable("dartls");
vim.lsp.config("dartls", { 
	capabilities = capabilities
});

-- hrsh7th/nvim-cmp: Add keymappings
-- f3fora/cmp-spell: Add cmp dictionary source
-- L3MON4D3/LuaSnip: Integrate snippets
local cmp = require("cmp");
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
	}),
	sources = {
		{ name = "buffer" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip", option = { show_autosnippets = true } },
		{ name = "spell",
			option = {
				keep_all_entries = false,
				enable_in_context = function()
					return true
				end,
			},
		},
	},
})

-- windwp/nvim-ts-autotag
require('nvim-ts-autotag').setup({
	opts = {
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = false
	},
	per_filetype = {
		["html"] = {
			enable_close = false
		}
	}
})

EOF
