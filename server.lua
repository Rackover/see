--[[
Loading socket from our own lib folder
--]]
package.path = package.path..';.\\lib\\?.lua'
package.cpath = package.cpath..';.\\lib\\?.dll'
local socket = require "socket"
local logger = require("logger")

logger:info("Server starting...")

Server = {
  network = assert(socket.bind("*", 4020)),
  clients = {}
}

Server.network:settimeout(0)
Server.network:setoption('keepalive', true)

local addr,port,mode = Server.network:getsockname()
print(addr..':'..port..' ('..mode..') ['..socket._VERSION..']')

function Server:handleConnections()
  local client, err = self.network:accept()
  if not err then
    table.insert(self.clients, client)
    client:send("Hello" .. "\n") 
    logger:info ("Accepted client "..tostring(#self.clients))
  end
end

function Server:receiveData(client_id)
  local client = self.clients[client_id]
  local data, err, partial = client:receive('*l')
  if not err then 
    client:send("Copy" .. "\n") 
    logger:debug ("Received "..data.." from client "..tostring(client_id))
  end
end

while 1 do
  Server:handleConnections()
  for client_id in pairs(Server.clients) do
    Server:receiveData(client_id)
  end
end