repeat 
	task.wait()
until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer

if game['CoreGui']:FindFirstChild('lnwza') then
	game['CoreGui']:FindFirstChild('lnwza'):Destroy()
end

local _ENV = (getgenv or getrenv or getfenv)()
local _MT = setmetatable({}, {__index = function(_, key) return cloneref(game:GetService(key))end})
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/96soul/Library/refs/heads/main/Main", true))()

local VirtualInputManager: VirtualInputManager = _MT["VirtualInputManager"]
local CollectionService: CollectionService = _MT["CollectionService"]
local ReplicatedStorage: ReplicatedStorage = _MT["ReplicatedStorage"]
local Lighting: Lighting = _MT['Lighting']
local HttpService: HttpService = _MT['HttpService']
local TeleportService: TeleportService = _MT["TeleportService"]
local VirtualUser: VirtualUser = _MT['VirtualUser']
local RunService: RunService = _MT["RunService"]
local Players: Players = _MT["Players"]
local LocalPlayer: LocalPlayers = Players['LocalPlayer']
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local Character = LocalPlayer['Character']
local Humanoid = Character:WaitForChild('Humanoid')
local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')

local PlaceId = game['PlaceId']
local JobId = game['JobId']

local Configs = {}
local FunctionTree = {}
local Folder: string = "Fetching'Script/Config/" .. LocalPlayer.UserId .. "/" .. PlaceId .. ".json"

function Dictionary(array: { string }, value: any?): { [string]: any? }
	local Dictionary = {}
	for _, string in ipairs(array) do
		Dictionary[string] = if type(value) == "table" then {} else value
	end
	return Dictionary
end

function translate(en, th)
	if Configs['Lauguage'] == "Thailand" then
		return tostring(th)
	else
		return tostring(en)
	end
end

local Signal = {} do
	local Connection = {} do
		Connection.__index = Connection

		function Connection:Disconnect(): (nil)
			if not self.Connected then
				return nil
			end

			local find = table.find(self.Signal, self)

			if find then
				table.remove(self.Signal, find)
			end

			self.Function = nil
			self.Connected = false
		end

		function Connection:Fire(...): (nil)
			if not self.Function then
				return nil
			end

			task.spawn(self.Function, ...)
		end

		function Connection.new(): Connection
			return setmetatable({
				Connected = true
			}, Connection)
		end

		setmetatable(Connection, {
			__index = function(self, index)
				error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(index)), 2)
			end,
			__newindex = function(tb, key, value)
				error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(key)), 2)
			end
		})
	end

	Signal.__index = Signal

	function Signal:Connect(Function): Connection
		if type(Function) ~= "function" then
			return nil
		end

		local NewConnection = Connection.new()
		NewConnection.Function = Function
		NewConnection.Signal = self

		table.insert(self.Connections, NewConnection)
		return NewConnection
	end

	function Signal:Once(Function): (nil)
		local Connection;
		Connection = self:Connect(function(...)
			Function(...)
			Connection:Disconnect()
		end)
		return Connection
	end

	function Signal:Wait(): any?
		local WaitingCoroutine = coroutine.running()
		local Connection;Connection = self:Connect(function(...)
			Connection:Disconnect()
			task.spawn(WaitingCoroutine, ...)
		end)
		return coroutine.yield()
	end

	function Signal:Fire(...): (nil)
		for _, Connection in ipairs(self.Connections) do
			if Connection.Connected then
				Connection:Fire(...)
			end
		end
	end

	function Signal.new(): Signal
		return setmetatable({
			Connections = {}
		}, Signal)
	end

	setmetatable(Signal, {
		__index = function(self, index)
			error(`Attempt to get Signal::{ tostring(index) } (not a valid member)`, 2)
		end,
		__newindex = function(self, index, value)
			error(`Attempt to set Signal::{ tostring(index) } (not a valid member)`, 2)
		end
	})
end

local Modules = {} do

	local Thread = Dictionary({
		"__function", "__configs", "__library", "__game"
	}, {})

	;(function()
		Thread.__function['@connection'] = (function(interval: number, func: any, protectcall: boolean)
			return task.spawn(function()
				while task.wait(interval) do
					if protectcall then pcall(func) else func() end
				end
			end)
		end)

		Thread.__function['@signals'] = {} do
			local Signals = Thread.__function['@signals']
			Signals.Error = Signal.new()
			Signals.Error:Connect(function(ErrorMessage)
				local Message = Instance.new("Message", workspace)
				_ENV.fetching_error = Message
				Message.Text = (`fetching error : {ErrorMessage}`)
			end)
		end

		Thread.__function['@dist'] = (function(v: any)
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
			end
			return nil
		end)

		Thread.__function['@tp'] = (function(pos: any ,v: boolean)
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
		end)

		Thread.__function['@serverhop'] = (function()
			local ListServers = function(cursor: SharedTable) return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100" .. ((cursor and "&cursor="..cursor) or ""))) end
			local Server, Next
			repeat
				local Servers = ListServers(Next)
				Server = Servers.data[1]
				Next = Servers.nextPageCursor
			until Server;TeleportService:TeleportToPlaceInstance(PlaceId,Server.id,LocalPlayer)
		end)

		Thread.__function['@rejoin'] = (function()
			if #Players:GetPlayers() <= 1 then
				LocalPlayer:Kick("\nRejoining...")
				wait()
				TeleportService:Teleport(PlaceId, LocalPlayer)
			else
				TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
			end
		end)

		Thread.__function['@html'] = (function(text: string, color: Color3)
			if type(text) == "string" and typeof(color) == "Color3" then
				local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
				return string.format('<font color="rgb(%d, %d, %d)">%s</font>', r, g, b, text)
			end
			return text
		end)

		Thread.__function['@place_name'] = (function(a)
			return tostring(_MT['MarketplaceService']:GetProductInfo(a).Name)
		end)

		Thread.__function['@add_esp'] = (function(meta: table)
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
		end)

		Thread.__function['@remove_esp'] = (function(v: any)
			if v:FindFirstChild('Constant') then
				v:FindFirstChild('Constant'):Destroy()
			end
		end)
	end)()

	;(function()
		Thread.__configs['def'] = (function(v: string, a: boolean | string | number | table | any)
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
		end)

		Thread.__configs['save'] = (function(key: string, value: boolean | string | number | table | any)
			if key ~= nil then Configs[key] = value;end
			if not isfolder("Fetching'Script") then makefolder("Fetching'Script");end
			writefile(Folder, HttpService:JSONEncode(Configs))
		end)

		Thread.__configs['load'] = (function()
			local base = "Fetching'Script/Config/" .. LocalPlayer.UserId
			local path = base .. "/" .. PlaceId .. ".json"
			if not isfolder("Fetching'Script") then makefolder("Fetching'Script") end
			if not isfolder("Fetching'Script/Config") then makefolder("Fetching'Script/Config") end
			if not isfolder(base) then makefolder(base) end
			if not isfile(path) then Thread.__configs['save']() end
			return HttpService:JSONDecode(readfile(path))
		end)

		Configs = Thread.__configs['load']()
	end)()

	;(function()
		Thread.__library['@addtab'] = (function(window: table ,title: string, desc: string, icon: number)
			local Options = {
				Title = title,
				Desc = desc,
				Icon = icon
			}
			return window:Add(Options) 
		end)

		Thread.__library['@sec'] = (function(tab: table ,title: string, desc: string)
			local Options = {
				Title = title,
				Side = desc
			}
			return tab:Sec(Options) 
		end)

		Thread.__library['@button'] = (function(sec: table ,title: string, call: func)
			local Options = {
				Title = title,
				Callback = call
			}
			return sec:Button(Options) 
		end)

		Thread.__library['@button_image'] = (function(sec: table ,title: string, Icon, call: func)
			local Options = {
				Title = title,
				Icon = Icon,
				Callback = call
			}
			return sec:Button(Options) 
		end)

		Thread.__library['@toggle'] = (function(Tab: table, Title: string, SettingName: string, breakfun: func, CallBackz: func)
			local Options = {
				Title = Title,
				Value = Configs[SettingName],
				CallBack = (function(value)
					Configs[SettingName] = value
					Thread.__configs['save'](SettingName, Configs[SettingName] or value)
					if CallBackz ~= nil then CallBackz() end
					if breakfun ~= nil and not value then breakfun() end
				end)
			}
			if FunctionTree[SettingName] then
				Thread.__functions['@connection'](0.1, function() FunctionTree[SettingName]() end)
			end
			return Tab:Toggle(Options)
		end)

		Thread.__library['@toggle_image'] = (function(Tab: table, Title: string, Icon, SettingName: string, breakfun: func, CallBackz: func)
			local Options = {
				Title = Title,
				Value = Configs[SettingName],
				Icon = Icon,
				CallBack = (function(value)
					Configs[SettingName] = value
					Thread.__configs['save'](SettingName, Configs[SettingName] or value)
					if CallBackz ~= nil then CallBackz() end
					if breakfun ~= nil and not value then breakfun() end
				end)
			}
			if FunctionTree[SettingName] then
				Thread.__functions['@connection'](0.1, function() FunctionTree[SettingName]() end)
			end
			return Tab:Toggle(Options)
		end)

		Thread.__library['@list'] = (function(sec: table, title: string, list: table, m: boolean, setting: string)
			sec:Dropdown({Title = title,Multi = m,List = list,Value = Configs[setting],Callback = function(v)
				Configs[setting] = v
				Thread.__configs['save'](setting, v)
			end})
		end)
		
		Thread.__library['@setup'] = (function(window: table)
			local Home = window:Add({Title = translate("Other", "อื่นๆ"),Desc = translate("Miscellaneous", "ฟังชั่นอื่นๆ"),Icon = 81707063924327}) do
				local Performance = Home:Sec({Title = translate("Performance", "ประสิทธิภาพ"), Side = "l"}) do
					Thread.__library['@toggle'](Performance, translate("Enable White Screen", "เปิดใช้งานจอขาว"), "White Screen", function(v)
						if v then
							RunService:Set3dRenderingEnabled(false)
						else
							RunService:Set3dRenderingEnabled(true)
						end
					end)
					Thread.__library['@toggle'](Performance, translate("Enable Fullbright", "เปิดใช้งานแสงสว่าง"), 'Fullbright')
					Thread.__library['@button'](Performance,translate("Boost FPS", "แก้แลค"), function()
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
							for i,v in pairs(_MT['Lighting']:GetDescendants()) do
								if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
									v.Enabled = false
								end
							end
						end)
					end)
				end

				local Server = Home:Sec({Title = translate("Server", "เซิร์ฟเวอร์"), Side = "r"}) do
					Thread.__configs['def']('Input JobID', JobId)
					Server:Textbox({Value = Configs["Input JobID"], function(v)
						Configs["Input JobID"] = v
						Thread.__configs['save']("Input JobID", v)
					end})
					Thread.__library['@button'](Server, translate("Join", "เข้าร่วม"), function()
						TeleportService:TeleportToPlaceInstance(PlaceId, Configs['Input JobID'], LocalPlayer)
					end)
					Thread.__library['@button'](Server, translate("Clipboard JobId", "คัดลอกไอดีเซิร์ฟเวอร์"), function()
						setclipboard(JobId)
					end)
					Thread.__library['@button'](Server, translate("Rejoin", "รีเจอย์"), function()
						Thread.__function['@rejoin']()
					end)
					Thread.__library['@button'](Server, translate("Change Server", "เปลี่ยนเซิร์ฟเวอร์"), function()
						pcall(Thread.__function['@serverhop'])
					end)
				end

				local PlayersSS = Home:Sec({Title = translate("Players", "ผู้เล่น"), Side = "l"}) do
					local AllPlayer = {}

					for _, v in pairs(Players:GetPlayers()) do
						if v ~= LocalPlayer and v.Character then
							table.insert(AllPlayer, v.Name)
						end
					end

					Thread.__configs['def']('Select Player', AllPlayer[1])
					local PlayerDropdown = PlayersSS:Dropdown({Title = translate("Select Player", "เลือกผู้เล่น"),Multi = false,List = AllPlayer,Value = Configs['Select Player'],Callback = function(v)
						Configs['Select Player'] = v
						Thread.__configs['save']('Select Player', v)
					end})

					Thread.__library['@button']({Title = translate("Refresh", "รีเฟรช"), Callback = function()
						PlayerDropdown:Clear()
						for _, v in pairs(Players:GetPlayers()) do
							if v ~= LocalPlayer and v.Character then
								PlayerDropdown:AddList(v.Name)
							end
						end
					end})

					Thread.__library['@button']({Title = translate("Teleport", "เทเลพอร์ต"), Callback = function()
						pcall(function()
							local player = Players:FindFirstChild(Configs["Select Player"])
							if player and player.Character then
								Thread.__function['@tp'](player.Character)
							end
						end)
					end})
					Thread.__library['@toggle'](PlayersSS, translate("View Player", "ดูผู้เล่น"), 'View Player', function(v)
						if v then
							local player = Players:FindFirstChild(Configs["Select Player"])
							if player and player.Character then
								workspace.CurrentCamera.CameraSubject = player.Character
							end
						else
							workspace.CurrentCamera.CameraSubject = Humanoid
						end
					end)
				end

				local Power = Home:Sec({Title = translate("Powers", "ความสามารถพิเศษ"), Side = "r"}) do
					local OldSpeed = Humanoid.WalkSpeed
					Thread.__configs['def']('Walkspeed', Humanoid.WalkSpeed)

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
						Thread.__configs['save']('Walkspeed', v)
						Humanoid.WalkSpeed = v
					end})

					Thread.__library['@button'](Power, translate("Change to Old Walkspeed", "คืนค่าความเร็ว"), function()
						Humanoid.WalkSpeed = OldSpeed
					end)

					LocalPlayer.CharacterAdded:Connect(function(char)
						char:WaitForChild("Humanoid").WalkSpeed = Configs['Walkspeed']
					end)
				end

				local Config = Home:Sec({Title = translate("Configs", "การตั้งค่า"), Side = "r"}) do
					Thread.__library['@toggle'](Config, translate("Keep Script", "ออโต้รันสคริปต์ [ บางครั้งก็ไม่ติด ]"), 'Keep Script')
					Thread.__library['@toggle'](Config, translate("ภาษาไทย [เปิดแล้วออกเข้าใหม่]", "English [Disable and rejoin] "), 'Thailand')
					Thread.__library['@button'](Config, translate("Remove Workspace", "ลบการตั้งค่า"), function()
						delfile(Folder)
					end)
				end
			end
			
			_ENV.NormalLightingSettings = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				FogEnd = Lighting.FogEnd,
				GlobalShadows = Lighting.GlobalShadows,
				Ambient = Lighting.Ambient
			}

			Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
				if Lighting.Brightness ~= 1 and Lighting.Brightness ~= _ENV.NormalLightingSettings.Brightness then
					_ENV.NormalLightingSettings.Brightness = Lighting.Brightness
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.Brightness = 1
				end
			end)

			Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
				if Lighting.ClockTime ~= 12 and Lighting.ClockTime ~= _ENV.NormalLightingSettings.ClockTime then
					_ENV.NormalLightingSettings.ClockTime = Lighting.ClockTime
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.ClockTime = 12
				end
			end)

			Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
				if Lighting.FogEnd ~= 786543 and Lighting.FogEnd ~= _ENV.NormalLightingSettings.FogEnd then
					_ENV.NormalLightingSettings.FogEnd = Lighting.FogEnd
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.FogEnd = 786543
				end
			end)

			Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
				if Lighting.GlobalShadows ~= false and Lighting.GlobalShadows ~= _ENV.NormalLightingSettings.GlobalShadows then
					_ENV.NormalLightingSettings.GlobalShadows = Lighting.GlobalShadows
					if not Configs['Fullbright'] then
						repeat
							wait()
						until Configs['Fullbright']
					end
					Lighting.GlobalShadows = false
				end
			end)

			Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
				if Lighting.Ambient ~= Color3.fromRGB(178, 178, 178) and Lighting.Ambient ~= _ENV.NormalLightingSettings.Ambient then
					_ENV.NormalLightingSettings.Ambient = Lighting.Ambient
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
			Thread.__function['@connection'](0, function()
				if Configs['Fullbright'] ~= LatestValue then
					if not Configs['Fullbright'] then
						Lighting.Brightness = _ENV.NormalLightingSettings.Brightness
						Lighting.ClockTime = _ENV.NormalLightingSettings.ClockTime
						Lighting.FogEnd = _ENV.NormalLightingSettings.FogEnd
						Lighting.GlobalShadows = _ENV.NormalLightingSettings.GlobalShadows
						Lighting.Ambient = _ENV.NormalLightingSettings.Ambient
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
		end)
		
		Thread.__library['@init'] = (function()
			if Configs['X'] == 0 and Configs['Y'] == 0 then
				if _MT['UserInputService'].KeyboardEnabled then
					return UDim2.new(0, 750, 0, 800)
				else
					return UDim2.new(0, 500, 0, 350)
				end
			else
				return UDim2.new(0, Configs['X'], 0, Configs['Y'])
			end
		end)
		
		Thread.__configs['def']('X', 0)
		Thread.__configs['def']('Y', 0)
		
		repeat wait() until game:GetService("CoreGui").lnwza.Background

		do
			game:GetService("CoreGui").lnwza.Background:GetPropertyChangedSignal("Size"):Connect(function()
				local size = game:GetService("CoreGui").lnwza.Background.Size
				Thread.__configs['save']('X', size.X.Offset)
				Thread.__configs['save']('X', size.X.Offset)
			end)
		end
	end)()

	Thread.__game['@mains'] = (function()
		if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
			Thread.__game['@mains']['@bloxfruits'] = {} do

			end

			return Thread.__game['@mains']['@bloxfruits']
		elseif PlaceId == 126884695634066 then
			local Module = Thread.__game['@mains']['@grow_a_garden']

			local farm = nil
			local Plant_Locations = nil
			local Plants_Physical = nil

			Module = {} do
				Module.Net = {
					['Sell'] = ReplicatedStorage.GameEvents.Sell_Inventory,
					['Plant'] = ReplicatedStorage.GameEvents.Plant_RE,
					['Collect'] = ReplicatedStorage.ByteNetReliable,
					['Buy Seed'] = ReplicatedStorage.GameEvents.BuySeedStock,
					['Buy Gear'] = ReplicatedStorage.GameEvents.BuyGearStock,
					['Water'] = ReplicatedStorage.GameEvents.Water_RE
				}

				Module.GetFarm = require(ReplicatedStorage.Modules.GetFarm)
				farm = Module.GetFarm(LocalPlayer)
				Plant_Locations = farm.Important.Plant_Locations
				Plants_Physical = farm.Important.Plants_Physical

				Module.Fruit = function(Class: table)
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

				Module.FruitSpecial = function(e: table)
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

				Module.HaveSeed = function()
					for _, v in pairs(Character:GetChildren()) do
						if v:IsA("Tool") and v:GetAttribute("Seed") then
							return v
						end
					end
					return nil
				end

				Module.CheckSeed = function()
					local tool = Character:FindFirstChildOfClass("Tool")
					if tool and tool:GetAttribute("Seed") then
						return true
					end
					return false
				end

				Module.Max = function()
					return PlayerGui.BackpackGui.Backpack.Inventory.ScrollingFrame.UIGridFrame:FindFirstChild("200") or LocalPlayer.PlayerGui.BackpackGui.Backpack.Inventory:FindFirstChild("200")
				end

				Module.GetDataModule = function(a: ModuleScript)
					local shopData = require(a)
					local a = {}
					for itemName in pairs(shopData) do
						table.insert(a, itemName)
					end
					return a
				end

				Module.GetOtherFarm = function()
					local otherFarm = {}
					for _, v7 in pairs(workspace.Farm:GetChildren()) do
						if tostring(v7.Important.Data.Owner.Value) ~= LocalPlayer.Name then
							table.insert(otherFarm, v7)
						end
					end
					return otherFarm
				end

				Module.GetValueHighPlant = function()
					local otherFarms = Module.GetOtherFarm()
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

				Module.GetHighestFruit = function()
					local allFruits = Module.GetValueHighPlant()
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

				Module.GetHighestFruitValue = function()
					local fruit = Module.GetHighestFruit()
					if fruit then
						return math.floor(Calculate(fruit))
					end
					return 0
				end

				Module.CheckFarmEX = function()
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
				local FruitsList = Module.GetDataModule(ReplicatedStorage.Data.SeedData)
				local EventShopData = Module.GetDataModule(ReplicatedStorage.Data.EventShopData)
				local GearData = Module.GetDataModule(ReplicatedStorage.Data.GearData)
				for iz in pairs(Mutation:GetMutations()) do
					table.insert(MutationList, iz)
				end

				Module.Data = {
					['Gear'] = GearData,
					['Event Shop'] = EventShopData,
					['Seed'] = FruitsList,
					['Mutation'] = MutationList
				}
			end

			return Module
		end
	end)
	
	
end

do
	
	LocalPlayer.CharacterAdded:Connect(function(_Character: Instance)
		Character = _Character
		Humanoid = _Character:WaitForChild('Humanoid')
		HumanoidRootPart = _Character:WaitForChild('HumanoidRootPart')
		PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
		Backpack = LocalPlayer:WaitForChild("Backpack")
	end)

	LocalPlayer.Idled:Connect(function()
		VirtualUser:CaptureController();
		VirtualUser:ClickButton2(Vector2.new());
	end)

	local TeleportCheck = false
	LocalPlayer.OnTeleport:Connect(function(State)
		if Configs['Keep Script'] and (not TeleportCheck) and _ENV.queueonteleport then
			TeleportCheck = true
			queueonteleport("loadstring(game:HttpGet('https://github.com/96soul/-/blob/main/load.gg?raw=true', true))()")
		end
	end)
end

return table.unpack({
	Library,
	_ENV,
	_MT,
	Configs,
	Dictionary,
	Modules,
	LocalPlayer,
	HumanoidRootPart,
})
