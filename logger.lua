local logging = require "lib/logging"

local logger = logging.new(
  function(self, level, message)
    print(level, message)
    return true
  end
)

logger:setLevel (logging.DEBUG)

return logger