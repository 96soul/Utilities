repeat 
	task.wait()
until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer

if game['CoreGui']:FindFirstChild('lnwza') then
	game['CoreGui']:FindFirstChild('lnwza'):Destroy()
end

local _env: ENVIRONMENT = (getgenv or getrenv or getfenv)()
local _game: Game = setmetatable({}, {__index = function(_, key) return cloneref(game:GetService(key))end})
local _library: Set = loadstring(game:HttpGet("https://raw.githubusercontent.com/96soul/Library/refs/heads/main/Main", true))()

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

LocalPlayer.CharacterAdded:Connect(function(_Character: Model)
	Character = _Character
	Humanoid = _Character:FindFirstChild('Humanoid')
	HumanoidRootPart = _Character:FindFirstChild('HumanoidRootPart')
	PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
	Backpack = LocalPlayer:WaitForChild("Backpack")
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
					v:FindFirstChild('Constant'):FindFirstChild("TextLabel").Text = title .. '\n[ ' .. math.floor(tonumber((HumanoidRootPart.Position - v.Position).Magnitude / 3) + 1) .. ' ]'
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
			local Icon: number = meta.icon or ""
			local Setting: string = meta.setting or ""
			local Function: func = meta.self or ""
			local Callback: func = meta.call or ""

			if Function ~= "" then
				if not Indexing[Setting] then
					table.insert(Indexing, Setting)
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
			local Home = window:Add({Title = translate("Other", "อื่นๆ"),Desc = translate("Miscellaneous", "ฟังชั่นอื่นๆ"),Icon = 81707063924327}) do
				local Performance = Home:Sec({Title = translate("Performance", "ประสิทธิภาพ"), Side = "l"}) do
					Module[1].toggle({sec = Performance,title = translate("Enable White Screen", "เปิดใช้งานจอขาว"),setting = "White Screen",call = function(v)
						if v then
							RunService:Set3dRenderingEnabled(false)
						else
							RunService:Set3dRenderingEnabled(true)
						end
					end})
					Module[1].toggle({sec = Performance,title = translate("Enable Fullbright", "เปิดใช้งานแสงสว่าง"),setting = "Fullbright"})
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

					Module[1].toggle({sec = PlayersSS,title = translate("View Player", "ดูผู้เล่น"),setting = "View Player",call = function(v)
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
					Module[1].toggle({sec = Config,title = translate("Keep Script", "ออโต้รันสคริปต์ [ บางครั้งก็ไม่ติด ]"),setting = "Keep Script"})
					Module[1].list(Config, translate("Lauguage", 'เลือกภาษา'), {'Thailand', 'English [ Default ]'}, false, 'Lauguage')
					Module[1].button(Config, translate("Change Lauguage", "เปลี่ยนภาษา"), function()
						Module[1].rj()
					end)
					Module[1].button(Config, translate("Reset Configs", "ลบการตั้งค่า"), function()
						delfile(Folder)
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
		
	end
end

return table.unpack({_env;_game;_library;Configs;Indexing;translate;LocalPlayer;PlayerGui;PlayerScripts;Character;HumanoidRootPart;Humanoid;})
