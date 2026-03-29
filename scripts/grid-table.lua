local function latex_escape(s)
  s = s:gsub('\\', '\\textbackslash{}')
  s = s:gsub('([%%#&{}_])', '\\\1')
  s = s:gsub('%^', '\\textasciicircum{}')
  s = s:gsub('~', '\\textasciitilde{}')
  return s
end

local function blocks_to_latex(blocks)
  local inlines = pandoc.utils.blocks_to_inlines(blocks)
  local text = pandoc.utils.stringify(inlines)
  text = latex_escape(text)
  text = text:gsub('\n+', ' ')
  return text
end

function Table(tbl)
  local ncols = #tbl.colspecs
  if ncols == 0 then
    return nil
  end

  local spec_parts = {}
  for _ = 1, ncols do
    table.insert(spec_parts, 'p{0.22\\linewidth}')
  end
  local spec = '|' .. table.concat(spec_parts, '|') .. '|'

  local out = {}
  table.insert(out, '\\begin{longtable}{' .. spec .. '}')
  table.insert(out, '\\hline')

  local header_cells = {}
  for _, cell in ipairs(tbl.head.rows[1].cells) do
    table.insert(header_cells, blocks_to_latex(cell.contents))
  end
  table.insert(out, table.concat(header_cells, ' & ') .. ' \\\\')
  table.insert(out, '\\hline')
  table.insert(out, '\\endfirsthead')
  table.insert(out, '\\hline')
  table.insert(out, table.concat(header_cells, ' & ') .. ' \\\\')
  table.insert(out, '\\hline')
  table.insert(out, '\\endhead')

  for _, body in ipairs(tbl.bodies) do
    for _, row in ipairs(body.body) do
      local row_cells = {}
      for _, cell in ipairs(row.cells) do
        table.insert(row_cells, blocks_to_latex(cell.contents))
      end
      table.insert(out, table.concat(row_cells, ' & ') .. ' \\\\')
      table.insert(out, '\\hline')
    end
  end

  table.insert(out, '\\end{longtable}')
  return pandoc.RawBlock('latex', table.concat(out, '\n'))
end
