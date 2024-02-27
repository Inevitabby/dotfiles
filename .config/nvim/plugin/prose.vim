" dkarter/bullets.vim: Only activate in Markdown, Text, and Gitcommit
let g:bullets_enable_in_empty_buffers = 1 " Enable in empty buffers
let g:bullets_enabled_file_types = [ "markdown", "text", "scratch", "gitcommit" ] " Only enable on Markdown, Text, Scratch, and Gitcommit
let g:bullets_outline_levels = [ 'abc', 'num', 'std-', 'std*', 'std+' ]

" vimwiki/vimwiki: Setup
" Set Vimwiki filepaths and use the Markdown extension
let g:vimwiki_list = [{"path": "~/Sync/Notes/", "syntax": "markdown", "ext": ".md", "html_filename_parameterization": 0 }] 
let g:vimwiki_diary_rel_path="Personal/Diary"
" Export Vimwiki Markdown with Pandoc
let g:vimwiki_custom_wiki2html=$HOME."/.config/nvim/pandoc/vimwiki_converter.sh"
" Disable bullet-point mappings (conflicts with dkarter/bullet.vim)
let g:vimwiki_key_mappings = { "lists": 0 }
" Enable folding
let g:vimwiki_folding="syntax:quick"
