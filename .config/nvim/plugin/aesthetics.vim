" catpuccin/nvim: Apply colorscheme
colorscheme catppuccin

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
			twilight = { -- Don't start Twilight automatically
				enabled = false 
			}
		},
		-- Quit Neovim if quitting from ZenMode (based on: https://github.com/folke/zen-mode.nvim/issues/54#issuecomment-1200155414)
		on_open = function(_)
			vim.cmd("cabbrev <buffer> q let b:quitFromZen = 1 <bar> q")
			vim.cmd("cabbrev <buffer> wq let b:quitFromZen = 1 <bar> wq")
			vim.cmd("cabbrev <buffer> x let b:quitFromZen = 1 <bar> x")
		end,
		on_close = function()
			if vim.b.quitFromZen == 1 then
				vim.b.quitFromZen = 0
				vim.cmd("q")
			end
		end,
	})
EOF

" nvim-lualine/lualine.nvim: Fugitive integration and show when recording a macro (using folke/noice.nvim api)
lua << EOF
	require("lualine").setup({
		extensions = { "fugitive" },
		sections = {
			lualine_x = {
				{
					require("noice").api.statusline.mode.get,
					cond = require("noice").api.statusline.mode.has,
					color = { fg = "#ff9e64" },
				}
			},
		}
	})
EOF

" folke/noice.nvim: Setup
lua << EOF
	require("noice").setup({
		lsp = {  -- Disable LSP Indicator
			progress = { enabled = false }
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
		stages = "slide",
		timeout = 2500,
	})
	require("telescope").load_extension("notify") 
EOF
