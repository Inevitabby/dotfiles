" folke/twilight.nvim: Change highlight settings to be less ass for prose
lua require("twilight").setup({ dimming = { alpha = 0.5 }, context = 0, expand = { "paragraph", "fenced_code_block", "list" } })
      
" === Markdown Syntax Keymaps ===
" Affects selection (visual mode), last-written word (insert mode), and word under cursor (normal mode), respectively
" Alt-b to bold 
vmap <A-b> di****<ESC>hPE
imap <A-b> <ESC>diwi****<ESC>hPEa
nmap <A-b> diwi****<ESC>hPE
" Alt-i to italicize
vmap <A-i> di**<ESC>PE
imap <A-i> <ESC>diwi**<ESC>PEa
nmap <A-i> diwi**<ESC>PE
" Alt-u to underline
vmap <A-u> di[<ESC>pa]{.underline}
imap <A-u> <ESC>diwi[<ESC>pa]{.underline}
nmap <A-u> diwi[<ESC>pa]{.underline}
" Alt-c to backtick-ify
vmap <A-c> di``<ESC>PE
imap <A-c> <ESC>diwi``<ESC>PEa
nmap <A-c> diwi``<ESC>PE
" Alt-s to strike-through
vmap <A-s> di~~~~<ESC>hPE
imap <A-s> <ESC>diwi~~~~<ESC>hPEa
nmap <A-s> diwi~~~~<ESC>hPE
" Alt+' to single-quote
vmap <A-'> di''<ESC>PE
imap <A-'> <ESC>diwi''<ESC>PEa
nmap <A-'> diwi''<ESC>PE
" Alt+" to double-quote
vmap <A-"> di""<ESC>PE
imap <A-"> <ESC>diwi""<ESC>PEa
nmap <A-"> diwi""<ESC>PE

" === Pandoc Integration ===
" == Keymaps ==
nnoremap <silent> <leader>pp :PandocMarkdownToPdf<CR>
nnoremap <silent> <leader>ppl :PandocMarkdownToPdfLivePreview<CR>
nnoremap <silent> <leader>pf :PandocMarkdownToFphw<CR>
nnoremap <silent> <leader>pfl :PandocMarkdownToFphwLivePreview<CR>
nnoremap <silent> <leader>pm :PandocMarkdownToMla<CR>
nnoremap <silent> <leader>pml :PandocMarkdownToMlaLivePreview<CR>
nnoremap <silent> <leader>ps :PdfStats<CR>
" == Filetype Fixes & Setup ==
" Disable folding module
let g:pandoc#modules#disabled = [ "folding" ] 
" == Custom Functions ==
" Convert a Markdown file to a PDF with Pandoc using XeLaTeX.
function PandocMultitool (pandocArgs, livePreview=0, silent=0)
	let l:baseCommand = "pandoc -t pdf --from markdown+hard_line_breaks+lists_without_preceding_blankline+smart --pdf-engine=xelatex --wrap=preserve --resource-path .:~/.config/nvim/pandoc/"
	let l:outputPath = "/tmp/nvim-pandoc-" .. expand("%:t:r") .. ".pdf"
	let l:command = l:baseCommand .. " --output \"" .. l:outputPath .. "\" " .. a:pandocArgs .. " \"" .. expand("%:p") .. "\""
	" Print stderr
	function! HandleStderr(channel, msg, event)
		if a:msg[0] != ''
			echo join(a:msg, " ")
		endif
	endfunction
	" Execute Pandoc
	if a:silent
		silent call jobstart(l:command)
	else
		call jobstart(l:command, { 'on_stderr': function('HandleStderr'), "stderr_buffered": 1 })
	endif
	" Start Live Preview
  	if a:livePreview
  		silent exec "autocmd BufWritePost * silent call jobstart('" .. l:command .. "')"
		let l:xdgHack = "call jobstart(\"xdg-open '" .. l:outputPath .. "'\")" " HACK: https://bugs.kde.org/show_bug.cgi?id=442721#c10
		call timer_start(3000, { tid -> execute(l:xdgHack)}) " HACK: Delay opening file to avoid opening a non-existent file
	endif
endfunction
" Count the number of pages in a PDF (https://stackoverflow.com/a/36801253)
function PdfStats ()
	let l:pdfPath = "/tmp/nvim-pandoc-" .. expand("%:t:r") .. ".pdf"
	let l:pageCount = system("pdftotext '" .. l:pdfPath .. "' - | grep -c $'\f'")
	let l:wordCount = system("pdftotext '" .. l:pdfPath .. "' - | wc -w")
	echo "Page Count: " .. l:pageCount
	echo "Word Count: " .. l:wordCount
endfunction
" == Custom Commands ==
" Create a PDF
command PandocMarkdownToPdf call PandocMultitool("--template ~/.config/nvim/pandoc/fphw-assignment/main.tex")
command PandocMarkdownToPdfLivePreview call PandocMultitool("--template ~/.config/nvim/pandoc/fphw-assignment/main.tex", 1, 0)
" Create a problem-solution formatted PDF
command PandocMarkdownToFphw call PandocMultitool("--template ~/.config/nvim/pandoc/fphw-assignment/main.tex --lua-filter ~/.config/nvim/pandoc/fphw-assignment/fphw-filter.lua")
command PandocMarkdownToFphwLivePreview call PandocMultitool("--template ~/.config/nvim/pandoc/fphw-assignment/main.tex --lua-filter ~/.config/nvim/pandoc/fphw-assignment/fphw-filter.lua", 1, 0)
" Create a MLA-formatted PDF
command PandocMarkdownToMla call PandocMultitool("--template ~/.config/nvim/pandoc/markdown-to-mla.template")
command PandocMarkdownToMlaLivePreview call PandocMultitool("--template ~/.config/nvim/pandoc/markdown-to-mla.template", 1, 0)
" Function to get the current page and word count of the last-exported MLA pdf
command PdfStats call PdfStats()
