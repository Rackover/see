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

-- Translates GLOBAL position to SCREEN position
function Brush:to_screen(position)
  local width, height = love.graphics.getDimensions()
  local forward = utils.point_on_circle(self.active_camera.z_angle, 1)
  local camera_relative_position = self.active_camera:to_camera_referential(position)
  local screen_center = {
    x = width/2,
    y = height/2
  }
    
  local screen_position = {
    x = utils.lerp(camera_relative_position.y, screen_center.x, camera_relative_position.x/self.active_camera.depth),
    y = height - utils.lerp(camera_relative_position.z, screen_center.y, camera_relative_position.z/self.active_camera.depth)
  }
  
  --print(position.x, position.y, position.z)
  --print(camera_relative_position.x, camera_relative_position.y, camera_relative_position.z)
  --print(screen_position.x, screen_position.y)
  return screen_position
end

function Brush:report(vertices, position)
  local translated_vertices = {}
  for k in ipairs(vertices) do
    local vertex = vertices[k]
    local vertex_position = {
      x = position.x + vertex.x,
      y = position.y + vertex.y,
      z = position.z + vertex.z
    }
    local point = self:to_screen(vertex_position)
    table.insert(translated_vertices, point)
  end
  return translated_vertices
end
--[[
-- Translates 3D model on a 2D space based on camera orientation
function Brush:translate(model, position)
  local translated_vertices = {}
  local vanishing_point = self.active_camera:get_vanishing_point()
  for (k, vertex in model.v) do
    local point = {
      x = utils.lerp(position.x + vertex.x, vanishing_point.x, (vertex.z)/self.active_camera.depth + position.x),
      
      y = utils.lerp(position.y - vertex.y, vanishing_point.y, (vertex.z)/self.active_camera.depth + position.z),
    }
  end
end
  
--]]
function Brush:draw(object)
  local vertices = Brush:report(object.model.v, object.position)
  for k in ipairs(object.model.f) do
    local f = object.model.f[k]
    local points = {}
    for l in ipairs(f) do
      table.insert(points, vertices[l+1].x)
      table.insert(points, vertices[l+1].y)
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