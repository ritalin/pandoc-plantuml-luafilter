local utils = require 'pandoc.utils'
local paths = require 'pandoc.path'
local mediabags = require 'pandoc.mediabag'

local root_dir = paths.directory(paths.directory(PANDOC_SCRIPT_FILE))

local search_paths = {
    package.path,
    paths.join({ root_dir, "modules", "LibDeflate", "?.lua" })
}
package.path = table.concat(search_paths, ";")

local libDeflate = require("LibDeflate")

-- @type number -> string
local function encode6(b)
    if b < 10 then
        return utf8.char(b + 48)
    end

    b = b - 10
    if b < 26 then
        return utf8.char(b + 65)
    end

    b = b - 26
    if b < 26 then
        return utf8.char(b + 97)
    end

    b = b - 26
    if b == 0 then
        return "-"
    elseif b == 1 then
        return "_"
    else
        return "?"
    end
end

-- @type char -> char -> char -> string
local function append3(c1, c2, c3)
    local b1 = c1 >> 2
    local b2 = ((c1 & 0x03) << 4) | (c2 >> 4)
    local b3 = ((c2 & 0x0f) << 2) | (c3 >> 6)
    local b4 = c3 & 0x3f

    return table.concat({
        encode6(b1 & 0x3f), encode6(b2 & 0x3f), encode6(b3 & 0x3f), encode6(b4), 
    })
end

-- @type string -> string
local function encode(text)
    local ctext = libDeflate:CompressDeflate(text, {level = 9})
    local len = ctext:len()
    local buf = {}

    for i = 1, len, 3 do
        if i + 1 > len then
            table.insert(buf, append3(string.byte(ctext, i), 0, 0))
        elseif i + 2 > len then
            table.insert(buf, append3(string.byte(ctext, i), string.byte(ctext, i+1), 0))
        else 
            table.insert(buf, append3(string.byte(ctext, i), string.byte(ctext, i+1), string.byte(ctext, i+2)))
        end
    end

    return table.concat(buf)
end

return {
    {
        CodeBlock = function(el) 
            local encoded_text = encode(el.text)

            el.text = el.text .. "\n" .. encoded_text
            return el
        end
    }
}