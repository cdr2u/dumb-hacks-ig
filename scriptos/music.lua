if not isfolder("songlist") then makefolder("songlist") end

local songlist = {}
local many
local db = true
local visualiser = true
local fovchange = true
local fovbobweakness = 50

for _,v in game.Players.LocalPlayer.PlayerGui:GetChildren() do
    if v.Name == "musicGui" then
        v:Destroy()
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("SoundVisualizer") then
	CoreGui:FindFirstChild("SoundVisualizer"):Destroy()
end

-- Create ScreenGui in CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SoundVisualizer"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- Visualizer settings
local numBars = 150
local barMaxHeight = 200
local spacing = 2
local screenWidth = workspace.CurrentCamera.ViewportSize.X
local waiting = false

-- Calculate bar width to fill screen
local barWidth = (screenWidth - (numBars - 1) * spacing) / numBars

-- Create bars directly under ScreenGui
local bars = {}

if visualiser then
    for i = 0, numBars - 1 do
    	local bar = Instance.new("Frame")
    	bar.AnchorPoint = Vector2.new(0, 1)  -- Anchor to bottom left of the screen
    	bar.Position = UDim2.new(0, i * (barWidth + spacing), 1, 0) -- Bottom of screen
    	bar.Size = UDim2.new(0, barWidth, 0, 2) -- Start with small height
        bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    	bar.BorderSizePixel = 0
    	bar.Parent = screenGui
    	table.insert(bars, bar)
    end
end

-- Gui to Lua
-- Version: 3.2

-- Instances:

local musicGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local RefreshBtn = Instance.new("TextButton")
local RandomBtn = Instance.new("TextButton")
local StopBtn = Instance.new("TextButton")
local FOVChange = Instance.new("TextBox")

--Properties:

musicGui.Name = "musicGui"
musicGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
musicGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
musicGui.ResetOnSpawn = false

Frame.Parent = musicGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 114, 116)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.626806021, 0, 0.397297293, 0)
Frame.Size = UDim2.new(0, 300, 0, 230)
Frame.Draggable = true
Frame.Active = true

ScrollingFrame.Parent = Frame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(-0.00401606411, 0, 0.126379654, 0)
ScrollingFrame.Size = UDim2.new(0, 302, 0, 208)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

RefreshBtn.Name = "RefreshBtn"
RefreshBtn.Parent = Frame
RefreshBtn.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
RefreshBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Position = UDim2.new(0.761726856, 0, 0.0149999866, 0)
RefreshBtn.Size = UDim2.new(0, 55, 0, 23)
RefreshBtn.Font = Enum.Font.SourceSans
RefreshBtn.Text = "REFRESH"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 14.000

RandomBtn.Name = "RandomBtn"
RandomBtn.Parent = Frame
RandomBtn.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
RandomBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
RandomBtn.BorderSizePixel = 0
RandomBtn.Position = UDim2.new(0.561726856, 0, 0.0149999866, 0)
RandomBtn.Size = UDim2.new(0, 55, 0, 23)
RandomBtn.Font = Enum.Font.SourceSans
RandomBtn.Text = "RANDOM"
RandomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RandomBtn.TextSize = 14.000

StopBtn.Name = "StopBtn"
StopBtn.Parent = Frame
StopBtn.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
StopBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopBtn.BorderSizePixel = 0
StopBtn.Position = UDim2.new(0.0161726856, 0, 0.0149999866, 0)
StopBtn.Size = UDim2.new(0, 55, 0, 23)
StopBtn.Font = Enum.Font.SourceSans
StopBtn.Text = "STOP ALL"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 14.000

FOVChange.Name = "FOVChange"
FOVChange.Parent = Frame
FOVChange.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
FOVChange.BorderColor3 = Color3.fromRGB(0, 0, 0)
FOVChange.BorderSizePixel = 0
FOVChange.Position = UDim2.new(0.2161726856, 0, 0.0149999866, 0)
FOVChange.Size = UDim2.new(0, 55, 0, 23)
FOVChange.Font = Enum.Font.SourceSans
FOVChange.Text = "50"
FOVChange.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVChange.TextSize = 14.000
FOVChange.FocusLost:Connect(function(a)
	if a then
		fovbobweakness = tonumber(FOVChange.Text)
	end
end)

-- Scripts:

function randomSong()
    if #songlist == 0 then return end
    local ran = math.random(1, #songlist)
    playSong(ran, true).Ended:Wait()
    randomSong()
end

function playSong(id, ret)
    for _,v in workspace.CurrentCamera:GetChildren() do
    	if v:IsA("Sound") then
			v:Stop()
    	    v:Destroy()
    	end
	end
    
    local sound = Instance.new("Sound")
    sound.Parent = workspace.CurrentCamera
    sound.SoundId = getcustomasset(songlist[id])
    sound.Volume = 2
    sound:Play()

    if ret then return sound end
end

function getsongs()
    songlist = {}
	for _, file in ipairs(listfiles("songlist/")) do
		if isfile(file) then
            table.insert(songlist, file)
        end
	end
end

function refreshSongs()
    if db == false then return end
    for _,v in ScrollingFrame:GetChildren() do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    getsongs()
    db = false
    many = 0
    for i,_ in ipairs(songlist) do
        if songlist[i] == nil then return end

        local song = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local TextButton = Instance.new("TextButton")

        song.Name = "song"
        song.Parent = ScrollingFrame
        song.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        song.BorderColor3 = Color3.fromRGB(0, 0, 0)
        song.BorderSizePixel = 0
        song.Size = UDim2.new(0, 290, 0, 60)

        TextLabel.Parent = song
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Position = UDim2.new(0.0206520957, 0, 0.349999994, 0)
        TextLabel.Size = UDim2.new(0, 200, 0, 15)
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Text = string.sub(songlist[i], 12)
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 20.000
        TextLabel.TextWrapped = true
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        TextButton.Parent = song
        TextButton.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
        TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(0.7830434537, 0, 0.114999898, 0)
        TextButton.Size = UDim2.new(0, 55, 0, 45)
        TextButton.Font = Enum.Font.SourceSansBold
        TextButton.Text = "PLAY"
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.TextSize = 20.000
        TextButton.MouseButton1Click:Connect(function()
            playSong(i, false)
		    TextButton.Text = "PLAYED"
		    task.wait(1)
		    TextButton.Text = "PLAY"
	    end)
        many += 1
    end
    ScrollingFrame.CanvasSize = UDim2.new(0,0,(math.abs(many)/1.5)/2.34,0)
    db = true
end

RefreshBtn.MouseButton1Click:Connect(function() refreshSongs() end)
RandomBtn.MouseButton1Click:Connect(function() randomSong() end)
StopBtn.MouseButton1Click:Connect(function()
	for _,v in workspace.CurrentCamera:GetChildren() do
    	if v:IsA("Sound") then
			v:Stop()
    	    v:Destroy()
    	end
	end
end)

refreshSongs()

-- Update bars on every frame
RunService.RenderStepped:Connect(function()
    if workspace.CurrentCamera:FindFirstChild("Sound") then
        local sound = workspace.CurrentCamera:FindFirstChild("Sound")
    	if sound and sound.IsPlaying then
    		local loudness = sound.PlaybackLoudness

            if visualiser then
    		    for i, bar in ipairs(bars) do
    		    	local height = math.clamp(loudness / 5 + math.random(-5, 5), 2, barMaxHeight)
    		    	bar.Size = UDim2.new(0, barWidth, 0, height)
    		    end
            end
            if fovchange then
                local cam = workspace.CurrentCamera
                cam.FieldOfView = 70 + (loudness / fovbobweakness)
            end
    	else
            if visualiser then
    		    -- Reset bars if not playing
    		    for _, bar in ipairs(bars) do
			        bar.Size = UDim2.new(0, barWidth, 0, 2)
		        end
            end
            if fovchange then
                local cam = workspace.CurrentCamera
                cam.FieldOfView = 70
            end
	    end
    end
end)
if not isfolder("songlist") then makefolder("songlist") end

local songlist = {}
local many
local db = true
local visualiser = true
local fovchange = true
local fovbobweakness = 50

for _,v in game.Players.LocalPlayer.PlayerGui:GetChildren() do
    if v.Name == "musicGui" then
        v:Destroy()
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("SoundVisualizer") then
	CoreGui:FindFirstChild("SoundVisualizer"):Destroy()
end

-- Create ScreenGui in CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SoundVisualizer"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- Visualizer settings
local numBars = 150
local barMaxHeight = 200
local spacing = 2
local screenWidth = workspace.CurrentCamera.ViewportSize.X
local waiting = false

-- Calculate bar width to fill screen
local barWidth = (screenWidth - (numBars - 1) * spacing) / numBars

-- Create bars directly under ScreenGui
local bars = {}

if visualiser then
    for i = 0, numBars - 1 do
    	local bar = Instance.new("Frame")
    	bar.AnchorPoint = Vector2.new(0, 1)  -- Anchor to bottom left of the screen
    	bar.Position = UDim2.new(0, i * (barWidth + spacing), 1, 0) -- Bottom of screen
    	bar.Size = UDim2.new(0, barWidth, 0, 2) -- Start with small height
        bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    	bar.BorderSizePixel = 0
    	bar.Parent = screenGui
    	table.insert(bars, bar)
    end
end

-- Gui to Lua
-- Version: 3.2

-- Instances:

local musicGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local RefreshBtn = Instance.new("TextButton")
local RandomBtn = Instance.new("TextButton")
local StopBtn = Instance.new("TextButton")
local FOVChange = Instance.new("TextBox")

--Properties:

musicGui.Name = "musicGui"
musicGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
musicGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
musicGui.ResetOnSpawn = false

Frame.Parent = musicGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 114, 116)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.626806021, 0, 0.397297293, 0)
Frame.Size = UDim2.new(0, 300, 0, 230)
Frame.Draggable = true
Frame.Active = true

ScrollingFrame.Parent = Frame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(-0.00401606411, 0, 0.126379654, 0)
ScrollingFrame.Size = UDim2.new(0, 302, 0, 208)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

RefreshBtn.Name = "RefreshBtn"
RefreshBtn.Parent = Frame
RefreshBtn.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
RefreshBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Position = UDim2.new(0.761726856, 0, 0.0149999866, 0)
RefreshBtn.Size = UDim2.new(0, 55, 0, 23)
RefreshBtn.Font = Enum.Font.SourceSans
RefreshBtn.Text = "REFRESH"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 14.000

RandomBtn.Name = "RandomBtn"
RandomBtn.Parent = Frame
RandomBtn.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
RandomBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
RandomBtn.BorderSizePixel = 0
RandomBtn.Position = UDim2.new(0.561726856, 0, 0.0149999866, 0)
RandomBtn.Size = UDim2.new(0, 55, 0, 23)
RandomBtn.Font = Enum.Font.SourceSans
RandomBtn.Text = "RANDOM"
RandomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RandomBtn.TextSize = 14.000

StopBtn.Name = "StopBtn"
StopBtn.Parent = Frame
StopBtn.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
StopBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopBtn.BorderSizePixel = 0
StopBtn.Position = UDim2.new(0.0161726856, 0, 0.0149999866, 0)
StopBtn.Size = UDim2.new(0, 55, 0, 23)
StopBtn.Font = Enum.Font.SourceSans
StopBtn.Text = "STOP ALL"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 14.000

FOVChange.Name = "FOVChange"
FOVChange.Parent = Frame
FOVChange.BackgroundColor3 = Color3.fromRGB(255, 155, 157)
FOVChange.BorderColor3 = Color3.fromRGB(0, 0, 0)
FOVChange.BorderSizePixel = 0
FOVChange.Position = UDim2.new(0.2161726856, 0, 0.0149999866, 0)
FOVChange.Size = UDim2.new(0, 55, 0, 23)
FOVChange.Font = Enum.Font.SourceSans
FOVChange.Text = "50"
FOVChange.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVChange.TextSize = 14.000
FOVChange.FocusLost:Connect(function(a)
	if a then
		fovbobweakness = tonumber(FOVChange.Text)
	end
end)

-- Scripts:

function randomSong()
    if #songlist == 0 then return end
    local ran = math.random(1, #songlist)
    playSong(ran, true).Ended:Wait()
    randomSong()
end

function playSong(id, ret)
    for _,v in workspace.CurrentCamera:GetChildren() do
    	if v:IsA("Sound") then
			v:Stop()
    	    v:Destroy()
    	end
	end
    
    local sound = Instance.new("Sound")
    sound.Parent = workspace.CurrentCamera
    sound.SoundId = getcustomasset(songlist[id])
    sound.Volume = 2
    sound:Play()

    if ret then return sound end
end

function getsongs()
    songlist = {}
	for _, file in ipairs(listfiles("songlist/")) do
		if isfile(file) then
            table.insert(songlist, file)
        end
	end
end

function refreshSongs()
    if db == false then return end
    for _,v in ScrollingFrame:GetChildren() do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    getsongs()
    db = false
    many = 0
    for i,_ in ipairs(songlist) do
        if songlist[i] == nil then return end

        local song = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local TextButton = Instance.new("TextButton")

        song.Name = "song"
        song.Parent = ScrollingFrame
        song.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        song.BorderColor3 = Color3.fromRGB(0, 0, 0)
        song.BorderSizePixel = 0
        song.Size = UDim2.new(0, 290, 0, 60)

        TextLabel.Parent = song
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Position = UDim2.new(0.0206520957, 0, 0.349999994, 0)
        TextLabel.Size = UDim2.new(0, 200, 0, 15)
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Text = string.sub(songlist[i], 12)
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 20.000
        TextLabel.TextWrapped = true
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        TextButton.Parent = song
        TextButton.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
        TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(0.7830434537, 0, 0.114999898, 0)
        TextButton.Size = UDim2.new(0, 55, 0, 45)
        TextButton.Font = Enum.Font.SourceSansBold
        TextButton.Text = "PLAY"
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.TextSize = 20.000
        TextButton.MouseButton1Click:Connect(function()
            playSong(i, false)
		    TextButton.Text = "PLAYED"
		    task.wait(1)
		    TextButton.Text = "PLAY"
	    end)
        many += 1
    end
    ScrollingFrame.CanvasSize = UDim2.new(0,0,(math.abs(many)/1.5)/2.34,0)
    db = true
end

RefreshBtn.MouseButton1Click:Connect(function() refreshSongs() end)
RandomBtn.MouseButton1Click:Connect(function() randomSong() end)
StopBtn.MouseButton1Click:Connect(function()
	for _,v in workspace.CurrentCamera:GetChildren() do
    	if v:IsA("Sound") then
			v:Stop()
    	    v:Destroy()
    	end
	end
end)

refreshSongs()

-- Update bars on every frame
RunService.RenderStepped:Connect(function()
    if workspace.CurrentCamera:FindFirstChild("Sound") then
        local sound = workspace.CurrentCamera:FindFirstChild("Sound")
    	if sound and sound.IsPlaying then
    		local loudness = sound.PlaybackLoudness

            if visualiser then
    		    for i, bar in ipairs(bars) do
    		    	local height = math.clamp(loudness / 5 + math.random(-5, 5), 2, barMaxHeight)
    		    	bar.Size = UDim2.new(0, barWidth, 0, height)
    		    end
            end
            if fovchange then
                local cam = workspace.CurrentCamera
                cam.FieldOfView = 70 + (loudness / fovbobweakness)
            end
    	else
            if visualiser then
    		    -- Reset bars if not playing
    		    for _, bar in ipairs(bars) do
			        bar.Size = UDim2.new(0, barWidth, 0, 2)
		        end
            end
            if fovchange then
                local cam = workspace.CurrentCamera
                cam.FieldOfView = 70
            end
	    end
    end
end)
