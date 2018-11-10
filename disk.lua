
local Disk = {}

function Disk.write_file(str_filename, content)
  -- Opens a file in append mode
  local file = io.open(str_filename, "w")

  -- appends a word test to the last line of the file
  file:write(tostring(content)..'\n')

  -- closes the open file
  file:close()
end

return Disk