local utils = require('utils')

local Brush = {
  active_camera = {}
}

--[[

 Z
     X
 ^  
 |  7
 | /
 |/
 +-----------> Y

]]--


function Brush:report(vertices, position)
  local translated_vertices = {}
  for k in ipairs(vertices) do
    local vertex = vertices[k]
    local vertex_position = {
      x = position.x + vertex.x,
      y = position.y + vertex.y,
      z = position.z + vertex.z
    }
    local point = self.active_camera:to_screen(vertex_position)
    table.insert(translated_vertices, point)
  end
  return translated_vertices
end

function Brush:draw(object)
  local vertices = Brush:report(object.model.v, object.position)
  for k in ipairs(object.model.f) do
    local f = object.model.f[k]
    local points = {}
    for l in ipairs(f) do
      table.insert(points, vertices[l].x)
      table.insert(points, vertices[l].y)
    end
    -- Closing the loop
    table.insert(points, vertices[1].x)
    table.insert(points, vertices[1].y)
    
    love.graphics.line(points)
  end
  
  
  --[[
  {
      model=self.catalog[str_name],
      position=position or {x=0, y=0, z=0},
      name=str_name,
      color={1,0,0,1}
  }
  
  ]]--
  
  
  --[[
  local obj = {
    sum = '',
		v	= {}, -- List of vertices - x, y, z, [w]=1.0
		vt	= {}, -- Texture coordinates - u, v, [w]=0
		vn	= {}, -- Normals - x, y, z
		vp	= {}, -- Parameter space vertices - u, [v], [w]
		f	= {}, -- Faces
	}
  ]]--
  
end

return Brush