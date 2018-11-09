io.stdout:setvbuf("no")

local socket = require "socket"
local logger = require("logger")
local props = require("props")

local client

function love.load(deltaTime)
  props.update()
  client = require("client")
end

function love.update()
  logger:debug ("Sending Alive")
  client:send("Alive")
  if (client:checkConnection()) then
    logger:debug ("Connection OK")  
  else
    logger:info ("Closed client - shutting down")
    client:close()
    love.event.quit( )
  end
  socket.sleep(1)
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
  