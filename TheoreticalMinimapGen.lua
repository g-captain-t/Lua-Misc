--[[ 
	Theoretical Minimap Generation
	I read a devofum post discussing badcc's minimap generation with raycasting. 
	Theoretically, this works, but there's no way Studio can generate 518 400 pixel-frames at once.
	I might try using separate scripts, binding to a runservice event ( which takes 8640 seconds for a 720x720 map ),
	or passing this on as a JSON for a web program to handle it.
	Screenshot with one line:
	local Cam = workspace.CurrentCamera Cam.FieldOfView = 1 Cam.CFrame = CFrame.new(0,100000,0)
]]

local s = tostring

local function Ray(Y, origin)
	local defaultColor = {0,0,0}
	local finalColor = {0,0,0}
	local Result = workspace:Raycast(origin, Vector3.new(0,-Y,0))
	finalColor = Result and finalColor or defaultColor

	if Result.Instance:IsA("BasePart") then
		local color = Result.Instance.Color
		finalColor = {color.R*255,color.G*255,color.B*255}
	elseif Result.Instance:IsA("Terrain") then
		local color = Result.Instance:GetMaterialColor(Result.material)
		finalColor = {color.R*255,color.G*255,color.B*255}
	end
	return finalColor
end

local function colormapToUI (colormap,resolution)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,resolution,0,resolution)

	local function px()
		local framepx = Instance.new("Frame",frame)
		framepx.BorderSizePixel = 0
		framepx.Size = UDim2.new(0,1,0,1)
		return framepx
	end

	for _, pixeldata in pairs (colormap) do
		local framepx = px()
		framepx.Position = UDim2.new(0,pixeldata[1],0,pixeldata[2])
		framepx.BackgroundColor3 = Color3.fromRGB(table.unpack(pixeldata[3]))
	end
	frame.Parent = game.StarterGui
	return frame
end

local function GenerateMinimap(centerpos, Y, range, resolution, isGui)
	-- ["0,1"] = Green
	local colormap = {}
	local startpos = centerpos-Vector3.new(range/2,0,range/2)
	local studsperpixel = resolution/range
	for ypx=1,resolution do
		for xpx =1,resolution do
			local origin = Vector3.new(studsperpixel*xpx, Y, studsperpixel*ypx)
			local color = Ray(Y, origin)
			local pixeldata = {xpx, ypx, color}
			table.insert(colormap, pixeldata)
		end
	end
	if not isGui then return colormap end
	local frame = colormapToUI(colormap,resolution)
	return colormap, isGui
end

GenerateMinimap(Vector3.new(0,0,0), 500, 10, 10, true)

--[[ How to parse the colormap

Every pixel in the colormap array has a pixeldata:
{x, y, [R,G,B]}

]]
