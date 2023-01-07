local itemIds = require("itemIds")
local io = require("io")
local serialization = require("serialization")
--local ItemsSellable = require("Items")

local f = {}

function f.mysplit (inputstr, sep)
    if sep == nil then
            sep = ":"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function f.getSplitter(input)
    if string.find(input, ":") then
        return ":"
    elseif string.find(input, "/") then
        return "/"
    else
        return nil
    end
end

function f.convert(input)
    local item = nil
    local splitter = getSplitter(input)
    if splitter then
        local raw_item = mysplit(input,splitter)
        item = {
            id=itemIds[tonumber(raw_item[1])],
            dmg=tonumber(raw_item[2])
        }
    else 
        item = {
            id=itemIds[tonumber(input)],
            dmg=0
        }
    end
    return item
end

function f.write(item)
    local f = io.open("tasks.lua","a+")
    f.write(item.id..":"..item.dmg.."\n")
    f.close()
end

return f