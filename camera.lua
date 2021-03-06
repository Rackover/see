local utils = require("utils")

local Camera = {
  z_angle = 0,
  depth = 5,
  position = {x=0,y=0,z=0}
}

function Camera:to_screen(position)
  local width, height = love.graphics.getDimensions()
  local forward = utils.point_on_circle(self.z_angle, 1)
  local camera_relative_position = self:to_camera_referential(position)
  local screen_center = {
    x = width/2,
    y = height/2
  }
    
  local screen_position = {
    x = utils.lerp(screen_center.x-camera_relative_position.y, screen_center.x, camera_relative_position.x/self.depth),
    y = height - utils.lerp(screen_center.y-camera_relative_position.z, screen_center.y, camera_relative_position.z/self.depth)
  }
  
  --print(position.x, position.y, position.z)
  --print(camera_relative_position.x, camera_relative_position.y, camera_relative_position.z)
  --print(screen_position.x, screen_position.y)
  return screen_position
end

function Camera:get_vanishing_point()
  local ground_pos = utils.point_on_circle(self.z_angle, depth, position)
  return {x=ground_pos.x, y=ground_pos.y, z=self.z}
end

function Camera:to_camera_referential(point)
  local old_origin = {
    x = -self.position.x*math.cos(self.z_angle) - self.position.y*math.sin(self.z_angle),
    y = self.position.x*math.sin(self.z_angle) - self.position.y*math.cos(self.z_angle),
    z = -self.position.z
  }
  return {
    x= point.x*math.cos(self.z_angle) - point.y*math.sin(self.z_angle) + old_origin.x,
    y= point.x*math.sin(self.z_angle) + point.y*math.cos(self.z_angle) + old_origin.y, 
    z= point.z + old_origin.z
  }
  --[[
  x'0 = -x0*cos(a) - y0*sin(a)
  y'0 = x0*sin(a) - y0*cos(a)
  
  local trans = {
    x={1, 0, 0},
    y={0, 1, 0},
    z={0, 0, 1}
  }
  local relv -- v positioned relative to the camera, both in orientation and location
  local pos = {}
  for axis in pairs(self.position) do
    local val = self.position[axis]
    for k in pairs(trans) do
      local rot = trans[k]
      
    end
  end
  relv = trans * (v - self.position) -- here '*' is vector dot product
  if relv.z > 0 then
      -- v is in front of the camera
      local w -- perspective scaling factor
      w = self.zoom / relv.z
      local projv -- projected vector
      projv = Vec2(relv.x * w, relv.y * w)
      return projv
  else
      -- v is behind the camera
      return nil
  end
  ]]--
end

return Camera