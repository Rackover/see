local logger = require "logger"
local to_lua = require('obj_to_lua')
local md5 = require "lib/md5"

local Props = {}

local props_path = [[data/props]]
local obj_path = props_path..'/obj'

function Props.update()
  obj_files = love.filesystem.getDirectoryItems(obj_path)
  assert(love.filesystem.createDirectory(props_path))
  
  for _, filename in ipairs(obj_files) do
    -- Found OBJ file, let's read it
    local content, err = love.filesystem.read(obj_path..'/'..filename)
    if content then
      -- Do we already have a lua file for this ?
      if (love.filesystem.getInfo(props_path..'/'..filename..'.lua')) then
        -- yes let's check the sum
        local lua_object = dofile(props_path..'/'..filename..'.lua')
        obj_sum = md5.sumhexa(content)
        if (obj_sum ~= lua_object.sum) then
          -- wrong sum, remake the file
          logger:debug(filename..' has changed, remaking it')
          local newContent = to_lua.convert(obj_path..'/'..filename)
          local success, message = love.filesystem.write(props_path..'/'..filename..'.lua', table.concat(newContent))
          if not success then logger:warn('Writing failed : '..message) end
        else
          -- everything okay
          logger:debug(filename..' has been converted already')
        end
      else
        -- no, remake the file
        logger:debug(filename..' is new, converting it')
        local newContent = to_lua.convert(obj_path..'/'..filename)
        
        os.exit()
        
        
        local success, message = love.filesystem.write(props_path..'/'..filename..'.lua', table.concat(newContent))
        if not success then logger:warn('Writing failed : '..message) end
      end
    else
      logger:warn(err)
    end
  end
end

return Props