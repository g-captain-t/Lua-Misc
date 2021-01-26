--[[

Raymapper

]]

local config = {
	OriginHeight = 100;
	OriginXZ = {0,0};
	Range = 500;
	HeightDown = 500;
	WidthPixels = 75;
}

local function export (results)
	local HTTP = game:GetService("HttpService")
	local json = HTTP:JSONEncode(results)
	-- print(json:len(),json)
	Instance.new("StringValue",workspace).Value = json
end

local function resultcolor(results)
	if not results then return {0,0,0} end 
	local color = {}

	local function to(x)
		return math.floor(x*255)
	end
	
	if results.Instance==workspace.Terrain then 
		local c = results.Material == Enum.Material.Water and workspace.Terrain.WaterColor 
			or workspace.Terrain:GetMaterialColor(results.Material)
		color = {to(c.R), to(c.G), to(c.B)}
	elseif results.Instance:IsA("BasePart") then 
		local c = results.Instance.Color
		color = {to(c.R), to(c.G), to(c.B)}
	end

	return color
end

local function main ()
	print("Starting the raymap...")
	-- Cast the rays
	local finalresults = {}
	local studsperpx = config.Range/config.WidthPixels
	for y=1, config.WidthPixels do 
		local lt = os.clock()
		local row = {} -- {"rgb(1,2,3)", "rgb(1,2,3)"}
		for x=1, config.WidthPixels do 
			-- Prevent exhaustion
			if os.clock() - lt >= 0.1 then 
				wait() lt = os.clock()
			end
			-- Calculate origin
			local origin = Vector3.new(
				x*studsperpx-(config.Range-config.Range/2) + config.OriginXZ[1],
				config.OriginHeight,
				y*studsperpx-(config.Range-config.Range/2) + config.OriginXZ[2]
			)
			-- Cast the ray
			local RayParams = RaycastParams.new()
			RayParams.IgnoreWater = false
			local results = workspace:Raycast(
				origin,
				Vector3.new(0,-config.HeightDown,0),
				RayParams
			)
			-- Insert the final data
			local cellcolor, _ = resultcolor(results)
			table.insert(row, cellcolor)
		end
		print("Row "..y.."/"..config.WidthPixels.." finished")
		table.insert(finalresults,row)
	end
	-- export
	print("Finished! Exporting...")
	coroutine.wrap(export)(finalresults)
	return finalresults
end

return main 
-- use with require(workspace.Raymapper)()