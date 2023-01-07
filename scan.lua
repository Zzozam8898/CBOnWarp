local component = require("component")
local io = require("io")
local serialization = require("serialization")
local os = require("os")

f = {}
data = {}
function f.loadData()
    local f = io.open("/mnt/77e/Items.lua","r")

    if f==nil then
        print('['..os.date().. '] '.."Config not found, ignore.")
        return
    end
    local data = serialization.unserialize(f:read("*a"))
    f:close()
    return data
end

function f.saveData()
    local f = io.open("/mnt/77e/Items.lua","w")
    local d = serialization.serialize(data)
    f:write(d)
    f:close()
end

function f.isExists(item)
    if data[item.id..":"..item.dmg] ~= nil then
        return true
    else
        return false
    end
end

function f.scan()
    local items = component.diamond.getAllStacks()
    if items == {} then
        return
    end
    for k,v in pairs(items) do
        local item = v.basic()
        if not(f.isExists(item)) then
            print('['..os.date().. '] '..item.display_name.." not founded, writing")
            data[item.id..":"..item.dmg] = {
                mod_id = item.mod_id,
                display_name = item.display_name
            }
        else
            print('['..os.date().. '] '..item.display_name.." founded, skip")
        end
    end
end

data = f.loadData()
print('['..os.date().. '] '.."Saved items loaded, scanning..")
f.scan()
print('['..os.date().. '] '.."Scan completed")
f.saveData()
print('['..os.date().. '] '.."Saved.")