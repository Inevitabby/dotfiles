" ===========
" Boilerplate
" ===========

" Don't be vi-compatible
set nocompatible

" Plugins and syntax highlighting
filetype plugin on
filetype indent on
syntax on

" Use <Space> as leader key
let g:mapleader = "\<Space>"

" =======
" Plugins
" =======

" Use experimental Lua module loader (for the byte-compilation cache)
lua vim.loader.enable()

" Flag to modify plugins for my slow laptop
let g:slowComputer = hostname() == "ThinkPad"

call plug#begin()
	" === Aesthetics ===
	" Catppuccin color scheme
	Plug 'catppuccin/nvim', { 'as': 'catppuccin', 'do': ':CatppuccinCompile' } 
	" Smooth-scrolling. WARNING: Causes lots of redraws!
	Plug 'psliwka/vim-smoothie'
	" Optimize UI for prose
	Plug 'folke/zen-mode.nvim' 
		" Toggle zen with \z
		nnoremap <silent> <leader>z <cmd>ZenMode<CR>
		" Automatically enable zen on markdown and todo.txt
		autocmd VimEnter *.md ZenMode
		autocmd VimEnter *todo.txt ZenMode
	" Dim lines except ones near cursor (uses TreeSitter for dimming)
	Plug 'folke/twilight.nvim' 
	" Status line
	Plug 'nvim-lualine/lualine.nvim' 
		" Icons for status line
		Plug 'nvim-tree/nvim-web-devicons' 
	" Experimental UI replacement
	Plug 'folke/noice.nvim'
		" UI Library for noice
		Plug 'MunifTanjim/nui.nvim'
		" Notification manager
		Plug 'rcarriga/nvim-notify'
	" View LSP results easily
	Plug 'folke/trouble.nvim'
		" Toggle trouble with \t
		nnoremap <silent> <leader>t <cmd>TroubleToggle<CR>

	" === Export & Preview ===
	" Preview markdown in-browser (note: use pre-built if you don't have node and yarn!)
	Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } 
		" Toggle markdown preview with \m
		nnoremap <silent> <leader>m <cmd>MarkdownPreviewToggle<CR>

	" === Prose ===
	" Intuitive Markdown bullet-points
	Plug 'dkarter/bullets.vim'
	" Knowledge management
	Plug 'vimwiki/vimwiki'
	" Seamless wrapping tweaks and undo points suited for prose (e.g. undo points on punctuation)
	Plug 'preservim/vim-pencil' 
		" Automatically enable in markdown/vimwiki and use soft wrapping
		autocmd FileType markdown,vimwiki call pencil#init({"wrap": "soft"}) | call litecorrect#init()
		" Minimal auto-correction (e.g., `teh` -> `the`, `Im` -> `I'm`, etc.)
		Plug 'preservim/vim-litecorrect' 
	" Detecting words/statements that are weak, weaselly, idiomatic, jargony, etc.
	Plug 'preservim/vim-wordy', { 'for': 'markdown' }

	" === Coding ===
	" Better highlighting
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
	" Git integration. (Most notable is ':G' for arbitrary git commands)
	Plug 'tpope/vim-fugitive' 
	" Contextual indentation highlighting
	Plug 'lukas-reineke/indent-blankline.nvim'
	" Set shiftwidth and expandtab automatically per-file
	Plug 'tpope/vim-sleuth'
	" Integrated keymappings to work with surrounding text
	Plug 'tpope/vim-surround'
	" Comment keymaps with treesitter integration
	Plug 'numToStr/Comment.nvim'

	" === Navigation ===
	" Fuzzy finder (optional system deps: `fd` and `ripgrep`)
	Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
		" Function library for Telescope
		Plug 'nvim-lua/plenary.nvim' 
		" - Replace default spell suggest menu with tiny Telescope modal
		map <silent> z= :Telescope spell_suggest theme=cursor<cr>
		" - Open live grep
		noremap <silent> <leader>l :Telescope live_grep<CR>
		" - Open file finder in current file's directory
		noremap <silent> <leader>f :lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<CR>
	" Edit filesystem like a buffer (netrw replacement)
	Plug 'stevearc/oil.nvim'
	" Integrate Vimwiki with Telescope
	Plug 'ElPiloto/telescope-vimwiki.nvim'
		" - \vw to search filenames
		nnoremap <silent> <leader>vw <cmd>lua require("telescope").extensions.vimwiki.vimwiki()<cr>
		" - \vg to live grep files
		nnoremap <silent> <leader>vg <cmd>lua require("telescope").extensions.vimwiki.live_grep()<cr>
	" Integration undo tree with Telescope (:Telescope undo)
	Plug 'debugloop/telescope-undo.nvim'
	" Extend "%" to language-specific words (uses TreeSitter)
	Plug 'andymass/vim-matchup'
	" Tabline
	Plug 'romgrk/barbar.nvim'
		" - Move to previous/next
		nnoremap <silent> <leader>, <Cmd>BufferPrevious<CR>
		nnoremap <silent> <leader>. <Cmd>BufferNext<CR>
		" - Re-order to previous/next
		nnoremap <silent> <leader>< <Cmd>BufferMovePrevious<CR>
		nnoremap <silent> <leader>> <Cmd>BufferMoveNext<CR>
		" - Goto buffer in position...
		nnoremap <silent> <leader>1 <Cmd>BufferGoto 1<CR>
		nnoremap <silent> <leader>2 <Cmd>BufferGoto 2<CR>
		nnoremap <silent> <leader>3 <Cmd>BufferGoto 3<CR>
		nnoremap <silent> <leader>4 <Cmd>BufferGoto 4<CR>
		nnoremap <silent> <leader>5 <Cmd>BufferGoto 5<CR>
		nnoremap <silent> <leader>6 <Cmd>BufferGoto 6<CR>
		nnoremap <silent> <leader>7 <Cmd>BufferGoto 7<CR>
		nnoremap <silent> <leader>8 <Cmd>BufferGoto 8<CR>
		nnoremap <silent> <leader>9 <Cmd>BufferGoto 9<CR>
		nnoremap <silent> <leader>0 <Cmd>BufferLast<CR>
		" - Pin/unpin buffer
		nnoremap <silent> <leader>p <Cmd>BufferPin<CR>
		" - Close buffer
		nnoremap <silent> <leader>q <Cmd>BufferClose<CR>
		" - Restore buffer
		nnoremap <silent> <leader>sq <Cmd>BufferRestore<CR>
		" - Sort by...
		nnoremap <silent> <leader>bb <Cmd>BufferOrderByBufferNumber<CR>
		nnoremap <silent> <leader>bd <Cmd>BufferOrderByDirectory<CR>
		nnoremap <silent> <leader>bl <Cmd>BufferOrderByLanguage<CR>
		nnoremap <silent> <leader>bw <Cmd>BufferOrderByWindowNumber<CR>

	" === LSP Zero ===
	" == LSP Support ==
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
	Plug 'williamboman/mason-lspconfig.nvim'
	" == Autocompletion ==
	Plug 'hrsh7th/nvim-cmp'
	" Completions based on the current buffer
	Plug 'hrsh7th/cmp-buffer' 
	" Completions based on the filesystem
	Plug 'hrsh7th/cmp-path' 
	" Completions based on built-in LSP
	Plug 'hrsh7th/cmp-nvim-lsp'
	" Completions based on built-in spellsuggest (dictionary)
	Plug 'f3fora/cmp-spell' 
	" == Snippet Engine ==
	Plug 'L3MON4D3/LuaSnip'
		Plug 'saadparwaiz1/cmp_luasnip'
	" == LSP Zero ==
	Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
call plug#end()

" ===================
" Non-Plugin Mappings
" ===================

" <F4> to open a nobuflisted terminal in a split at the bottom of screen cd'ed to the current file's directory (based on https://vi.stackexchange.com/a/14533)
noremap <silent> <F4> :let $VIM_DIR=expand('%:p:h')<CR>:bot split<Bar>:exe "resize " . (winheight(0) * 2/5)<Bar>:term<CR>cd $VIM_DIR && clear<CR>
" <F9> to open vertical split to the left with Oil
noremap <silent> <F9> :vnew<Bar>:exe "vert resize " . (winwidth(0) * 2/5)<Bar>:Oil<CR>
" <Esc> to leave terminal and change window focus
tnoremap <silent> <Esc> <C-\><C-n>:wincmd k<Bar>wincmd l<CR>
" <F4> to leave terminal without changing window focus
tnoremap <silent> <F4> <C-\><C-n>
" <Ctrl+l> to clear search highlights
nnoremap <silent> <c-l> :nohl<cr><c-l>
" <leader><space> to toggle focus on current line
map <silent> <leader>tw :Twilight<CR>zz
" <ctrl>s to save
nnoremap <silent> <c-s> :update <Bar> echo "Saving"<CR>
inoremap <silent> <c-s> <Esc>:update <Bar> echo "Saving"<CR>a
" <ctrl>f in insert-mode to fix previous word (https://web.archive.org/web/20231225131145/https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly)
inoremap <silent> <C-f> <c-g>u<Esc>[s1z=`]a<c-g>u

" HACK: Map ZZ and ZQ to their equivalent commands so that abbreviations for :x and :q also apply to them
map <silent> ZZ :x<CR>
map <silent> ZQ :q!<CR>

" ===================
" Non-Plugin Autocmds
" ===================

" Start in insert mode at top of file when entering gitcommits
autocmd FileType gitcommit :1 | :startinsert!
" Go into insert mode when entering terminal window
autocmd BufWinEnter,WinEnter term://* startinsert
" When opening terminal enter insert mode, hide from tabline, & hide line numbers
autocmd TermOpen * startinsert | setlocal nobuflisted | setlocal nonumber | setlocal norelativenumber
" Go into normal mode when exiting terminal window
autocmd BufLeave term://* stopinsert
" HACK: Delete the buffers of finished terminals (source: https://github.com/neovim/neovim/issues/14986#issuecomment-902705190)
autocmd TermClose * execute "bdelete! " . expand("<abuf>")

" ====
" Misc
" ====

" :W to Write as Sudo
" Based on https://vi.stackexchange.com/a/25038
com -bar W exe 'w !pkexec tee >/dev/null %:p:S' | setl nomod
com -bar Wq exe 'W' | quit

" Create Undo File Directory
" https://vi.stackexchange.com/a/53
if !isdirectory($HOME."/.cache/nvim/undo")
	call mkdir($HOME."/.cache/nvim/undo", "p", 0700)
endif

" ========
" Settings
" ========

" Mappings
set timeoutlen=500 " Wait 500ms instead of 1000ms for a mapping to complete

" Search Case (In)sensitivity and Highlight
set ignorecase " Ignore casing when searching
set smartcase " Override ignorecase if search pattern contains uppercase chars
set hlsearch " Highlight search (use `:noh` to shut off highlighting until next search)

" Matching Brackets
set showmatch " Jump to matching bracket briefly when inserting one
set matchtime=2 " How long to show the matching bracket (see: showmatch) in 1/10ths of a second

" No Swap/Backup File Spam
set nobackup
set noswapfile

" Auto/Smart Indent and Tab
set smartindent
set smarttab

" Wrap Lines Softly
set linebreak
set wrap

" Line Numbers and Ruler
set number
set relativenumber
set ruler

" Better Scrolling
set scrolloff=8 " Leave space between the top/bottom of the screen and the cursor.

" Enable Spell Check
set spell
set spelllang=en
set spellfile=~/.config/nvim/spell/en.utf-8.add

" System Integration
set autoread " Read file if changed
set clipboard=unnamedplus " Use system keyboard
set shell=/bin/zsh " Use zsh instead of bash in :terminal

" Save undo files ~/.cache/nvim/undo
set undodir=~/.cache/nvim/undo
set undofile
