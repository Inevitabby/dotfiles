" lambdalisue/vim-suda
let g:suda_smart_edit = 1

" kawre/leetcode.nvim
lua << EOF
require('leetcode').setup({
	lang = "python",
})
EOF
