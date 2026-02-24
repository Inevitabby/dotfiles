" catpuccin/nvim: Apply colorscheme
lua << EOF
require("catppuccin").setup({
    flavour = "auto",
    transparent_background = true,
    auto_integrations = true,
})
vim.cmd.colorscheme "catppuccin"
EOF

" psliwka/vim-smoothie: Even smoother animation
let g:smoothie_update_interval = 1
if g:slowComputer
	let g:smoothie_enabled = v:false
endif

" folke/zen-mode.nvim: Aesthetic tweaks
lua << EOF
	require("zen-mode").setup({
		window = {
			backdrop = 1, -- Keep background color consistent
			options = {
				number = false, -- Hide number column
				relativenumber = false, -- Hide relative numbers
			}
		},
		plugins = {
			twilight = {
				enabled = not vim.g.slowComputer,
			}
		},
		on_open = function(_)
			-- Quit Neovim if quitting from ZenMode (based on: https://github.com/folke/zen-mode.nvim/issues/54#issuecomment-1200155414)
			vim.cmd("cabbrev <buffer> q let b:quitFromZen = 1 <bar> q")
			vim.cmd("cabbrev <buffer> wq let b:quitFromZen = 1 <bar> wq")
			vim.cmd("cabbrev <buffer> x let b:quitFromZen = 1 <bar> x")
			-- Disable highlighting in Zen mode
			vim.opt.spell = false
		end,
		on_close = function()
			-- Quit Neovim if quitting from ZenMode
			if vim.b.quitFromZen == 1 then
				vim.b.quitFromZen = 0
				vim.cmd("q")
			end
			-- Reenable highlighting when leaving Zen mode
			vim.opt.spell = true
		end,
	})
EOF

" nvim-lualine/lualine.nvim: Fugitive integration and show when recording a macro (using folke/noice.nvim api)
lua << EOF
	local function word_count()
		if vim.bo.filetype ~= "vimwiki" then return "" end
		local wc = vim.fn.wordcount()
		return tostring(wc.words) .. " words"
	end
	local theme = require("lualine.themes.16color")
	for _, mode_config in pairs(theme) do
		for _, section_config in pairs(mode_config) do
			section_config.bg = "#1e1e2e"
		end
	end
	local options = {
		icons_enabled = false,
		-- component_separators = "",
		section_separators = "",
		theme = theme,
		extensions = { "fugitive" },
		sections = {
			lualine_c = {
				{'filename'},
				{word_count}
			},
			lualine_x = {
				{
					require("noice").api.statusline.mode.get,
					cond = require("noice").api.statusline.mode.has,
					color = { fg = "#ff9e64" },
				}
			},
		}
	}
	require("lualine").setup({ options = options })
EOF

" folke/noice.nvim: Setup
lua << EOF
	require("noice").setup({
		lsp = {  -- Disable LSP Indicator
			progress = { enabled = false },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		routes = { 
			{ -- Hide :write messages
				filter = {
					event = "msg_show",
					kind = "",
					find = "written",
				},
				opts = { skip = true },
			},
			{ --  Show notification when recording macro
				view = "notify",
				filter = {
					event = "msg_showmode",
					find = "recording",
				},
			},
		},
		views = { -- Less distracting cmdline popup
			cmdline_popup = {
				border = {
					style = "none",
					padding = { 1, 1 },
				},
				filter_options = {},
				win_options = {
					winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				},
			},
		},
	})
EOF

" rcarriga/nvim-notify: Set style, timeout, and load Telescope extension
lua << EOF
	require("notify").setup({
		render = "compact", 
		stages = vim.g.slowComputer and "static" or "slide",
		timeout = 2500,
	})
	require("telescope").load_extension("notify") 
EOF
