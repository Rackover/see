local logger = require('logger')
local to_lua = require('obj_to_lua')
local disk = require('disk')
local utils = require('utils')

local Props = {
  catalog={},
  active={}
}

local props_path = [[data/props]]
local obj_path = props_path..'/obj'

-- Load props into the catalog
function Props:load()
  obj_files = love.filesystem.getDirectoryItems(obj_path)
  assert(love.filesystem.createDirectory(props_path))
  
  for _, filename in ipairs(obj_files) do
    -- Found OBJ file, let's read it
    local content, err = love.filesystem.read(obj_path..'/'..filename)
    if content then
      logger:debug('Converting '..filename..'...')
      local new_content = to_lua.convert(obj_path..'/'..filename)
      self.catalog[filename] = new_content
    else
      logger:warn(err)
    end
  end
end

function Props:new(str_name, position)
  table.insert(self.active, 
    {
      model=self.catalog[str_name],
      position=position or {x=0, y=0, z=0},
      name=str_name,
      color={1,0,0,1}
    }
  )
  return #self.active
end
return Props