local Utils = {}

function Utils.table_to_string(tbl)
  local count = 0
  local str = "{"
  for k,v in pairs(tbl) do
    
    local vIsTable = false
    -- Converting table to string
    if (type(v) == 'table') then
      v = Utils.table_to_string(v)
      vIsTable = true
    end
    
    -- Adding "" for strings
    if (not vIsTable and tonumber(v) == nil) then
      v = '"'..v..'"'
    end
    
    str = str..k..'='..v
    count = count +1
    
    if (count <  Utils.table_length(tbl)) then
      str = str..','
    end
    
    str = str..'\n'
    
  end
  str = str..'}'
  return str
end

function Utils.table_length(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

function Utils.print_table(table)
  print(Utils.table_to_string(table))
end

function Utils.lerp(a, b, delta)
	return a + (b - a) * delta
end

function Utils.point_on_circle(angle_rad, radius, origin)
  local origin = origin or {x=0, y=0}
  return {
    x = math.cos(angle_rad)*radius + origin.x,
    y = math.sin(angle_rad)*radius + origin.y
  }
end

return Utils