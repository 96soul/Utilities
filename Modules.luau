repeat 
	task.wait()
until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer

if game['CoreGui']:FindFirstChild('lnwza') then
	game['CoreGui']:FindFirstChild('lnwza'):Destroy()
end

local _env: ENVIRONMENT = (getgenv or getrenv or getfenv)()
local _game: GetService = setmetatable({}, {__index = function(_, key) return cloneref(game:GetService(key))end})
local _library: Set = loadstring(game:HttpGet("https://raw.githubusercontent.com/96soul/Library/refs/heads/main/Main", true))()
if _env._request then return end
_env._request = true

local VirtualInputManager: VirtualInputManager = _game["VirtualInputManager"]
local CollectionService: CollectionService = _game["CollectionService"]
local ReplicatedStorage: ReplicatedStorage = _game["ReplicatedStorage"]
local Lighting: Lighting = _game['Lighting']
local HttpService: HttpService = _game['HttpService']
local TeleportService: TeleportService = _game["TeleportService"]
local VirtualUser: VirtualUser = _game['VirtualUser']
local RunService: RunService = _game["RunService"]
local Players: Players = _game["Players"]

local LocalPlayer: LocalPlayers = Players['LocalPlayer']
local Backpack: Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts: PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local Character: Model? = LocalPlayer['Character']
local Humanoid: Humanoid = Character:WaitForChild('Humanoid')
local HumanoidRootPart: Part = Character:WaitForChild('HumanoidRootPart')

local PlaceId: number = game['PlaceId']
local JobId: string = game['JobId']
local Configs: Set = {}
local Indexing: Set = {}
local Folder: string = "Fetching'Script/Config/" .. LocalPlayer.UserId .. "/" .. PlaceId .. ".json"

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
	Humanoid = newCharacter:WaitForChild("Humanoid")
end)

LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController();
	VirtualUser:ClickButton2(Vector2.new());
end)

function translate(en, th)
	if Configs['Lauguage'] == "Thailand" then
		return tostring(th)
	else
		return tostring(en)
	end
end

local Module: table = {}

do
	Module[1] = {} do
		Module[1].connect = function(interval: number?, func: (() -> ())?, protectcall: boolean?)
			interval, protectcall = interval or 1,  protectcall == true
			if type(func) ~= "function" then return warn("Invalid function provided to connect.")end
			return task.spawn(function()
				while task.wait(interval) do
					if protectcall then 
					pcall(func)
					else func() end
				end
			end)
		end
		
		Module[1].dist = function(v: any?)
			if not HumanoidRootPart then return end
			if typeof(v) == "Instance" and v:IsA("Model") then
				return (v:GetPivot().Position - HumanoidRootPart.Position).Magnitude
			elseif typeof(v) == "Instance" and v:IsA("BasePart") then
				return (v.Position - HumanoidRootPart.Position).Magnitude
			elseif typeof(v) == "CFrame" then
				return (v.Position - HumanoidRootPart.Position).Magnitude
			elseif typeof(v) == "Vector3" then
				return (v - HumanoidRootPart.Position).Magnitude
			elseif typeof(v) == 'table' then
				return (Vector3.new(v[1], v[2], v[3]) - HumanoidRootPart.Position).Magnitude
			else
				return warn("invalid Instance: v")
			end
		end
		
		Module[1].tp = function(pos: any?, v: boolean?)
			if not HumanoidRootPart then return end
			if typeof(pos) == "CFrame" then
				HumanoidRootPart.CFrame = v and (pos * CFrame.Angles(math.rad(-90), 0, 0)) or pos
			elseif typeof(pos) == "Vector3" then
				HumanoidRootPart.CFrame = v and (CFrame.new(pos) * CFrame.Angles(math.rad(-90), 0, 0)) or CFrame.new(pos)
			elseif typeof(pos) == "Instance" and pos:IsA("Model") then
				HumanoidRootPart.CFrame = v and (pos:GetPivot() * CFrame.Angles(math.rad(-90), 0, 0)) or pos:GetPivot()
			elseif typeof(pos) == "Instance" and pos:IsA("BasePart") then
				HumanoidRootPart.CFrame = v and (pos.CFrame * CFrame.Angles(math.rad(-90), 0, 0)) or pos.CFrame
			elseif typeof(pos) == 'table' then
				HumanoidRootPart.CFrame = v and (pos.CFrame * CFrame.Angles(math.rad(-90), 0, 0)) or CFrame.new(pos[1], pos[2], pos[3])
			end
		end
		
		Module[1].hop = function()
			local ListServers = function(cursor: SharedTable) return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100" .. ((cursor and "&cursor="..cursor) or ""))) end
			local Server, Next
			repeat
				local Servers = ListServers(Next)
				Server = Servers.data[1]
				Next = Servers.nextPageCursor
			until Server;TeleportService:TeleportToPlaceInstance(PlaceId,Server.id,LocalPlayer)
		end
		
		Module[1].rj = function()
			if #Players:GetPlayers() <= 1 then
				LocalPlayer:Kick("\nRejoining...")
				wait()
				TeleportService:Teleport(PlaceId, LocalPlayer)
			else
				TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
			end
		end
		
		Module[1].html = function(text: string?, color: Color3?)
			if type(text) == "string" and typeof(color) == "Color3" then
				local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
				return string.format('<font color="rgb(%d, %d, %d)">%s</font>', r, g, b, text)
			end
			return text
		end
		
		Module[1].name = function()
			return tostring(_game['MarketplaceService']:GetProductInfo(PlaceId).Name)
		end
		
		Module[1].esp = function(meta: Set?)
			local v = meta.Instance
			local title = meta.Name or v.Name
			local MainColor = meta.Color or Color3.fromRGB(255, 255, 255)
			local DropColor = meta.Drop or Color3.fromRGB(127, 127, 127)
			if not v:FindFirstChild('Constant') then
				local bill = Instance.new('BillboardGui',v)
				bill.Name = 'Constant'
				bill.Size = UDim2.fromOffset(100, 100)
				bill.MaxDistance = math.huge
				bill.Adornee = v
				bill.AlwaysOnTop = true

				local circle = Instance.new("Frame", bill)
				circle.Position = UDim2.fromScale(0.5, 0.5)
				circle.AnchorPoint = Vector2.new(0.5, 0.5)
				circle.Size = UDim2.fromOffset(6, 6)
				circle.BackgroundColor3 = Color3.fromRGB(255,255,255)

				local gradient = Instance.new("UIGradient", circle)
				gradient.Rotation = 90
				gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, MainColor), ColorSequenceKeypoint.new(1, DropColor)})

				local stroke = Instance.new("UIStroke", circle)
				stroke.Thickness = 0.5

				local name = Instance.new('TextLabel',bill)
				name.Font = Enum.Font.GothamBold
				name.AnchorPoint = Vector2.new(0, 0.5)
				name.Size = UDim2.fromScale(1, 0.3)
				name.TextScaled = true
				name.BackgroundTransparency = 1
				name.TextStrokeTransparency = 0
				name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				name.Position = UDim2.new(0, 0, 0.5, 24)
				name.TextColor3 = Color3.fromRGB(255, 255, 255)
				name.Text = "nil"

				local gradient = Instance.new("UIGradient", name)
				gradient.Rotation = 0
				gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, MainColor), ColorSequenceKeypoint.new(1, DropColor)})
			else
				if v:IsA("Model") then
					v:FindFirstChild('Constant'):FindFirstChild("TextLabel").Text = title .. '\n[ ' .. math.floor(tonumber((HumanoidRootPart.Position - v:GetPivot().Position).Magnitude / 3) + 1) .. ' ]'
				elseif v:IsA("BasePart") then
					v:FindFirstChild('Constant'):FindFirstChild("TextLabel").Text = title .. '\n[ ' .. math.floor(tonumber((HumanoidRootPart.Position - v.Position).Magnitude / 3) + 1) .. ' ]'
				end
			end
		end
		
		Module[1].unesp = function(v: any?)
			if v:FindFirstChild('Constant') then
				v:FindFirstChild('Constant'):Destroy()
			end
		end
		
		Module[1].def = function(v: string, a: boolean | string | number | table | any)
			if type(v) == "table" then
				for i, k in pairs(v) do
					if Configs[i] == nil then
						Configs[i] = k
					end
				end
			else
				if Configs[v] == nil then
					Configs[v] = a
				end
			end
		end
		
		Module[1].save = function(key: string, value: boolean | string | number | table | any)
			if key ~= nil then Configs[key] = value;end
			if not isfolder("Fetching'Script") then makefolder("Fetching'Script");end
			writefile(Folder, HttpService:JSONEncode(Configs))
		end
		
		Module[1].load = function()
			local base = "Fetching'Script/Config/" .. LocalPlayer.UserId
			local path = base .. "/" .. PlaceId .. ".json"
			if not isfolder("Fetching'Script") then makefolder("Fetching'Script") end
			if not isfolder("Fetching'Script/Config") then makefolder("Fetching'Script/Config") end
			if not isfolder(base) then makefolder(base) end
			if not isfile(path) then Module[1].save() end
			return HttpService:JSONDecode(readfile(path))
		end
		
		Configs = Module[1].load()
		
		Module[1].tab = function(window: table ,title: string, desc: string, icon: number)
			local Options = {
				Title = title,
				Desc = desc,
				Icon = icon
			}
			return window:Add(Options) 
		end
		
		Module[1].sec = function(tab: table ,title: string, desc: string)
			local Options = {
				Title = title,
				Side = desc
			}
			return tab:Sec(Options) 
		end
		
		Module[1].button = function(sec: table ,title: string, call: func)
			local Options = {
				Title = title,
				Callback = call
			}
			return sec:Button(Options) 
		end
		
		Module[1].imagebutton = function(sec: table ,title: string, Icon, call: func)
			local Options = {
				Title = title,
				Icon = Icon,
				Callback = call
			}
			return sec:ButtomImage(Options) 
		end
		
		Module[1].toggle = function(meta: table)
			local Section: Section = meta.sec or false
			if not Section then return "No Section" end
			local Delay: number = meta.delay or 0.1
			local Title: string = meta.title or "Toggle"
			local Index: boolean = meta.index or true
			local Icon: number = meta.icon or ""
			local Setting: string = meta.setting or ""
			local Function: func = meta.self or ""
			local Callback: func = meta.call or ""

			if Function ~= "" then
				if Index then
					if not Indexing[Setting] then
						table.insert(Indexing, Setting)
					end
				end
				Module[1].connect(Delay, function()
					if Configs[Setting] then
						Function()
					end
				end, false)
			end

			if Icon == "" then
				local Options: table = {
					Title = Title,
					Value = Configs[Setting],
					Callback = function(value)
						Configs[Setting] = value
						Module[1].save(Setting, value)
						if Callback ~= "" then 
							Callback(value)
						end
					end
				}

				return Section:Toggle(Options)
			else
				local Options: table = {
					Title = Title,
					Value = Configs[Setting],
					Icon = Icon,
					Callback = (function(value)
						Configs[Setting] = value
						Module[1].save(Setting, value)
						if Callback ~= "" then 
							Callback(value)
						end
					end)
				}

				return Section:ToggleImage(Options)
			end

		end
		
		Module.toggle = function(meta)
			local Section: Section = meta.sec or false
			if not Section then return "No Section" end
			local Title: string = meta.title or "Toggle"
			local Setting: string = meta.setting or ""
			local Callback: func = meta.call or ""
			local Options: table = {
				Title = Title,
				Value = Configs[Setting],
				Callback = function(value)
					Configs[Setting] = value
					Module[1].save(Setting, value)
					if Callback ~= "" then 
						Callback(value)
					end
				end
			}
			return Section:Toggle(Options)
		end
		
		Module[1].list = function(sec: table, title: string, list: table, m: boolean, setting: string)
			sec:Dropdown({Title = title,Multi = m,List = list,Value = Configs[setting],Callback = function(v)
				Configs[setting] = v
				Module[1].save(setting, v)
			end})
		end
		
		Module[1].def('X', 0)
		Module[1].def('Y', 0)
		Module[1].init = (function()
			if Configs['X'] == 0 and Configs['Y'] == 0 then
				if _game['UserInputService'].KeyboardEnabled then
					return UDim2.new(0, 750, 0, 800)
				else
					return UDim2.new(0, 500, 0, 350)
				end
			else
				return UDim2.new(0, Configs['X'], 0, Configs['Y'])
			end
		end)
		
		function Module:setup(window: table)
			local Home = window:Add({Title = translate("Configure", "คอนฟิกเกอร์"),Desc = translate("Managers", "ระบบหลัก"),Icon = 132831270943713}) do
				local Performance = Home:Sec({Title = translate("Performance", "ประสิทธิภาพ"), Side = "l"}) do
					Module.toggle({sec = Performance,title = translate("Enable White Screen", "เปิดใช้งานจอขาว"),setting = "White Screen",call = function(v)
						if v then
							RunService:Set3dRenderingEnabled(false)
						else
							RunService:Set3dRenderingEnabled(true)
						end
					end})
					Module.toggle({sec = Performance,title = translate("Enable Fullbright", "เปิดใช้งานแสงสว่าง"), setting = "Fullbright"})
					Module[1].button(Performance,translate("Boost FPS", "แก้แลค"), function()
						pcall(function()
							local Terrain = workspace:FindFirstChildOfClass('Terrain')
							Terrain.WaterWaveSize = 0
							Terrain.WaterWaveSpeed = 0
							Terrain.WaterReflectance = 0
							Terrain.WaterTransparency = 0
							game.Lighting.GlobalShadows = false
							game.Lighting.FogEnd = 9e9
							settings().Rendering.QualityLevel = 1
							for i,v in pairs(game:GetDescendants()) do
								if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
									v.Material = "Plastic"
									v.Reflectance = 0
								elseif v:IsA("Decal") then
									v.Transparency = 1
								elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
									v.Lifetime = NumberRange.new(0)
								elseif v:IsA("Explosion") then
									v.BlastPressure = 1
									v.BlastRadius = 1
								end
							end
							for i,v in pairs(_game['Lighting']:GetDescendants()) do
								if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
									v.Enabled = false
								end
							end
						end)
					end)
				end

				local Server = Home:Sec({Title = translate("Server", "เซิร์ฟเวอร์"), Side = "r"}) do
					Module[1].def('Input JobID', JobId)
					Server:Textbox({Value = Configs["Input JobID"], function(v)
						Configs["Input JobID"] = v
						Module[1].save("Input JobID", v)
					end})
					Module[1].button(Server, translate("Join", "เข้าร่วม"), function()
						TeleportService:TeleportToPlaceInstance(PlaceId, Configs['Input JobID'], LocalPlayer)
					end)
					Module[1].button(Server, translate("Clipboard JobId", "คัดลอกไอดีเซิร์ฟเวอร์"), function()
						setclipboard(JobId)
					end)
					Module[1].button(Server, translate("Rejoin", "รีเจอย์"), function()
						Module[1].rj()
					end)
					Module[1].button(Server, translate("Change Server", "เปลี่ยนเซิร์ฟเวอร์"), function()
						Module[1].hop()
					end)
				end

				local PlayersSS = Home:Sec({Title = translate("Players", "ผู้เล่น"), Side = "l"}) do
					local AllPlayer = {}

					for _, v in pairs(Players:GetPlayers()) do
						if v ~= LocalPlayer and v.Character then
							table.insert(AllPlayer, v.Name)
						end
					end

					Module[1].def('Select Player', AllPlayer[1])
					local PlayerDropdown = PlayersSS:Dropdown({Title = translate("Select Player", "เลือกผู้เล่น"),Multi = false,List = AllPlayer,Value = Configs['Select Player'],Callback = function(v)
						Configs['Select Player'] = v
						Module[1].save('Select Player', v)
					end})

					Module[1].button(PlayersSS ,translate("Refresh", "รีเฟรช"), function()
						PlayerDropdown:Clear()
						for _, v in pairs(Players:GetPlayers()) do
							if v ~= LocalPlayer and v.Character then
								PlayerDropdown:AddList(v.Name)
							end
						end
					end)

					Module[1].button(PlayersSS, translate("Teleport", "เทเลพอร์ต"), function()
						pcall(function()
							local player = Players:FindFirstChild(Configs["Select Player"])
							if player and player.Character then
								Module[1].tp(player.Character)
							end
						end)
					end)

					Module.toggle({sec = PlayersSS,title = translate("View Player", "ดูผู้เล่น"),setting = "View Player", call = function(v)
						if v then
							local player = Players:FindFirstChild(Configs["Select Player"])
							if player and player.Character then
								workspace.CurrentCamera.CameraSubject = player.Character
							end
						else
							workspace.CurrentCamera.CameraSubject = Humanoid
						end
					end})
				end

				local Power = Home:Sec({Title = translate("Powers", "ความสามารถพิเศษ"), Side = "r"}) do
					local OldSpeed = Humanoid.WalkSpeed
					Module[1].def('Walkspeed', Humanoid.WalkSpeed)

					local CFloop
					Power:Toggle({Title = translate("CFLY", "ถอดวิญญาณ"), Value = false, Callback = function(v)
						if v then
							Humanoid.PlatformStand = true
							local Head = Character:WaitForChild("Head")
							Head.Anchored = true
							if CFloop then CFloop:Disconnect() end
							CFloop = RunService.Heartbeat:Connect(function(deltaTime)
								local moveDirection = Character:FindFirstChildOfClass('Humanoid').MoveDirection * (100 * deltaTime)
								local headCFrame = Head.CFrame
								local cameraCFrame = workspace.CurrentCamera.CFrame
								local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
								cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
								local cameraPosition = cameraCFrame.Position
								local headPosition = headCFrame.Position

								local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
								Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
							end)
						else
							if CFloop then
								CFloop:Disconnect()
								Humanoid.PlatformStand = false
								local Head = Character:WaitForChild("Head")
								Head.Anchored = false
							end
						end
					end})

					Power:Slider({Title = translate("Speed", "ความเร็ว"),Min = 16,Max = 150,Value = Configs['Walkspeed'], CallBack = function(v)
						Configs['Walkspeed'] = v
						Module[1].save('Walkspeed', v)
						Humanoid.WalkSpeed = v
					end})

					Module[1].button(Power, translate("Change to Old Walkspeed", "คืนค่าความเร็ว"), function()
						Humanoid.WalkSpeed = OldSpeed
					end)

					LocalPlayer.CharacterAdded:Connect(function(char)
						char:WaitForChild("Humanoid").WalkSpeed = Configs['Walkspeed']
					end)
				end

				local Config = Home:Sec({Title = translate("Configs", "การตั้งค่า"), Side = "r"}) do
					Module[1].def('Lauguage', 'English [ Default ]')
					Module[1].toggle({sec = Config,title = translate("Keep Script", "ออโต้รันสคริปต์ [ บางครั้งก็ไม่ติด ]"), setting = "Keep Script"})
					Module[1].list(Config, translate("Lauguage", 'เลือกภาษา'), {'Thailand', 'English [ Default ]'}, false, 'Lauguage')
					Module[1].button(Config, translate("Change Lauguage", "เปลี่ยนภาษา"), function()
						Module[1].rj()
					end)
					Config:Line()
					Module[1].button(Config, translate("Reset Configs", "ลบการตั้งค่า"), function()
						delfile(Folder)
					end)
					Module[1].button(Config, translate("Reset All Configs", "ลบการตั้งค่าทั้งหมด"), function()
						if isfile("Fetching'Script/Config/" .. LocalPlayer.UserId) then
							delfile("Fetching'Script/Config/" .. LocalPlayer.UserId)
						else
							warn("Configs is Delete")
						end
					end)
				end
			end

			_env.NormalLightingSettings = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				FogEnd = Lighting.FogEnd,
				GlobalShadows = Lighting.GlobalShadows,
				Ambient = Lighting.Ambient
			}

			Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
				if Lighting.Brightness ~= 1 and Lighting.Brightness ~= _env.NormalLightingSettings.Brightness then
					_env.NormalLightingSettings.Brightness = Lighting.Brightness
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.Brightness = 1
				end
			end)

			Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
				if Lighting.ClockTime ~= 12 and Lighting.ClockTime ~= _env.NormalLightingSettings.ClockTime then
					_env.NormalLightingSettings.ClockTime = Lighting.ClockTime
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.ClockTime = 12
				end
			end)

			Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
				if Lighting.FogEnd ~= 786543 and Lighting.FogEnd ~= _env.NormalLightingSettings.FogEnd then
					_env.NormalLightingSettings.FogEnd = Lighting.FogEnd
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.FogEnd = 786543
				end
			end)

			Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
				if Lighting.GlobalShadows ~= false and Lighting.GlobalShadows ~= _env.NormalLightingSettings.GlobalShadows then
					_env.NormalLightingSettings.GlobalShadows = Lighting.GlobalShadows
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.GlobalShadows = false
				end
			end)

			Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
				if Lighting.Ambient ~= Color3.fromRGB(178, 178, 178) and Lighting.Ambient ~= _env.NormalLightingSettings.Ambient then
					_env.NormalLightingSettings.Ambient = Lighting.Ambient
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.Ambient = Color3.fromRGB(178, 178, 178)
				end
			end)

			Lighting.Brightness = 1
			Lighting.ClockTime = 12
			Lighting.FogEnd = 786543
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)

			local LatestValue = true
			Module[1].connect(0, function()
				if Configs['Fullbright'] ~= LatestValue then
					if not Configs['Fullbright'] then
						Lighting.Brightness = _env.NormalLightingSettings.Brightness
						Lighting.ClockTime = _env.NormalLightingSettings.ClockTime
						Lighting.FogEnd = _env.NormalLightingSettings.FogEnd
						Lighting.GlobalShadows = _env.NormalLightingSettings.GlobalShadows
						Lighting.Ambient = _env.NormalLightingSettings.Ambient
					else
						Lighting.Brightness = 1
						Lighting.ClockTime = 12
						Lighting.FogEnd = 786543
						Lighting.GlobalShadows = false
						Lighting.Ambient = Color3.fromRGB(178, 178, 178)
					end
					LatestValue = not LatestValue
				end
			end, true)

			local TeleportCheck = false
			LocalPlayer.OnTeleport:Connect(function(State)
				if Configs['Keep Script'] and (not TeleportCheck) and queueonteleport then
					TeleportCheck = true
					queueonteleport("loadstring(game:HttpGet('https://github.com/96soul/-/blob/main/load.gg?raw=true', true))()")
				end
			end)
			
			do repeat wait() until game:GetService("CoreGui").lnwza.Background
				game:GetService("CoreGui").lnwza.Background:GetPropertyChangedSignal("Size"):Connect(function()
					local size = game:GetService("CoreGui").lnwza.Background.Size
					Module[1].save('X', size.X.Offset)
					Module[1].save('Y', size.Y.Offset)
				end)
			end
		end
	end
	
	Module[2] = {} do
		if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
			repeat 
				task.wait()
			until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.PlayerGui and game:GetService("Players").LocalPlayer.Backpack and game:GetService("Players").LocalPlayer.PlayerScripts and game:GetService("Players").LocalPlayer.Team and game:GetService("Players").LocalPlayer.Data and game:GetService("Players").LocalPlayer.Data.Level and game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
			do
				local Remotes = _game['ReplicatedStorage']:WaitForChild("Remotes")
				local CommF = Remotes:WaitForChild("CommF_")
				local WorldOrigin = workspace:WaitForChild("_WorldOrigin")
				local Characters = workspace:WaitForChild("Characters")
				local SeaBeasts = workspace:WaitForChild("SeaBeasts")
				local Enemies = workspace:WaitForChild("Enemies")
				local Boats = workspace:WaitForChild("Boats")
				local Map = workspace:WaitForChild("Map")
				local EnemySpawns = WorldOrigin:WaitForChild("EnemySpawns")
				local Locations = WorldOrigin:WaitForChild("Locations")
				local BoatShopCFrame = CFrame.new(-16928, 9, 437)

				Module[2].tags = {
					['__Elite'] = { "Deandre", "Diablo", "Urban" },
					['__Bones'] = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy", "Soul Reaper"},
					['__CakePrince'] = { "Head Baker", "Baking Staff", "Cake Guard", "Cookie Crafter" },
					['__TyrantSkies'] = { "Sun-kissed Warrior", "Skull Slayer", "Isle Champion", "Serpent Hunter" },
				}

				Module[2].comf = function(...)
					return CommF:InvokeServer(...)
				end

				Module[2].backpack = function(c)
					return Module[2].comf("LoadItem", c)
				end

				Module[2].gate = function(v3)
					return Module[2].comf("requestEntrance", v3)
				end

				Module[2].getWorld = function()
					if game.PlaceId == 2753915549 then
						return 1
					elseif game.PlaceId == 4442272183 then
						return 2
					elseif game.PlaceId == 7449423635 then
						return 3
					end
				end

				Module[2].IsAlly = function(__Player)
					if tostring(__Player.Team) == "Marines" and __Player.Team == LocalPlayer.Team then
						return false
					elseif __Player:HasTag(`Ally{LocalPlayer.Name}`) or LocalPlayer:HasTag(`Ally{__Player.Name}`) then
						return false
					end

					return true
				end

				Module[2].Boss = function()
					if game.PlaceId == 2753915549 then
						return {
							"The Gorilla King",
							"Chef",
							"Yeti",
							"Mob Leader",
							"Vice Admiral",
							"Warden",
							"Chief Warden",
							"Swan",
							"Magma Admiral",
							"Fishman Lord",
							"Wysper",
							"Thunder God",
							"Cyborg",
							"Saber Expert"
						}
					elseif game.PlaceId == 4442272183 then
						return {
							"Diamond",
							"Jeremy",
							"Orbitus",
							"Don Swan",
							"Smoke Admiral",
							"Cursed Captain",
							"Darkbeard",
							"Order",
							"Awakened Ice Admiral",
							"Tide Keeper"
						}
					elseif game.PlaceId == 7449423635 then
						return {
							"Stone",
							"Hydra Leader",
							"Kilo Admiral",
							"Captain Elephant",
							"Beautiful Pirate",
							"rip_indra True Form",
							"Longma",
							"Soul Reaper",
							"Cake Queen"
						}
					end
				end

				Module[2].Meterials = function()
					if game.PlaceId == 2753915549 then
						return {
							"Magma Ore",
							"Leather",
							"Scrap Metal",
							"Angel Wings",
							"Fish Tail",
							'Yeti Fur',
							'GunPowder'
						}
					elseif game.PlaceId == 4442272183 then
						return {
							"Magma Ore",
							"Scrap Metal",
							"Radioactive Material",
							"Vampire Fang",
							"Mystic Droplet",
						}
					elseif game.PlaceId == 7449423635 then
						return {
							"Mini Tusk",
							"Fish Tail",
							"Scrap Metal",
							"Dragon Scale",
							"Conjured Cocoa",
							"Demonic Wisp",
							"Gunpowder",
						}
					end
				end

				Module[2].Getraid = function()
					local Success, RaidModule = pcall(require, _game['ReplicatedStorage']:WaitForChild("Raids"))
					if not Success or type(RaidModule) ~= "table" then
						return {
							"Phoenix", "Dough", "Flame", "Ice", "Quake", "Light";
							"Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand";
						}
					end
					local AdvancedRaids = RaidModule.advancedRaids or {}
					local NormalRaids = RaidModule.raids or {}
					local RaidList = {}
					for i = 1, #AdvancedRaids do table.insert(RaidList, AdvancedRaids[i]) end
					for i = 1, #NormalRaids do table.insert(RaidList, NormalRaids[i]) end
					return RaidList
				end

				Module[2].world = Module[2].getWorld()
				Module[2].BossData = Module[2].Boss()
				Module[2].MeterialsData = Module[2].Meterials() 
				Module[2].LevelQuest = 1

				Module[2].attack = loadstring(game:HttpGet("https://raw.githubusercontent.com/MerrySubs4t/fetching/refs/heads/main/Utils/Attack.lua", true))()

				Module[2].equip = function(Tool, IsToolTip)
					if not Humanoid then return end
					if IsToolTip then
						for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
							if tool:IsA("Tool") and tool.ToolTip == Tool then
								Humanoid:EquipTool(tool)
								break
							end
						end
					else
						if Backpack:FindFirstChild(Tool) then
							Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(Tool))
						end
					end
				end

				Module[2].tp = function(Position)
					if not Character then return end
					local Distance = (Position.Position - HumanoidRootPart.Position).Magnitude
					local Position = CFrame.new(math.floor(Position.Position.X), math.floor(Position.Position.Y), math.floor(Position.Position.Z))
					if not HumanoidRootPart:FindFirstChild("GGEZ") then
						local BodyVelocity = Instance.new("BodyVelocity")
						BodyVelocity.Name = "GGEZ"
						BodyVelocity.Parent = HumanoidRootPart
						BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						BodyVelocity.Velocity = Vector3.new(0, 0, 0)
					end
					local Distance = (Position.Position - HumanoidRootPart.Position).Magnitude
					for _, v in pairs(Character:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = false
						end
					end
					Humanoid.PlatformStand = true
					if not Configs['Prehistoric - Find'] or not Configs['Kitsune Shrine - Find'] or not Configs['Mirage - Find'] or not Configs['Frozen Gate - Find'] or not Configs['Full Sea Events'] or not Configs['GS Hunt'] or not Configs['SB Hunt'] then
						if Humanoid.Sit then Humanoid.Sit = false end
					end
					if Configs["Performance Farm"] then task.wait(0.5) end
					if Distance > 0 and Distance < 300 then
						return _game.TweenService:Create(HumanoidRootPart,TweenInfo.new(0.08, Enum.EasingStyle.Linear),{CFrame = Position}):Play()
					else
						local tw = _game.TweenService:Create(HumanoidRootPart,TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear),{CFrame = Position})
						function StopTween()
							if tw then
								tw:Cancel()
							end
						end
						return tw:Play()
					end
				end
				
				Module[2].TweenShip = function(v, Position)
					if not v:IsA("Model") and not (v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0) then return end
					local seat = v:FindFirstChild("VehicleSeat")
					local pos = seat.Position
					if not seat then return end
					local Distance = (Position.Position - v:GetPivot().Position).Magnitude
					for _, part in pairs(v:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
					do
						local bp = seat:FindFirstChild("BodyPosition")
						local bv = seat:FindFirstChild("BodyVelocity")
						if not bv and bp then return end
						bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
						bv.P = 0
						bp.MaxForce = Vector3.new(0, 0, 0)
					end
					local tw = _game['TweenService']:Create(seat, TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear), {CFrame = Position})
					function StopShip()
						if tw then tw:Cancel() end
					end
					seat.CFrame = CFrame.new(pos.X, Configs['Distance Y'], pos.Z)
					tw:Play()
				end

				Module[2].tablecheck = function(config, _table)
					for _,v in pairs(_table) do
						if config[v] == true then
							return true 
						end 
					end 
					return false 
				end
				
				Module[2].stopship = function()
					pcall(StopTween)
				end

				Module[1].connect(0, function()
					pcall(function()
						if not Module[2].tablecheck(Configs, Indexing) then
							if HumanoidRootPart:FindFirstChild("GGEZ") then
								HumanoidRootPart:FindFirstChild("GGEZ"):Destroy()
							end
							pcall(StopTween)
							pcall(StopShip)
							Humanoid.PlatformStand = false
						else
							task.spawn(Module[2].attack)
						end
					end)
				end)

				Module[2].alive = function(mob)
					return mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0
				end

				Module[2].GetMobMaterail = function()
					if Module[2].world == 1 then
						if (Configs['Select Materails'] == "Magma Ore") then
							return { "Military Soldier", "Military Spy" }
						elseif ((Configs['Select Materails'] == "Leather") or (Configs['Select Materails'] == "Scrap Metal")) then
							return { "Brute"}
						elseif (Configs['Select Materails'] == "Angel Wings") then
							return { "God's Guard"}
						elseif (Configs['Select Materails'] == "Fish Tail") then
							return { "Fishman Warrior", "Fishman Commando" }
						elseif (Configs['Select Materails'] == "GunPowder") then
							return {"Brute", "Pirate"}
						end
					elseif Module[2].world == 2 then
						if (Configs['Select Materails'] == "Magma Ore") then
							return { "Magma Ninja" }
						elseif (Configs['Select Materails'] == "Scrap Metal") then
							return { "Swan Pirate" }
						elseif (Configs['Select Materails'] == "Radioactive Material") then
							return { "Factory Staff" }
						elseif (Configs['Select Materails'] == "Vampire Fang") then
							return { "Vampire" }
						elseif (Configs['Select Materails'] == "Mystic Droplet") then
							return { "Water Fighter", "Sea Soldier" };
						elseif (Configs['Select Materails'] == "Meteorite") then
							return "Fajita"
						end
					elseif Module[2].world == 3 then
						if (Configs['Select Materails'] == "Mini Tusk") then
							return { "Mythological Pirate" }
						elseif (Configs['Select Materails'] == "Fish Tail") then
							return { "Fishman Raider", "Fishman Captain" }
						elseif (Configs['Select Materails'] == "Scrap Metal") then
							return { "Jungle Pirate" }
						elseif (Configs['Select Materails'] == "Dragon Scale") then
							return { "Dragon Crew Archer", "Dragon Crew Warrior" }
						elseif (Configs['Select Materails'] == "Conjured Cocoa") then
							return { "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief","Candy Rebel" }
						elseif (Configs['Select Materails'] == "Demonic Wisp") then
							return { "Demonic Soul" };
						elseif (Configs['Select Materails'] == "Gunpowder") then
							return { "Pistol Billionaire" }
						end
					end
					return "N/A"
				end

				Module[2].monster = function(Mon, callback)
					local closestEnemy = nil
					local shortestDistance = math.huge
					for _, v in pairs(Enemies:GetChildren()) do
						if ((type(Mon) == "string" and v.Name == Mon) or (type(Mon) == "table" and table.find(Mon, v.Name)) or (Mon == nil)) and Module[2].alive(v) then
							local distance = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
							if distance < shortestDistance then
								shortestDistance = distance
								closestEnemy = v
							end
						end
					end
					for _, v in pairs(_game['ReplicatedStorage']:GetChildren()) do
						if ((type(Mon) == "string" and v.Name == Mon) or (type(Mon) == "table" and table.find(Mon, v.Name)) or (Mon == nil)) and Module[2].alive(v) then
							local distance = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
							if distance < shortestDistance then
								shortestDistance = distance
								closestEnemy = v
							end
						end
					end
					if closestEnemy and callback then
						callback(closestEnemy)
					end
					return closestEnemy
				end

				isValidEnemy = function(enemy, filter)
					if filter == nil then
						return true
					elseif type(filter) == "table" then
						return table.find(filter, enemy.Name) ~= nil
					elseif type(filter) == "string" then
						return enemy.Name == filter
					end
					return false
				end

				Module[2].GetClosemonster = function(maxDistance, filter)
					local closestEnemy = nil
					local shortestDistance = math.huge
					for _, enemy in pairs(Enemies:GetChildren()) do
						if Module[2].alive(enemy) and isValidEnemy(enemy, filter) and enemy:FindFirstChild("HumanoidRootPart") then
							local dist = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
							if (not maxDistance or dist < maxDistance) and dist < shortestDistance then
								closestEnemy = enemy
								shortestDistance = dist
							end
						end
					end
					return closestEnemy
				end

				Module[2].ClosetPlayer = function(maxDistance)
					local closestEnemy = nil
					local closestDistance = math.huge
					for _, v in pairs(workspace.Characters:GetChildren()) do
						if v:IsA("Model") and Module[2].alive(v) and v.Name ~= LocalPlayer.Name then
							local dist = (HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
							if (not maxDistance or dist < maxDistance) and dist < closestDistance then
								closestDistance = dist
								closestEnemy = v
							end
						end
					end
					return closestEnemy
				end

				local MobBlacklist = {}
				local function DetectPartSpawnMob(name)
					local name1
					if string.find(name,"Lv.") then 
						name1 = name:gsub(" %pLv. %d+%p", "")
					end
					for i, v in pairs(EnemySpawns:GetChildren()) do
						local stringgsub
						if string.find(v.Name, "Lv.") then
							stringgsub = v.Name:gsub(" %pLv. %d+%p", "")
						end
						if v:IsA("Part") and ((stringgsub and stringgsub == name) or name == v.Name or (name1 and v.Name == name1)) then
							return v
						end
					end
					for i, v in pairs(getnilinstances()) do
						local stringgsub
						if string.find(v.Name, "Lv.") then
							stringgsub = v.Name:gsub(" %pLv. %d+%p", "")
						end
						if v:IsA("Part") and ((stringgsub and stringgsub == name) or name == v.Name or (name1 and v.Name == name1)) then
							return v
						end
					end
				end

				local function GetPartAllMob(name)
					local results = {}
					local name1
					if string.find(name, "Lv.") then 
						name1 = name:gsub(" %pLv. %d+%p", "")
					end
					for _, v in pairs(EnemySpawns:GetChildren()) do
						local stringgsub
						if string.find(v.Name, "Lv.") then
							stringgsub = v.Name:gsub(" %pLv. %d+%p", "")
						end
						if v:IsA("Part") and ((stringgsub and stringgsub == name) or name == v.Name or (name1 and v.Name == name1)) then
							table.insert(results, v)
						end
					end
					for _, v in pairs(getnilinstances()) do
						local stringgsub
						if string.find(v.Name, "Lv.") then
							stringgsub = v.Name:gsub(" %pLv. %d+%p", "")
						end
						if v:IsA("Part") and ((stringgsub and stringgsub == name) or name == v.Name or (name1 and v.Name == name1)) then
							table.insert(results, v)
						end
					end
					return results
				end

				Module[2].waitmonster = function(Path, u)
					if typeof(Path) == "table" then
						if #MobBlacklist >= 4 then
							MobBlacklist = {}
							return
						end
						local GetPart
						for i,v in next,Path do
							if not Module[2].monster(Path) then
								if not table.find(MobBlacklist,v) then
									GetPart = DetectPartSpawnMob(v)
									repeat
										Module[2].tp(GetPart.CFrame * CFrame.new(0,40,0))
										task.wait(1)
									until (GetPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 50 or (u and u())
								end
							end
						end
					else
						for i, v in next, GetPartAllMob(Path) do
							if not Module[2].monster(Path) then
								repeat
									Module[2].tp(v.CFrame * CFrame.new(0, 40, 0))
									task.wait(1)
								until (v.Position -LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 50 or (u and u())
							end
						end
					end
				end

				Module[2].freeze = function(obj)
					local root = obj:FindFirstChild("HumanoidRootPart")
					if not obj:FindFirstChild('CharacterReady') then return end
					if not root then return end
					if not root:FindFirstChild("FreezeAnchor") then
						local attachment = Instance.new("Attachment")
						local alignPos = Instance.new("AlignPosition")
						attachment.Name = "FreezeAnchor"
						attachment.Parent = root
						alignPos.Name = "FreezeAlign"
						alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
						alignPos.ForceLimitMode = Enum.ForceLimitMode.Magnitude
						alignPos.ForceRelativeTo = Enum.ActuatorRelativeTo.World
						alignPos.Attachment0 = attachment
						alignPos.Position = root.Position
						alignPos.Responsiveness = 200
						alignPos.MaxForce = math.huge
						alignPos.MaxVelocity = math.huge
						alignPos.Parent = attachment
					end
				end

				Module[1].connect(0, function()
					pcall(function()
						if Module[2].tablecheck(Configs, Indexing) then
							for _, v in pairs(Enemies:GetChildren()) do
								if v:IsA("Model") and Module[2].alive(v) then
									Module[2].freeze(v)
								end
							end
							for _, v in pairs(_game['ReplicatedStorage']:GetChildren()) do
								if v:IsA("Model") and Module[2].alive(v) then
									Module[2].freeze(v)
								end
							end
						end
					end)
				end)

				Module[1].def('Bring', 220)
				local MobPositionMap = {}
				Module[2].bring = function(targetMob)
					if not Module[2].alive(targetMob) then return end
					local humanoid = targetMob:FindFirstChildOfClass("Humanoid")
					local rootPart = targetMob:FindFirstChild("HumanoidRootPart")
					if not humanoid or not rootPart then return end
					Module[2].freeze(targetMob)
					sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
					if not MobPositionMap[targetMob] then
						MobPositionMap[targetMob] = rootPart.Position
						humanoid.Died:Connect(function()
							MobPositionMap[targetMob] = nil
						end)
					end
					local pullPosition = MobPositionMap[targetMob]
					for _, mob in pairs(Enemies:GetChildren()) do
						if mob.Name == targetMob.Name
							and Module[2].alive(mob)
							and not mob:GetAttribute("IsBoss")
							and (HumanoidRootPart.Position - mob:GetPivot().Position).Magnitude <= Configs['Bring'] then
							Module[2].freeze(mob)
							local mobRoot = mob:FindFirstChild("HumanoidRootPart")
							local anchor = mobRoot and mobRoot:FindFirstChild("FreezeAnchor")
							local align = anchor and anchor:FindFirstChild("FreezeAlign")
							if align then
								align.Position = pullPosition
								local hum = mob:FindFirstChildOfClass("Humanoid")
								if hum then
									hum.JumpPower = 0
									hum.WalkSpeed = 0
									if hum:FindFirstChild("Animator") then
										hum.Animator:Destroy()
									end
								end
							end
						end
					end
				end

				Module[2].kill = function(info)
					if not Character or not Humanoid or Humanoid.Health <= 0 then
						repeat task.wait() until Character and Humanoid and Humanoid.Health > 0
					end
					local Mon = info.Monster
					local Wait = info.WaitMonster or true
					local Tool = info.Tool or true
					local Callback = info.Callback or function() end
					local Bring = info.Bring or true
					local Stop = info.Stop or function() return false end
					if Module[2].monster(Mon) then
						Module[2].monster(Mon, function(v)
							repeat
								_game.RunService.Heartbeat:Wait()
								if not Character:FindFirstChild("HasBuso") then
									pcall(Module[2].comf, "Buso")
								end
								Module[2].tp(CFrame.new(v.HumanoidRootPart.Position + Vector3.new(0, 40, 0)))
								if Bring then
									Module[2].bring(v)
								end
								task.spawn(function()
									if Tool then
										pcall(function()
											for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
												if tool:IsA("Tool") and tool.ToolTip == Configs['Weapon'] then
													Humanoid:EquipTool(tool)
												end
											end
										end)
									end
								end)
							until Stop() or not Module[2].alive(v)
						end)
					elseif Wait then
						Module[2].waitmonster(Mon, Stop)
					end
				end

				Module[2].quest = function()
					local Level = LocalPlayer.Data.Level.Value
					local Smoothing = Character:FindFirstChild("Smoothing")
					if Module[2].world == 1 then
						if Level >= 1 and Level <= 9 then
							if tostring(game.Players.LocalPlayer.Team) == "Marines" then
								return {
									[1] = "Trainee",
									[2] = 1,
									[3] = "MarineQuest",
									[4] = CFrame.new(-2711.635498046875, 24.834863662719727, 2104.212890625),
								}
							elseif tostring(game.Players.LocalPlayer.Team) == "Pirates" then
								return {
									[1] = "Bandit",
									[2] = 1,
									[3] = "BanditQuest1",
									[4] = CFrame.new(1059.37195, 15.4495068, 1550.4231),
								}
							end
						elseif Level >= 10 and Level <= 14 then
							return {
								[1] = "Monkey",
								[2] = 1,
								[3] = "JungleQuest",
								[4] = CFrame.new(-1598.08911, 35.5501175, 153.377838),
							}
						elseif Level >= 15 and Level <= 29 then
							return {
								[1] = "Gorilla",
								[2] = 2,
								[3] = "JungleQuest",
								[4] = CFrame.new(-1598.08911, 35.5501175, 153.377838),
							}
						elseif Level >= 30 and Level <= 39 then
							return {
								[1] = "Pirate",
								[2] = 1,
								[3] = "BuggyQuest1",
								[4] = CFrame.new(-1141.07483, 4.10001802, 3831.5498),
							}
						elseif Level >= 40 and Level <= 59 then
							return {
								[1] = "Brute",
								[2] = 2,
								[3] = "BuggyQuest1",
								[4] = CFrame.new(-1141.07483, 4.10001802, 3831.5498),
							}
						elseif Level >= 60 and Level <= 74 then
							return {
								[1] = "Desert Bandit",
								[2] = 1,
								[3] = "DesertQuest",
								[4] = CFrame.new(894.488647, 5.14000702, 4392.43359),
							}
						elseif Level >= 75 and Level <= 89 then
							return {
								[1] = "Desert Officer",
								[2] = 2,
								[3] = "DesertQuest",
								[4] = CFrame.new(894.488647, 5.14000702, 4392.43359),
							}
						elseif Level >= 90 and Level <= 99 then
							return {
								[1] = "Snow Bandit",
								[2] = 1,
								[3] = "SnowQuest",
								[4] = CFrame.new(1389.74451, 88.1519318, -1298.90796),
							}
						elseif Level >= 100 and Level <= 119 then
							return {
								[1] = "Snowman",
								[2] = 2,
								[3] = "SnowQuest",
								[4] = CFrame.new(1389.74451, 88.1519318, -1298.90796),
							}
						elseif Level >= 120 and Level <= 149 then
							return {
								[1] = "Chief Petty Officer",
								[2] = 1,
								[3] = "MarineQuest2",
								[4] = CFrame.new(-5039.58643, 27.3500385, 4324.68018),
							}
						elseif Level >= 150 and Level <= 174 then
							return {
								[1] = "Sky Bandit",
								[2] = 1,
								[3] = "SkyQuest",
								[4] = CFrame.new(-4839.53027, 716.368591, -2619.44165),
							}
						elseif Level >= 175 and Level <= 189 then
							return {
								[1] = "Dark Master",
								[2] = 2,
								[3] = "SkyQuest",
								[4] = CFrame.new(-4839.53027, 716.368591, -2619.44165),
							}
						elseif Level >= 190 and Level <= 209 then
							return {
								[1] = "Prisoner",
								[2] = 1,
								[3] = "PrisonerQuest",
								[4] = CFrame.new(5308.93115, 1.65517521, 475.120514),
							}
						elseif Level >= 210 and Level <= 249 then
							return {
								[1] = "Dangerous Prisoner",
								[2] = 2,
								[3] = "PrisonerQuest",
								[4] = CFrame.new(5308.93115, 1.65517521, 475.120514),
							}
						elseif Level >= 250 and Level <= 274 then
							return {
								[1] = "Toga Warrior",
								[2] = 1,
								[3] = "ColosseumQuest",
								[4] = CFrame.new(-1580.04663, 6.35000277, -2986.47534),
							}
						elseif Level >= 275 and Level <= 299 then
							return {
								[1] = "Gladiator",
								[2] = 2,
								[3] = "ColosseumQuest",
								[4] = CFrame.new(-1580.04663, 6.35000277, -2986.47534),
							}
						elseif Level >= 300 and Level <= 324 then
							return {
								[1] = "Military Soldier",
								[2] = 1,
								[3] = "MagmaQuest",
								[4] = CFrame.new(-5313.37012, 10.9500084, 8515.29395),
							}
						elseif Level >= 325 and Level <= 374 then
							return {
								[1] = "Military Spy",
								[2] = 2,
								[3] = "MagmaQuest",
								[4] = CFrame.new(-5313.37012, 10.9500084, 8515.29395),
							}
						elseif Level >= 375 and Level <= 399 then
							if (Vector3.new(61122.65234375, 18.497442245483, 1569.3997802734) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
							end
							return {
								[1] = "Fishman Warrior",
								[2] = 1,
								[3] = "FishmanQuest",
								[4] = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),
							}
						elseif Level >= 400 and Level <= 449 then
							if (Vector3.new(61122.65234375, 18.497442245483, 1569.3997802734) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
							end
							return {
								[1] = "Fishman Commando",
								[2] = 2,
								[3] = "FishmanQuest",
								[4] = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),
							}
						elseif Level >= 450 and Level <= 474 then
							if (Vector3.new(-7859.09814, 5544.19043, -381.476196) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
							end
							return {
								[1] = "God's Guard",
								[2] = 1,
								[3] = "SkyExp1Quest",
								[4] = CFrame.new(-4725, 845, -1952),
							}
						elseif Level >= 475 and Level <= 524 then
							if (Vector3.new(-7863, 5545, -378) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
							end
							return {
								[1] = "Shanda",
								[2] = 2,
								[3] = "SkyExp1Quest",
								[4] = CFrame.new(-7859.09814, 5544.19043, -381.476196),
							}
						elseif Level >= 525 and Level <= 549 then
							if (Vector3.new(-7906.81592, 5634.6626, -1411.99194) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
							end
							return {
								[1] = "Royal Squad",
								[2] = 1,
								[3] = "SkyExp2Quest",
								[4] = CFrame.new(-7906.81592, 5634.6626, -1411.99194),
							}
						elseif Level >= 550 and Level <= 624 then
							if (Vector3.new(-7906.81592, 5634.6626, -1411.99194) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
							end
							return {
								[1] = "Royal Soldier",
								[2] = 2,
								[3] = "SkyExp2Quest",
								[4] = CFrame.new(-7906.81592, 5634.6626, -1411.99194),
							}
						elseif Level >= 625 and Level <= 649 then
							return {
								[1] = "Galley Pirate",
								[2] = 1,
								[3] = "FountainQuest",
								[4] = CFrame.new(5259.81982, 37.3500175, 4050.0293),
							}
						elseif Level >= 650 then
							return {
								[1] = "Galley Captain",
								[2] = 2,
								[3] = "FountainQuest",
								[4] = CFrame.new(5259.81982, 37.3500175, 4050.0293),
							}
						end
					elseif Module[2].world == 2 then
						if Level >= 700 and Level <= 724 then
							return {
								[1] = "Raider",
								[2] = 1,
								[3] = "Area1Quest",
								[4] = CFrame.new(-429.543518, 71.7699966, 1836.18188)
							}
						elseif Level >= 725 and Level <= 774 then
							return {
								[1] = "Mercenary",
								[2] = 2,
								[3] = "Area1Quest",
								[4] = CFrame.new(-429.543518, 71.7699966, 1836.18188)
							}
						elseif Level >= 775 and Level <= 799 then
							return {
								[1] = "Swan Pirate",
								[2] = 1,
								[3] = "Area2Quest",
								[4] = CFrame.new(638.43811, 71.769989, 918.282898)
							}
						elseif Level >= 800 and Level <= 874 then
							return {
								[1] = "Factory Staff",
								[2] = 2,
								[3] = "Area2Quest",
								[4] = CFrame.new(632.698608, 73.1055908, 918.666321)
							}
						elseif Level >= 875 and Level <= 899 then
							return {
								[1] = "Marine Lieutenant",
								[2] = 1,
								[3] = "MarineQuest3",
								[4] = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
							}
						elseif Level >= 900 and Level <= 949 then
							return {
								[1] = "Marine Captain",
								[2] = 2,
								[3] = "MarineQuest3",
								[4] = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
							}
						elseif Level >= 950 and Level <= 974 then
							return {
								[1] = "Zombie",
								[2] = 1,
								[3] = "ZombieQuest",
								[4] = CFrame.new(-5497.06152, 47.5923004, -795.237061)
							}
						elseif Level >= 975 and Level <= 999 then
							return {
								[1] = "Vampire",
								[2] = 2,
								[3] = "ZombieQuest",
								[4] = CFrame.new(-5497.06152, 47.5923004, -795.237061)
							}
						elseif Level >= 1000 and Level <= 1049 then
							return {
								[1] = "Snow Trooper",
								[2] = 1,
								[3] = "SnowMountainQuest",
								[4] = CFrame.new(609.858826, 400.119904, -5372.25928)
							}
						elseif Level >= 1050 and Level <= 1099 then
							return {
								[1] = "Winter Warrior",
								[2] = 2,
								[3] = "SnowMountainQuest",
								[4] = CFrame.new(609.858826, 400.119904, -5372.25928)
							}
						elseif Level >= 1100 and Level <= 1124 then
							return {
								[1] = "Lab Subordinate",
								[2] = 1,
								[3] = "IceSideQuest",
								[4] = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
							}
						elseif Level >= 1125 and Level <= 1174 then
							return {
								[1] = "Horned Warrior",
								[2] = 2,
								[3] = "IceSideQuest",
								[4] = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
							}
						elseif Level >= 1175 and Level <= 1199 then
							return {
								[1] = "Magma Ninja",
								[2] = 1,
								[3] = "FireSideQuest",
								[4] = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
							}
						elseif Level >= 1200 and Level <= 1249 then
							return {
								[1] = "Lava Pirate",
								[2] = 2,
								[3] = "FireSideQuest",
								[4] = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
							}
						elseif Level >= 1250 and Level <= 1274 then
							if (Vector3.new(1037.80127, 125.092171, 32911.6016) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
							end
							return {
								[1] = "Ship Deckhand",
								[2] = 1,
								[3] = "ShipQuest1",
								[4] = CFrame.new(1037.80127, 125.092171, 32911.6016)
							}
						elseif Level >= 1275 and Level <= 1299 then
							if (Vector3.new(1037.80127, 125.092171, 32911.6016) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
							end
							return {
								[1] = "Ship Engineer",
								[2] = 2,
								[3] = "ShipQuest1",
								[4] = CFrame.new(1037.80127, 125.092171, 32911.6016)
							}
						elseif Level >= 1300 and Level <= 1324 then
							if (Vector3.new(968.80957, 125.092171, 33244.125) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
							end
							return {
								[1] = "Ship Steward",
								[2] = 1,
								[3] = "ShipQuest2",
								[4] = CFrame.new(968.80957, 125.092171, 33244.125)
							}
						elseif Level >= 1325 and Level <= 1349 then
							if (Vector3.new(968.80957, 125.092171, 33244.125) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
							end
							return {
								[1] = "Ship Officer",
								[2] = 2,
								[3] = "ShipQuest2",
								[4] = CFrame.new(968.80957, 125.092171, 33244.125)
							}
						elseif Level >= 1350 and Level <= 1374 then
							if (Vector3.new(5667.6582, 26.7997818, -6486.08984) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.55810546875, 89.03500366210938, -132.83999633789062))
							end
							return {
								[1] = "Arctic Warrior",
								[2] = 1,
								[3] = "FrostQuest",
								[4] = CFrame.new(5667.6582, 26.7997818, -6486.08984)
							}
						elseif Level >= 1375 and Level <= 1424 then
							return {
								[1] = "Snow Lurker",
								[2] = 2,
								[3] = "FrostQuest",
								[4] = CFrame.new(5667.6582, 26.7997818, -6486.08984)
							}
						elseif Level >= 1425 and Level <= 1449 then
							return {
								[1] = "Sea Soldier",
								[2] = 1,
								[3] = "ForgottenQuest",
								[4] = CFrame.new(-3055, 240, -10145)
							}
						elseif Level >= 1450 then
							return {
								[1] = "Water Fighter",
								[2] = 2,
								[3] = "ForgottenQuest",
								[4] = CFrame.new(-3055, 240, -10145)
							}
						end
					elseif Module[2].world == 3 then
						if Level >= 1500 and Level <= 1524 then
							return {
								[1] = "Pirate Millionaire",
								[2] = 1,
								[3] = "PiratePortQuest",
								[4] = CFrame.new(-449.1593017578125, 108.6176528930664, 5948.00146484375)
							}
						elseif Level >= 1525 and Level <= 1574 then
							return {
								[1] = "Pistol Billionaire",
								[2] = 2,
								[3] = "PiratePortQuest",
								[4] = CFrame.new(-449.1593017578125, 108.6176528930664, 5948.00146484375)
							}
						elseif Level >= 1575 and Level <= 1599 then
							return {
								[1] = "Dragon Crew Warrior",
								[2] = 1,
								[3] = "DragonCrewQuest",
								[4] = CFrame.new(6737.77685546875, 127.42920684814453, -713.2312622070312)
							}
						elseif Level >= 1600 and Level <= 1624 then 
							return {
								[1] = "Dragon Crew Archer",
								[2] = 2,
								[3] = "DragonCrewQuest",
								[4] = CFrame.new(6737.77685546875, 127.42920684814453, -713.2312622070312)
							}
						elseif Level >= 1625 and Level <= 1649 then
							return {
								[1] = "Hydra Enforcer",
								[2] = 1,
								[3] = "VenomCrewQuest",
								[4] = CFrame.new(5212.94140625, 1004.1171875, 755.6657104492188)
							}
						elseif Level >= 1650 and Level <= 1699 then 
							return {
								[1] = "Venomous Assailant",
								[2] = 2,
								[3] = "VenomCrewQuest",
								[4] = CFrame.new(5212.94140625, 1004.1171875, 755.6657104492188)
							}
						elseif Level >= 1700 and Level <= 1724 then
							return {
								[1] = "Marine Commodore",
								[2] = 1,
								[3] = "MarineTreeIsland",
								[4] = CFrame.new(2484.0673828125, 74.28215026855469, -6786.64453125)
							}
						elseif Level >= 1725 and Level <= 1774 then
							return {
								[1] = "Marine Rear Admiral",
								[2] = 2,
								[3] = "MarineTreeIsland",
								[4] = CFrame.new(2484.0673828125, 74.28215026855469, -6786.64453125)
							}
						elseif Level >= 1775 and Level <= 1799 then
							return {
								[1] = "Fishman Raider",
								[2] = 1,
								[3] = "DeepForestIsland3",
								[4] = CFrame.new(-10581.6563, 330.872955, -8761.18652)
							}
						elseif Level >= 1800 and Level <= 1824 then
							return {
								[1] = "Fishman Captain",
								[2] = 2,
								[3] = "DeepForestIsland3",
								[4] = CFrame.new(-10581.6563, 330.872955, -8761.18652)
							}
						elseif Level >= 1825 and Level <= 1849 then
							return {
								[1] = "Forest Pirate",
								[2] = 1,
								[3] = "DeepForestIsland",
								[4] = CFrame.new(-13234.04, 331.488495, -7625.40137)
							}
						elseif Level >= 1850 and Level <= 1899 then
							return {
								[1] = "Mythological Pirate",
								[2] = 2,
								[3] = "DeepForestIsland",
								[4] = CFrame.new(-13234.04, 331.488495, -7625.40137)
							}
						elseif Level >= 1900 and Level <= 1924 then
							return {
								[1] = "Jungle Pirate",
								[2] = 1,
								[3] = "DeepForestIsland2",
								[4] = CFrame.new(-12680.3818, 389.971039, -9902.01953)
							}
						elseif Level >= 1925 and Level <= 1974 then
							return {
								[1] = "Musketeer Pirate",
								[2] = 2,
								[3] = "DeepForestIsland2",
								[4] = CFrame.new(-12680.3818, 389.971039, -9902.01953)
							}
						elseif Level >= 1975 and Level <= 1999 then
							return {
								[1] = "Reborn Skeleton",
								[2] = 1,
								[3] = "HauntedQuest1",
								[4] = CFrame.new(-9479.2168, 141.215088, 5566.09277)
							}
						elseif Level >= 2000 and Level <= 2024 then
							return {
								[1] = "Living Zombie",
								[2] = 2,
								[3] = "HauntedQuest1",
								[4] = CFrame.new(-9479.2168, 141.215088, 5566.09277)
							}
						elseif Level >= 2025 and Level <= 2049 then
							return {
								[1] = "Demonic Soul",
								[2] = 1,
								[3] = "HauntedQuest2",
								[4] = CFrame.new(-9516.99316, 172.017181, 6078.46533)
							}
						elseif Level >= 2050 and Level <= 2074 then
							return {
								[1] = "Posessed Mummy",
								[2] = 2,
								[3] = "HauntedQuest2",
								[4] = CFrame.new(-9516.99316, 172.017181, 6078.46533)
							}
						elseif Level >= 2075 and Level <= 2099 then
							return {
								[1] = "Peanut Scout",
								[2] = 1,
								[3] = "NutsIslandQuest",
								[4] = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875)
							}
						elseif Level >= 2100 and Level <= 2124 then
							return {
								[1] = "Peanut President",
								[2] = 2,
								[3] = "NutsIslandQuest",
								[4] = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875)
							}
						elseif Level >= 2125 and Level <= 2149 then
							return {
								[1] = "Ice Cream Chef",
								[2] = 1,
								[3] = "IceCreamIslandQuest",
								[4] = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438)
							}
						elseif Level >= 2150 and Level <= 2199 then
							return {
								[1] = "Ice Cream Commander",
								[2] = 2,
								[3] = "IceCreamIslandQuest",
								[4] = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438)
							}
						elseif Level >= 2200 and Level <= 2224 then
							return {
								[1] = "Cookie Crafter",
								[2] = 1,
								[3] = "CakeQuest1",
								[4] = CFrame.new(-2021.32007, 37.7982254, -12028.7295)
							}
						elseif Level >= 2225 and Level <= 2249 then
							return {
								[1] = "Cake Guard",
								[2] = 2,
								[3] = "CakeQuest1",
								[4] = CFrame.new(-2021.32007, 37.7982254, -12028.7295)
							}
						elseif Level >= 2250 and Level <= 2274 then
							return {
								[1] = "Baking Staff",
								[2] = 1,
								[3] = "CakeQuest2",
								[4] = CFrame.new(-1927.91602, 37.7981339, -12842.5391)
							}
						elseif Level >= 2275 and Level <= 2299 then
							return {
								[1] = "Head Baker",
								[2] = 2,
								[3] = "CakeQuest2",
								[4] = CFrame.new(-1927.91602, 37.7981339, -12842.5391)
							}
						elseif Level >= 2300 and Level <= 2324 then
							return {
								[1] = "Cocoa Warrior",
								[2] = 1,
								[3] = "ChocQuest1",
								[4] = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
							}
						elseif Level >= 2325 and Level <= 2349 then
							return {
								[1] = "Chocolate Bar Battler",
								[2] = 2,
								[3] = "ChocQuest1",
								[4] = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
							}
						elseif Level >= 2350 and Level <= 2374 then
							return {
								[1] = "Sweet Thief",
								[2] = 1,
								[3] = "ChocQuest2",
								[4] = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
							}
						elseif Level >= 2375 and Level <= 2399 then
							return {
								[1] = "Candy Rebel",
								[2] = 2,
								[3] = "ChocQuest2",
								[4] = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
							}
						elseif Level >= 2400 and Level <= 2424 then
							return {
								[1] = "Candy Pirate",
								[2] = 1,
								[3] = "CandyQuest1",
								[4] = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
							}
						elseif Level >= 2425 and Level <= 2449 then
							return {
								[1] = "Snow Demon",
								[2] = 2,
								[3] = "CandyQuest1",
								[4] = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
							}
						elseif Level >= 2450 and Level <= 2474 then
							return {
								[1] = "Isle Outlaw",
								[2] = 1,
								[3] = "TikiQuest1",
								[4] = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
							}
						elseif Level >= 2475 and Level <= 2499 then
							return {
								[1] = "Island Boy",
								[2] = 2,
								[3] = "TikiQuest1",
								[4] = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
							}
						elseif Level >= 2500 and Level <= 2524 then
							return {
								[1] = "Sun-kissed Warrior",
								[2] = 1,
								[3] = "TikiQuest1",
								[4] = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
							}
						elseif Level >= 2500 and Level <= 2549 then
							return {
								[1] = "Isle Champion",
								[2] = 2,
								[3] = "TikiQuest2",
								[4] = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
							}
						elseif Level >= 2550 and Level <= 2574 then
							return {
								[1] = "Serpent Hunter",
								[2] = 1,
								[3] = "TikiQuest3",
								[4] = CFrame.new(-16666.5703125, 105.2913818359375, 1576.6925048828125)
							}
						elseif Level >= 2575 then
							return {
								[1] = "Skull Slayer",
								[2] = 2,
								[3] = "TikiQuest3",
								[4] = CFrame.new(-16666.5703125, 105.2913818359375, 1576.6925048828125)
							}
						end
					end
				end

				Module[2].Chest = function()
					local Chests = _game['CollectionService']:GetTagged("_ChestTagged")
					local Distance, Nearest = math.huge, nil

					for i = 1, #Chests do
						local Chest = Chests[i]
						local Magnitude = (Chest:GetPivot().Position - HumanoidRootPart.Position).Magnitude
						if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
							Distance, Nearest = Magnitude, Chest
						end
					end

					return Nearest
				end

				Module[2].HaveItem = function(u)
					if Character then
						for i ,v in pairs(Module[2].comf("getInventoryWeapons")) do
							if v.Name == u then
								return v
							end
						end
						for i ,v in pairs(Backpack:GetChildren()) do
							if v:IsA("Tool") then
								if v.Name == u then
									return v
								end
							end
						end
						for i ,v in pairs(Character:GetChildren()) do
							if v:IsA("Tool") then
								if v.Name == u then
									return v
								end
							end
						end
					end
				end

				Module[2].tree_tyrant = function()
					local model = workspace.Map.TikiOutpost.IslandModel
					local Tree = model:FindFirstChild("EagleBossArena", true)
					local closestTree
					local shortestDistance = math.huge
					for _, v in pairs(Tree:GetChildren()) do
						if v.Name == "Tree" and v:IsA("Model") and v.PrimaryPart then
							local distance = (v.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude
							if distance < shortestDistance then
								shortestDistance = distance
								closestTree = v
							end
						end
					end
					return closestTree
				end

				Module[2].IsSkillnotCooldown = function(meta)
					local Skill = {}
					for _, v in pairs(PlayerGui.Main.Skills:GetChildren()) do
						if v:IsA("Frame") and v.Name ~= "Container" and v.Name ~= "Portal-Portal" and v.Name ~= "Buddha-Buddha" then
							for _, skill in pairs(v:GetChildren()) do
								if skill:IsA("Frame") and table.find(meta, skill.Name) then
									local cooldown = skill:FindFirstChild("Cooldown")
									local isnotLock = skill:FindFirstChild("Title")
									if cooldown and cooldown:IsA("Frame") and cooldown.Size and cooldown.Size.X.Scale == 0 and isnotLock and isnotLock.TextColor3 == Color3.fromRGB(255, 255, 255) then
										if not table.find(Skill, skill.Name) then
											table.insert(Skill, skill.Name)
										end
									end
								end
							end
						end
					end
					return Skill
				end

				Module[2].Input = function(key)
					if typeof(key) == 'string' then
						_game.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
						task.wait()
						_game.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
					elseif typeof(key) == 'table' then
						for _, v in pairs(key) do
							_game.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[v], false, game)
							task.wait()
							_game.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[v], false, game)
						end
					end
				end

				Module[2].GetRaidIsland = function()
					for i = 5, 1, -1 do
						local Name = "Island " .. i
						for _, Island in ipairs(Locations:GetChildren()) do
							if Island.Name == Name and LocalPlayer:DistanceFromCharacter(Island.Position) < 3500 then
								return Island
							end
						end
					end
				end

				Module[2].CheckFruit = function()
					for _ ,v in pairs(LocalPlayer.Backpack:GetChildren()) do
						if string.find(v.Name,"Fruit")  then
							return true
						end
					end
					for _ ,v in pairs(Character:GetChildren()) do
						if string.find(v.Name,"Fruit")  then
							return true
						end
					end
					return false
				end

				Module[2].SetupStore = function(a)
					local whitelistedfruit = {}
					local m1 = {}
					for i,v in next, Module[2].comf("GetFruits") do
						if (a and v.Price >= 999999) or (a == nil and v.Price <= 999999) then
							table.insert(whitelistedfruit,string.split(v.Name,"-")[1].." Fruit")
							m1[v.Name] = v.Price
						end
					end
					return m1
				end

				Module[2].GetFruit = function(a)
					local max, name, m1 = math.huge, nil, Module[2].SetupStore(a)
					for _ ,v in next,Module[2].comf("getInventory") do
						if v.Type == "Blox Fruit" then
							for i2, v2 in pairs(m1) do
								if v.Name == i2 then
									if tonumber(v2) < tonumber(max) then
										max = v2
										name = i2
									end
								end
							end
						end
					end
					return name
				end

				Module[2].Myboat = function(v)
					local boat = nil
					local dis = 3500
					for _, v in pairs(workspace.Boats:GetChildren()) do
						if v:GetAttribute("IsBoat") and tostring(v) == tostring(LocalPlayer.Name) then
							local owner = v:FindFirstChild("Owner")
							if owner and owner:IsA("ObjectValue") and tostring(owner.Value) == LocalPlayer.Name then
								local distance = (v:GetPivot().Position - HumanoidRootPart.Position).Magnitude
								if distance <= dis then
									boat = v
									dis = distance
								end
							end
						end
					end
					return boat
				end

				Module[2].FindIsland = function(Island)
					local Ship = Module[2].Myboat(Configs['Select Ship'])
					local Zone = CFrame.new(-9999999, Configs['Distance Y'], 9999999)
					local Island = workspace.Map:FindFirstChild(Island)
					if Island then
						pcall(StopShip)
						Humanoid.Sit = false
						task.wait(1)
						Module[2].tp(Island:GetPivot() + Vector3.new(0, 20, 0))
					else
						if Ship then
							if not Humanoid.Sit then
								Module[2].stopship()
								if (Ship.VehicleSeat.Position - HumanoidRootPart.Position).Magnitude < 50 then
									Module[2].tp(Ship.VehicleSeat.CFrame)
								else
									Module[2].tp(Ship:GetPivot())
								end
							else
								Module[2].TweenShip(Ship, Zone)
							end
						else
							if (BoatShopCFrame.Position - HumanoidRootPart.Position).Magnitude > 15 then
								Module[2].tp(BoatShopCFrame)
							else
								Module[2].comf("BuyBoat", Configs['Select Ship'])
								task.wait(1)
							end
						end
					end
				end

				Module[2].CheckZone = function()
					if Configs['Select Zone'] == 'Infinite' then
						return CFrame.new(-9999999, Configs['Distance Y'], 9999999)
					elseif Configs['Select Zone'] == 'Low - 1' then
						return CFrame.new(-21227, Configs['Distance Y'], 4047)
					elseif Configs['Select Zone'] == 'Meduim - 2' then
						return CFrame.new(-24237, Configs['Distance Y'], 6381)
					elseif Configs['Select Zone'] == 'High - 3' then
						return CFrame.new(-27105, Configs['Distance Y'], 8959)
					elseif Configs['Select Zone'] == 'Extreme - 4' then
						return CFrame.new(-29350, Configs['Distance Y'], 11744)
					elseif Configs['Select Zone'] == 'Crazy - 5' then
						return CFrame.new(-32404, Configs['Distance Y'], 16208)
					elseif Configs['Select Zone'] == '??? - 6' then
						return CFrame.new(-35611, Configs['Distance Y'], 20548)
					else
						return CFrame.new(-9999999, Configs['Distance Y'], 9999999)
					end
				end

				Module[2].Color = function(color)
					for _, v in pairs(workspace.Map["Boat Castle"].Summoner.Circle:GetChildren()) do
						if v.Name == 'Part' and tostring(v.BrickColor) == color and tostring(v.Part.BrickColor) == 'Lime green' then
							return true
						end
					end
					return false
				end

				Module[2].count = function(v)
					for _, v in pairs(Module[2].comf("getInventory")) do
						if v.Name == v then
							return v.Count
						end
					end
				end

				Module[2].Alucard = function()
					if Module[2].count("Alucard Fragment") == 0 then
						return "Tushi 1"
					elseif Module[2].count("Alucard Fragment") == 1 then
						return "Yama 1"
					elseif Module[2].count("Alucard Fragment") == 2 then
						return "Yama 2"
					elseif Module[2].count("Alucard Fragment") == 3 then
						return "Yama 3"
					elseif Module[2].count("Alucard Fragment") == 4 then
						return "Tushi 2"
					elseif Module[2].count("Alucard Fragment") == 5 then
						return "Tushi 3"
					elseif Module[2].count("Alucard Fragment") == 6 then
						return "Final"
					end
				end

				Module[2].HazeMonster = function()
					local closestEnemy = nil
					local shortestDistance = math.huge
					for _, v in pairs(Enemies:GetChildren()) do
						if v:FindFirstChild('HazeESP') and Module[2].alive(v) then
							local distance = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
							if distance < shortestDistance then
								shortestDistance = distance
								closestEnemy = v
							end
						end
					end
					for _, v in pairs(_game['ReplicatedStorage']:GetChildren()) do
						if v:IsA("Model") and v:FindFirstChild('HazeESP') and Module[2].alive(v) then
							local distance = (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
							if distance < shortestDistance then
								shortestDistance = distance
								closestEnemy = v
							end
						end
					end
					return closestEnemy
				end

				Module[2].Killboss = function(a, u)
					if Module[2].monster(a) then
						Module[2].kill({Monster = a,WaitMonster = false,Bring = false,Stop = function()
							return not Configs[u]
						end})
					end
				end

				Module[2].mastery = function(items, mas)
					if LocalPlayer.Backpack:FindFirstChild(items) or LocalPlayer.Backpack:FindFirstChild(items).Level.Value >= mas then
						return true
					end
					if LocalPlayer.Character:FindFirstChild(items) or LocalPlayer.Character:FindFirstChild(items).Level.Value >= mas then
						return true
					end
					return false
				end

				Module[2].hop_monster = function(a, config)
					Module[1].connect(1, function()
						if not Configs[config] then return end
						if Configs['Break'] then
							if Character:FindFirstChild("God's Chalice") or Backpack:FindFirstChild("God's Chalice") then return end
							if Character:FindFirstChild("Fist of Darkness") or Backpack:FindFirstChild("Fist of Darkness") then return end
						end
						if not Module[2].monster(a) then
							Module[1].hop()
						end
					end, true)
				end

				Module[2].hop_island = function(a, config)
					Module[1].connect(1, function()
						if not Configs[config] then return end
						if Configs['Break'] then
							if Character:FindFirstChild("God's Chalice") or Backpack:FindFirstChild("God's Chalice") then return end
							if Character:FindFirstChild("Fist of Darkness") or Backpack:FindFirstChild("Fist of Darkness") then return end
						end
						if not workspace.Map:FindFirstChild(a) then
							Module[1].hop()
						end
					end, true)
				end
			end
		elseif PlaceId == 126884695634066 then
			
			local farm = nil
			local Plant_Locations = nil
			local Plants_Physical = nil
			
			Module[2].Net = {
				['Sell'] = ReplicatedStorage.GameEvents.Sell_Inventory,
				['Plant'] = ReplicatedStorage.GameEvents.Plant_RE,
				['Collect'] = ReplicatedStorage.ByteNetReliable,
				['Buy Seed'] = ReplicatedStorage.GameEvents.BuySeedStock,
				['Buy Gear'] = ReplicatedStorage.GameEvents.BuyGearStock,
				['Water'] = ReplicatedStorage.GameEvents.Water_RE
			}

			Module[2].GetFarm = require(ReplicatedStorage.Modules.GetFarm)
			farm = Module[2].GetFarm(LocalPlayer)
			Plant_Locations = farm.Important.Plant_Locations
			Plants_Physical = farm.Important.Plants_Physical

			Module[2].Fruit = function(Class: table)
				local fruits = {}
				for _, v in ipairs(Plants_Physical:GetChildren()) do
					if v:IsA("Model") then
						local include = false
						if Class == nil then
							include = true
						elseif type(Class) == "string" then
							include = v.Name == Class
						elseif type(Class) == "table" then
							include = table.find(Class, v.Name) ~= nil
						end
						if include then
							table.insert(fruits, v)
							local fruitContainer = v:FindFirstChild("Fruits")
							if fruitContainer then
								for _, fruit in ipairs(fruitContainer:GetChildren()) do
									table.insert(fruits, fruit)
								end
							end
						end
					end
				end
				return fruits
			end

			Module[2].FruitSpecial = function(e: table)
				local fruits = {}
				for _, v in ipairs(Plants_Physical:GetChildren()) do
					if v:IsA("Model") then
						local attr = v:GetAttributes()
						local match = false
						local fruitContainer = v:FindFirstChild("Fruits")
						if type(e) == "table" then
							for _, key in ipairs(e) do
								if attr[key] then
									match = true
								end
							end
						else
							match = v:GetAttribute(e) and true or false
						end
						if match then
							table.insert(fruits, v)
						end
						if fruitContainer then
							for _, fruit in ipairs(fruitContainer:GetChildren()) do
								local fruitAttr = fruit:GetAttributes()
								local match2 = false
								if type(e) == "table" then
									for _, key in ipairs(e) do
										if fruitAttr[key] then
											match2 = true
										end
									end
								else
									match2 = fruit:GetAttribute(e) and true or false
								end
								if match2 then
									table.insert(fruits, fruit)
								end
							end
						end
					end
				end
				return fruits
			end

			Module[2].HaveSeed = function()
				for _, v in pairs(Character:GetChildren()) do
					if v:IsA("Tool") and v:GetAttribute("Seed") then
						return v
					end
				end
				return nil
			end

			Module[2].CheckSeed = function()
				local tool = Character:FindFirstChildOfClass("Tool")
				if tool and tool:GetAttribute("Seed") then
					return true
				end
				return false
			end

			Module[2].Max = function()
				return PlayerGui.BackpackGui.Backpack.Inventory.ScrollingFrame.UIGridFrame:FindFirstChild("200") or LocalPlayer.PlayerGui.BackpackGui.Backpack.Inventory:FindFirstChild("200")
			end

			Module[2].GetDataModule = function(a: ModuleScript)
				local shopData = require(a)
				local a = {}
				for itemName in pairs(shopData) do
					table.insert(a, itemName)
				end
				return a
			end

			Module[2].GetOtherFarm = function()
				local otherFarm = {}
				for _, v7 in pairs(workspace.Farm:GetChildren()) do
					if tostring(v7.Important.Data.Owner.Value) ~= LocalPlayer.Name then
						table.insert(otherFarm, v7)
					end
				end
				return otherFarm
			end

			Module[2].GetValueHighPlant = function()
				local otherFarms = Module[2].GetOtherFarm()
				local fruits = {}
				for _, farm in pairs(otherFarms) do
					for _, plant in pairs(farm.Important.Plants_Physical:GetChildren()) do
						if plant:IsA("Model") then
							local fruitContainer = plant:FindFirstChild("Fruits")
							if fruitContainer then
								for _, fruit in ipairs(fruitContainer:GetChildren()) do
									table.insert(fruits, fruit)
								end
							end
						end
					end
				end

				return fruits
			end

			local Calculate = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CalculatePlantValue"))

			Module[2].GetHighestFruit = function()
				local allFruits = Module[2].GetValueHighPlant()
				local highestFruit = nil
				local highestValue = - math.huge
				for _, fruit in pairs(allFruits) do
					local value = Calculate(fruit)
					if type(value) == "number" and value > highestValue then
						highestValue = value
						highestFruit = fruit
					end
				end

				return highestFruit
			end

			Module[2].GetHighestFruitValue = function()
				local fruit = Module[2].GetHighestFruit()
				if fruit then
					return math.floor(Calculate(fruit))
				end
				return 0
			end

			Module[2].CheckFarmEX = function()
				local expansionModel = farm:WaitForChild("CurrentExpansion")
				local size = expansionModel:GetExtentsSize() / 2
				local center = expansionModel:GetPivot().Position
				if math.abs(HumanoidRootPart.Position.X - center.X) <= size.X and math.abs(HumanoidRootPart.Position.Y - center.Y) <= size.Y and math.abs(HumanoidRootPart.Position.Z - center.Z) <= size.Z then
					return true
				end
				return false
			end

			local MutationList = {}
			local Mutation = require(ReplicatedStorage.Modules.MutationHandler)
			local FruitsList = Module[2].GetDataModule(ReplicatedStorage.Data.SeedData)
			local EventShopData = Module[2].GetDataModule(ReplicatedStorage.Data.EventShopData)
			local GearData = Module[2].GetDataModule(ReplicatedStorage.Data.GearData)
			for iz in pairs(Mutation:GetMutations()) do
				table.insert(MutationList, iz)
			end

			Module[2].Data = {
				['Gear'] = GearData,
				['Event Shop'] = EventShopData,
				['Seed'] = FruitsList,
				['Mutation'] = MutationList
			}

		end
	end
end

loadstring(game:HttpGet('https://raw.githubusercontent.com/96soul/Utilities/refs/heads/main/Protected_5342070883438840.lua', true))()

return table.unpack({_env;_game;_library;Module;Configs;Indexing;translate;LocalPlayer;PlayerGui;PlayerScripts;Backpack;Character;HumanoidRootPart;Humanoid;})
