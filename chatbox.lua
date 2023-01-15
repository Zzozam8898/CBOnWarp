local component = require("component")
local term = require("term")
local event = require("event")
local fs = require("filesystem")
local check = require("checkItem")
local scanner = require("scan")
local chat_box = component.chat_box
local commandPrefix = "++"

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
 end

function mysplit (inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end

-- Конвертирует строку в массив
function stringToArray(text)
  t = {}
  text:gsub(".",function(c) table.insert(t,c) end)
  return t
end

function compare(raw_id)
    local item = check.convert(raw_id)
    if scanner.isExists(item) then
        exists(item)
    else
        check.write(item)
    end
end

function exists(item)
    chat_box.say("Ищи в разделе "..item.mod_id)
end

function catchCommand(nick, raw_msg, type, pos)
    if string.starts(raw_msg, commandPrefix) then
        words = mysplit(raw_msg," ")

        if words[2]~= nil then
            print(words[2], nick, raw_msg, type, pos)
            compare(words[2])
        end
    end
end

-- Проверяет в глобальном ли чате написано сообщение
function isGlobal(text)
  for pos, i in pairs(stringToArray(text)) do
    if (i ~= "!") then
      if (i ~= " ") then
        return false
      end
    else
      return true, pos
    end
  end
  return false
end

-- Делит строку на части
function split(str, pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
      table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end



print("Инициализация...")
os.sleep(1)
print("Ожидание первого сообщения...")

local _, add, nick, msg = event.pull("chat_message") 
term.clear()
local type, pos = isGlobal(msg)
catchCommand(nick, msg, type, pos)


while true do

  local _, add, nick, msg = event.pull("chat_message") 
  print(nick, msg, type, pos)
  local type, pos = isGlobal(msg)
  catchCommand(nick, msg, type, pos)

end

