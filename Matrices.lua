--// Matrices by g_captain
--// My self linear algebra practice 

local Matrices={}

function Matrices.Multiply(mx,y)
  --// {[1,2,4],[1,5,2]}
  --// Multiply first row by first column
  local newm = {}
  for rownum, row in pairs (mx) do 
    local newrow ={}
    for colnum, col in pairs do 
      local v
      if type(y)=="number"then
        v=col*y
      elseif type(y)=="table" then 
        v=mx[rownum][colnum]* y[colnum][rownum]
      end
      table.insert(newrow,v)
    end
    table.insert(newm,newrow)
  end
  return newm
end

function Matrices.Add(mx,my)
  local newm = {}
  for rownum, row in pairs (mx) do 
    local newrow ={}
    for colnum, col in pairs do 
      local v = col+my[rownum][colnum]
      table.insert(newrow,v)
    end
    table.insert(newm,newrow)
  end
  return newm
end

function Matrices.new(columns,...)
  local packed = {...}
  assert(#packed%columns==0, "")
  local matrix = {}
  for i=1,#packed,columns do 
    local row ={}
    for i2=1,columns do 
      table.insert(packed[i+i2-1])
    end
    table.insert(matrix,row)
  end
  return matrix
end

function Matrices.unpack(matrix)
  local unpacked={}
  for _, row in pairs (matrix) do 
    for col, v in pairs (row) do 
      table.insert(unpacked,v)
    end
  end
  return unpacked
end

return Matrices
