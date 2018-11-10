io.stdout:setvbuf("no")

local socket = require "socket"

local logger = require("logger")
local props = require("props")
local utils = require("utils")
local brush = require("brush")

local client
local net = false

function love.load(deltaTime)
  props:load()
  brush.active_camera = require("camera")
  
  props:new("cube.obj", {x=1, y=0, z=0})
  
  -- Inet
  if net then client = require("client") end
end

function love.keypressed( key, scancode, isrepeat )
  for k in ipairs(props.active) do
    if (key == "q") then
      props.active[k].position.y = props.active[k].position.y - 50
    end
    if (key == "d") then
      props.active[k].position.y = props.active[k].position.y + 50
    end
    if (key == "z") then
      props.active[k].position.x = props.active[k].position.x - 1
    end
    if (key == "s") then
      props.active[k].position.x = props.active[k].position.x + 1
    end
    if (key == "a") then
      props.active[k].position.z = props.active[k].position.z - 1
    end
    if (key == "e") then
      props.active[k].position.z = props.active[k].position.z + 1
    end
  end
end

function love.update()
  
  
  
  
  --- Inet
  if (net) then
    logger:debug ("Sending Alive")
    client:send("Alive")
    if (client:checkConnection()) then
      logger:debug ("Connection OK")  
    else
      logger:info ("Closed client - shutting down")
      client:close()
      love.event.quit( )
    end
  end
end
  
  
function love.draw()
  love.graphics.clear()
  love.graphics.setColor(1, 0, 0, 1)
  width, height = love.graphics.getDimensions()
  --love.graphics.line(0, 0, width, height)
  
  -- Draw props
  for k in ipairs(props.active) do
    brush:draw(props.active[k])
  end
end
  --[[
  for i=1, fakePlayers do
    clients[i] = require("client")
  end
  
  
  //step
  for i=1, table.getn(clients) do
    if (clients[i]:checkConnection()) then
    else
      print ("Closed client "..tostring(i))
      clients[i]:close()
      clients[i] = nil
    end
  end
  --]]
  