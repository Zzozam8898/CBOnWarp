local fs = require('filesystem')
local inet = require('component').internet
if (not inet) then
  error('FATAL! Web installer requires internet access!')
end
if (not inet.isHttpEnabled()) then
  error('FATAL! Web installer requires HTTP to be enabled!')
end


print('Setting up the environment...')
fs.makeDirectory('usr/lib')

local repoURL= "https://raw.githubusercontent.com/Zzozam8898/CBOnWarp/master/"

print('Loading web assets...')
local files = {
  ['main.lua'] = repoURL..'chatbox.lua',
  ['scan.lua'] = repoURL..'scan.lua',
  ['checkItem.lua'] = repoURL..'checkItem.lua',
}

print('Downloading files...')
local shell = require('shell')


for name, data in pairs(files) do
  io.write(name..' >> ')
  local rvar = ('wget -f \''..data..'\' '..name)
  shell.execute(rvar)
end

