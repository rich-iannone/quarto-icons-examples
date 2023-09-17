--[[
MIT License

Copyright (c) 2023 Shafayet Khan Shafee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--


local function ensure_html_deps()
  quarto.doc.add_html_dependency({
    name = "material-icons",
    version = "0.14.2",
    stylesheets = {"assets/css/mi.css"}
  })
end


local function isEmpty(s)
  return s == nil or s == ''
end

local str = pandoc.utils.stringify

local icon_type = {
  filled = "material-icons",
  outlined = "material-icons-outlined",
  round = "material-icons-round",
  sharp = "material-icons-sharp",
  two_tone = "material-icons-two-tone"
}

return {
  ['mi'] = function(args, kwargs, meta) 
    local icon = str(args[1])
    local itype = str(kwargs["type"])
    local size = str(kwargs["size"])
    local color = str(kwargs["color"])
    local class = str(kwargs["class"])
    
    if isEmpty(itype) then
      itype = "filled"
    end
    
    if icon_type[itype] == nil then
      io.write(
        string.format("There is no icon of type `%s` in Material Icons!!! ... Skipping using this shortcode", itype)
      )
      itype = ''
      return pandoc.Null()
    end
    
    if not isEmpty(size) then
      size = "font-size: " .. size .. ";"
    else
      size = ''
    end
    
    if not isEmpty(color) then
      color = "color: " .. color  .. ";"
    else
      color = ''
    end
    
    local style = "style=\"" .. size .. color .. "\""
    
    if isEmpty(class) then
      class = ''
    end
    

    if quarto.doc.is_format("html:js") then
      ensure_html_deps()
      return pandoc.RawInline(
          'html',
          "<span class=\"" .. icon_type[itype]  .. " " .. class .. "\"" .. style .. ">" .. icon .. "</i>"
        )
    else
      return pandoc.Null()
    end
  end
}
