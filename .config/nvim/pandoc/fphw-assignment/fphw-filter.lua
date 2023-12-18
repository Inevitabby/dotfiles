-- 
function latex(str)
	return pandoc.RawInline("latex", str)
end
function Pandoc(doc)
	local blocks = {}
	for i,el in pairs(doc.blocks) do
		if el.t == "Header" then
			if ( el.level == 1 ) then
				table.insert(blocks, el)
				table.insert(blocks, latex('\\begin{problem}'))
			end
		elseif el.t == "HorizontalRule" then
			table.insert(blocks, latex('\\end{problem}\\subsection*{Answer}'))
		else
			-- Keep all non-header elements as-is
			table.insert(blocks, el)
		end
	end
	return pandoc.Pandoc(blocks, doc.meta)
end
