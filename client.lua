local host, port = "127.0.0.1", 4020
local socket = require "socket"
local logger = require("logger")

Client = {
  network = assert(socket.connect(host, port), 'Could not connect the server on '..tostring(host)..':'..tostring(port)),
}
Client.network:settimeout(0)
Client.network:setoption('keepalive', true)

function Client:send(str)
  self.network:send(str.."\n")
end

function Client:checkConnection()
  local data, err = self.network:receive("*l")
  logger:debug ("Checking connection - got "..tostring(data).." "..tostring(err))
  if err then 
    return false
  end
  return true
end

function Client:close()
  self.network:close()  
end

return Client