-- Semantic CV divs -> LaTeX layout.
-- HTML keeps the div classes and is styled by cv.css.
-- Top-down traversal is important: the outer cv-entry must see its child divs
-- before those child wrappers are removed.

local function has_class(el, class_name)
  for _, c in ipairs(el.classes) do
    if c == class_name then return true end
  end
  return false
end

local function latex_of_blocks(blocks)
  local doc = pandoc.Pandoc(blocks)
  local s = pandoc.write(doc, 'latex')
  s = s:gsub('%s+$', '')
  return s
end

local function child_div(div, class_name)
  for _, block in ipairs(div.content) do
    if block.t == 'Div' and has_class(block, class_name) then
      return block
    end
  end
  return nil
end

traverse = 'topdown'

function Meta(meta)
  if FORMAT:match('latex') then
    -- Keep the YAML title for the website/browser metadata, but do not let
    -- Pandoc generate a visible title block in the PDF.
    meta.title = nil
  end

  if FORMAT:match('latex') and meta['cv-surname'] then
    local surname = pandoc.utils.stringify(meta['cv-surname'])
    local raw = pandoc.MetaBlocks({
      pandoc.RawBlock('latex', '\\renewcommand{\\CVSurname}{' .. surname .. '}')
    })
    if meta['header-includes'] == nil then
      meta['header-includes'] = pandoc.MetaList({raw})
    elseif meta['header-includes'].t == 'MetaList' then
      table.insert(meta['header-includes'], raw)
    else
      meta['header-includes'] = pandoc.MetaList({meta['header-includes'], raw})
    end
  end
  return meta
end

function Div(div)
  if not FORMAT:match('latex') then
    return nil
  end

  if has_class(div, 'cv-page') then
    return nil
  end

  if has_class(div, 'cv-name') then
    local body = latex_of_blocks(div.content)
    return pandoc.RawBlock('latex', '\\cvname{' .. body .. '}')
  end

  if has_class(div, 'cv-contact') then
    local body = latex_of_blocks(div.content)
    return pandoc.RawBlock('latex', '\\cvcontact{' .. body .. '}')
  end

  if has_class(div, 'cv-entry') then
    local main = child_div(div, 'cv-main')
    local date = child_div(div, 'cv-date')
    if main and date then
      local main_tex = latex_of_blocks(main.content)
      local date_tex = latex_of_blocks(date.content)
      local tex = table.concat({
        '\\noindent',
        '\\begin{minipage}[t]{0.82\\textwidth}',
        main_tex,
        '\\end{minipage}\\hfill%',
        '\\begin{minipage}[t]{0.14\\textwidth}\\raggedleft',
        date_tex,
        '\\end{minipage}',
        '\\par\\vspace{5.5pt}'
      }, '\n')
      return pandoc.RawBlock('latex', tex)
    end
  end

  if has_class(div, 'cv-citation') then
    local body = latex_of_blocks(div.content)
    return pandoc.RawBlock('latex', '\\begin{cvcitation}\n' .. body .. '\n\\end{cvcitation}')
  end

  if has_class(div, 'cv-award') then
    local year = child_div(div, 'cv-award-year')
    local name = child_div(div, 'cv-award-name')
    if year and name then
      local year_tex = latex_of_blocks(year.content)
      local name_tex = latex_of_blocks(name.content)
      local tex = table.concat({
        '\\noindent',
        '\\begin{minipage}[t]{0.9in}', year_tex, '\\end{minipage}%',
        '\\hspace{1em}%',
        '\\begin{minipage}[t]{\\dimexpr\\textwidth-0.9in-1em\\relax}', name_tex, '\\end{minipage}',
        '\\par\\vspace{1pt}'
      }, '\n')
      return pandoc.RawBlock('latex', tex)
    end
  end

  if has_class(div, 'cv-main') or
     has_class(div, 'cv-date') or
     has_class(div, 'cv-award-year') or
     has_class(div, 'cv-award-name') or
     has_class(div, 'cv-bullets') then
    return div.content
  end

  return nil
end

