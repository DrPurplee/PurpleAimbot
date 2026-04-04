-- ╔══════════════════════════════════════════════════════╗
-- ║       🟣  PURPLE DRANK  —  Aimbot + ESP + Crédits   ║
-- ║              By FocusOnTop  💜  2026                 ║
-- ╚══════════════════════════════════════════════════════╝

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name            = "🟣 Purple Drank [BETA]",
	LoadingTitle    = "Purple Drank [BETA]",
	LoadingSubtitle = "•  By FocusOnTop 💜",
	Theme = {
		TextColor                     = Color3.fromRGB(220, 190, 255),
		Background                    = Color3.fromRGB(12,   8,  22),
		Topbar                        = Color3.fromRGB(28,  12,  55),
		Shadow                        = Color3.fromRGB(80,  20, 160),
		NotificationBackground        = Color3.fromRGB(18,  10,  35),
		NotificationActionsBackground = Color3.fromRGB(35,  15,  70),
		TabBackground                 = Color3.fromRGB(20,  10,  40),
		TabStroke                     = Color3.fromRGB(90,  30, 170),
		TabBackgroundSelected         = Color3.fromRGB(110,  30, 210),
		TabTextColor                  = Color3.fromRGB(160, 110, 230),
		SelectedTabTextColor          = Color3.fromRGB(255, 255, 255),
		ElementBackground             = Color3.fromRGB(22,  12,  45),
		ElementBackgroundHover        = Color3.fromRGB(40,  18,  80),
		SecondaryElementBackground    = Color3.fromRGB(28,  14,  55),
		ElementStroke                 = Color3.fromRGB(80,  25, 155),
		SecondaryElementStroke        = Color3.fromRGB(90,  30, 165),
		SliderBackground              = Color3.fromRGB(50,  15, 100),
		SliderProgress                = Color3.fromRGB(140,  40, 255),
		SliderStroke                  = Color3.fromRGB(110,  30, 210),
		ToggleBackground              = Color3.fromRGB(40,  15,  80),
		ToggleEnabled                 = Color3.fromRGB(130,  30, 240),
		ToggleDisabled                = Color3.fromRGB(55,  20,  90),
		ToggleEnabledStroke           = Color3.fromRGB(160,  60, 255),
		ToggleDisabledStroke          = Color3.fromRGB(70,  25, 110),
		ToggleEnabledOuterStroke      = Color3.fromRGB(120,  35, 200),
		ToggleDisabledOuterStroke     = Color3.fromRGB(60,  22,  95),
		DropdownSelected              = Color3.fromRGB(120,  30, 220),
		DropdownUnselected            = Color3.fromRGB(35,  14,  65),
		InputBackground               = Color3.fromRGB(20,  10,  40),
		InputStroke                   = Color3.fromRGB(90,  28, 165),
		PlaceholderColor              = Color3.fromRGB(120,  80, 180),
	},
	DisableRayfieldPrompts = false,
	DisableBuildWarnings   = false,
	ConfigurationSaving = {
		Enabled    = true,
		FolderName = "PurpleDrank",
		FileName   = "WarsConfig",
	},
	KeySystem = false,
})

-- ══════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local LP         = Players.LocalPlayer

local function getChar() return LP.Character end
local function getHRP()  local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c = getChar() return c and c:FindFirstChildOfClass("Humanoid")  end
local function getCam()  return workspace.CurrentCamera end

local function notify(title, content, dur)
	Rayfield:Notify({ Title = title, Content = content, Duration = dur or 3 })
end

-- ══════════════════════════════════════
--  AIMBOT
-- ══════════════════════════════════════
local aimbotEnabled   = false
local aimbotSmoothing = 0.3
local aimbotPart      = "Head"
local aimbotFOV       = 300
local aimbotConn      = nil

local function getClosestTarget()
	local cam = getCam()
	local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
	local best, bestD = nil, aimbotFOV
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local part = plr.Character:FindFirstChild(aimbotPart) or plr.Character:FindFirstChild("HumanoidRootPart")
			local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
			if part and hum and hum.Health > 0 then
				local sp, onScreen = cam:WorldToViewportPoint(part.Position)
				if onScreen then
					local d = (Vector2.new(sp.X,sp.Y) - center).Magnitude
					if d < bestD then bestD = d; best = plr end
				end
			end
		end
	end
	return best
end

local function runAimbot()
	if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
	aimbotConn = RunService.RenderStepped:Connect(function()
		if not aimbotEnabled then return end
		local target = getClosestTarget()
		if not target or not target.Character then return end
		local part = target.Character:FindFirstChild(aimbotPart) or target.Character:FindFirstChild("HumanoidRootPart")
		if not part then return end
		local cam = getCam(); local origin = cam.CFrame.Position
		local tCF = CFrame.new(origin, part.Position)
		cam.CFrame = aimbotSmoothing <= 0.01 and tCF or cam.CFrame:Lerp(tCF, 1 - aimbotSmoothing)
	end)
end

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		aimbotEnabled = not aimbotEnabled
		notify("🎯 Aimbot", aimbotEnabled and "ON 💜" or "OFF 🛑", 2)
	end
end)
runAimbot()

-- ══════════════════════════════════════
--  ESP TRACKALL
-- ══════════════════════════════════════
local trackHL    = {}
local trackBB    = {}
local trackDistC = {}
local trackCharC = {}
local trackOn    = false

local function cleanTrack(plr)
	if trackHL[plr.Name]    then pcall(function() trackHL[plr.Name]:Destroy() end);       trackHL[plr.Name]    = nil end
	if trackBB[plr.Name]    then pcall(function() trackBB[plr.Name]:Destroy() end);       trackBB[plr.Name]    = nil end
	if trackDistC[plr.Name] then pcall(function() trackDistC[plr.Name]:Disconnect() end); trackDistC[plr.Name] = nil end
	if trackCharC[plr.Name] then pcall(function() trackCharC[plr.Name]:Disconnect() end); trackCharC[plr.Name] = nil end
end

local function setupTrackChar(plr, char)
	if trackHL[plr.Name]    then pcall(function() trackHL[plr.Name]:Destroy() end);       trackHL[plr.Name]    = nil end
	if trackBB[plr.Name]    then pcall(function() trackBB[plr.Name]:Destroy() end);       trackBB[plr.Name]    = nil end
	if trackDistC[plr.Name] then pcall(function() trackDistC[plr.Name]:Disconnect() end); trackDistC[plr.Name] = nil end
	task.wait(0.6)
	if not char or not char.Parent then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then
		task.wait(1)
		hrp = char:FindFirstChild("HumanoidRootPart")
		hum = char:FindFirstChildOfClass("Humanoid")
	end
	if not hrp or not hum then return end

	local hl = Instance.new("Highlight")
	hl.FillColor        = Color3.fromRGB(120, 30, 220)
	hl.OutlineColor     = Color3.fromRGB(200, 120, 255)
	hl.FillTransparency = 0.45
	hl.DepthMode        = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent           = char
	trackHL[plr.Name]   = hl

	local bb = Instance.new("BillboardGui")
	bb.Adornee     = hrp
	bb.Size        = UDim2.new(0,200,0,75)
	bb.StudsOffset = Vector3.new(0,5,0)
	bb.AlwaysOnTop = true
	bb.Parent      = hrp
	trackBB[plr.Name] = bb

	local bgFrame = Instance.new("Frame")
	bgFrame.Size                   = UDim2.new(1,0,1,0)
	bgFrame.BackgroundColor3       = Color3.fromRGB(10,5,20)
	bgFrame.BackgroundTransparency = 0.4
	bgFrame.BorderSizePixel        = 0
	bgFrame.Parent                 = bb
	Instance.new("UICorner", bgFrame).CornerRadius = UDim.new(0,6)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(120,30,220); stroke.Thickness = 1.5; stroke.Parent = bgFrame

	local lName = Instance.new("TextLabel")
	lName.Size                   = UDim2.new(1,-6,0,22)
	lName.Position               = UDim2.new(0,3,0,2)
	lName.BackgroundTransparency = 1
	lName.Text                   = "🟣 "..plr.Name
	lName.TextColor3             = Color3.fromRGB(200,130,255)
	lName.TextStrokeTransparency = 0.3
	lName.TextStrokeColor3       = Color3.fromRGB(0,0,0)
	lName.TextScaled             = true
	lName.Font                   = Enum.Font.GothamBold
	lName.Parent                 = bgFrame

	local hpBg = Instance.new("Frame")
	hpBg.Size                   = UDim2.new(1,-6,0,8)
	hpBg.Position               = UDim2.new(0,3,0,26)
	hpBg.BackgroundColor3       = Color3.fromRGB(30,10,50)
	hpBg.BackgroundTransparency = 0.2
	hpBg.BorderSizePixel        = 0
	hpBg.Parent                 = bgFrame
	Instance.new("UICorner",hpBg).CornerRadius = UDim.new(1,0)

	local hpBar = Instance.new("Frame")
	hpBar.Size             = UDim2.new(1,0,1,0)
	hpBar.BackgroundColor3 = Color3.fromRGB(130,30,240)
	hpBar.BorderSizePixel  = 0
	hpBar.Parent           = hpBg
	Instance.new("UICorner",hpBar).CornerRadius = UDim.new(1,0)

	local lHP = Instance.new("TextLabel")
	lHP.Size                   = UDim2.new(1,-6,0,16)
	lHP.Position               = UDim2.new(0,3,0,37)
	lHP.BackgroundTransparency = 1
	lHP.Text                   = "❤️ "..math.floor(hum.Health).." / "..math.floor(hum.MaxHealth)
	lHP.TextColor3             = Color3.fromRGB(220,190,255)
	lHP.TextScaled             = true
	lHP.Font                   = Enum.Font.Gotham
	lHP.Parent                 = bgFrame

	local lDist = Instance.new("TextLabel")
	lDist.Size                   = UDim2.new(1,-6,0,14)
	lDist.Position               = UDim2.new(0,3,0,56)
	lDist.BackgroundTransparency = 1
	lDist.Text                   = "📍 -- st"
	lDist.TextColor3             = Color3.fromRGB(180,140,255)
	lDist.TextScaled             = true
	lDist.Font                   = Enum.Font.Gotham
	lDist.Parent                 = bgFrame

	hum.HealthChanged:Connect(function(hp)
		if not hpBar or not hpBar.Parent then return end
		local ratio = math.clamp(hp / hum.MaxHealth, 0, 1)
		lHP.Text = "❤️ "..math.floor(hp).." / "..math.floor(hum.MaxHealth)
		hpBar.Size = UDim2.new(ratio,0,1,0)
		hpBar.BackgroundColor3 = Color3.fromRGB(
			math.floor(80 + (1-ratio)*150),
			math.floor(ratio*20),
			math.floor(ratio*220)
		)
	end)

	local dc = RunService.RenderStepped:Connect(function()
		if not hrp or not hrp.Parent or not lDist or not lDist.Parent then return end
		local myRoot = getHRP(); if not myRoot then return end
		local d = math.floor((hrp.Position - myRoot.Position).Magnitude)
		lDist.Text = "📍 "..d.." st"
		if     d < 20 then lDist.TextColor3 = Color3.fromRGB(255,60,60)
		elseif d < 50 then lDist.TextColor3 = Color3.fromRGB(200,100,255)
		else               lDist.TextColor3 = Color3.fromRGB(140,80,220) end
	end)
	trackDistC[plr.Name] = dc
end

local function addTrack(plr)
	if plr == LP then return end
	cleanTrack(plr)
	if plr.Character then task.spawn(setupTrackChar, plr, plr.Character) end
	trackCharC[plr.Name] = plr.CharacterAdded:Connect(function(char)
		if trackOn then task.spawn(setupTrackChar, plr, char) end
	end)
end

task.spawn(function()
	while true do
		task.wait(2)
		if trackOn then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= LP then
					if not trackHL[plr.Name] or not trackHL[plr.Name].Parent then
						if plr.Character then task.spawn(setupTrackChar, plr, plr.Character) end
					end
				end
			end
		end
	end
end)

-- ══════════════════════════════════════
--  TAB : AIMBOT
-- ══════════════════════════════════════
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

AimbotTab:CreateSection("🎯 Aimbot — Gunfight Mode")
AimbotTab:CreateLabel("💡 F = ON/OFF rapide")
AimbotTab:CreateToggle({
	Name = "🎯 Aimbot ON/OFF", CurrentValue = false, Flag = "AimbotToggle",
	Callback = function(v) aimbotEnabled = v; notify("🎯 Aimbot", v and "ON 💜" or "OFF 🛑", 2) end,
})
AimbotTab:CreateSlider({
	Name = "🔭 FOV détection", Range = {50,800}, Increment = 10,
	Suffix = " px", CurrentValue = 300, Flag = "AimbotFOV",
	Callback = function(v) aimbotFOV = v end,
})
AimbotTab:CreateSlider({
	Name = "🌊 Smoothing", Range = {0,90}, Increment = 5,
	Suffix = "%", CurrentValue = 30, Flag = "AimbotSmooth",
	Callback = function(v) aimbotSmoothing = v / 100 end,
})
AimbotTab:CreateSection("🎯 Partie visée")
AimbotTab:CreateDropdown({
	Name = "Partie du corps",
	Options = {"Head","HumanoidRootPart","UpperTorso","LowerTorso"},
	CurrentOption = {"Head"}, Flag = "AimbotPart",
	Callback = function(sel) aimbotPart = sel[1] or "Head"; notify("🎯","Vise : "..aimbotPart.." 💜",2) end,
})
AimbotTab:CreateLabel("💡 Smoothing 0% = snap | 50%+ = fluide")

-- ══════════════════════════════════════
--  TAB : TRACKALL
-- ══════════════════════════════════════
local ESPTab = Window:CreateTab("👁️ TrackAll", 4483362458)
ESPTab:CreateSection("ESP Pro")
ESPTab:CreateLabel("💡 Wallhack • HP bar • Distance • Auto-respawn")
ESPTab:CreateToggle({
	Name = "👁️ TrackAll ON/OFF", CurrentValue = false, Flag = "TrackAll",
	Callback = function(v)
		trackOn = v
		if v then
			for _, p in pairs(Players:GetPlayers()) do addTrack(p) end
			notify("👁️ TrackAll","ON 💜")
		else
			for _, p in pairs(Players:GetPlayers()) do cleanTrack(p) end
			notify("👁️ TrackAll","OFF",2)
		end
	end,
})
ESPTab:CreateButton({
	Name = "🔄 Refresh manuel",
	Callback = function()
		if not trackOn then notify("❌","Active TrackAll d'abord !",2) return end
		for _, p in pairs(Players:GetPlayers()) do cleanTrack(p) end
		task.wait(0.3)
		for _, p in pairs(Players:GetPlayers()) do addTrack(p) end
		notify("🔄","Rafraîchi 💜",2)
	end,
})
Players.PlayerAdded:Connect(function(p) task.wait(1); if trackOn then addTrack(p) end end)
Players.PlayerRemoving:Connect(function(p) cleanTrack(p) end)

-- ══════════════════════════════════════
--  TAB : CRÉDITS
-- ══════════════════════════════════════
local CreditsTab = Window:CreateTab("💜 Crédits", 4483362458)
CreditsTab:CreateSection("Dev")
CreditsTab:CreateLabel("👑 FocusOnTop")
CreditsTab:CreateLabel("💬 DISCORD SOON")
CreditsTab:CreateSection("Build")
CreditsTab:CreateLabel("🟣 Purple Drank — BETA")
CreditsTab:CreateLabel("💜 Aimbot • ESP TrackAll")

-- ══════════════════════════════════════
--  INIT
-- ══════════════════════════════════════
notify("🟣 Purple Drank","beta chargé ! 💜  — By FocusOnTop",5)
