local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Root = script.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)
local New = Creator.New

local Spring = Flipper.Spring.new
local Instant = Flipper.Instant.new

local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	Camera = Workspace.CurrentCamera or Camera
end)

return function(Config)
	Config = Config or {}
	local Library = require(Root)

	local Callback = Config.Callback
	local Size = Config.Size or UDim2.fromOffset(48, 48)
	local Position = Config.Position or UDim2.new(0, 20, 0.5, -24)
	local CornerRadius = Config.CornerRadius or UDim.new(0, 14)
	local IconSize = Config.IconSize or UDim2.fromOffset(24, 24)

	local FloatingButton = {
		Frame = nil,
		Visible = Config.Visible ~= false,
	}

	-- Resolve Icon Asset
	local IconAsset = "rbxassetid://10734887784" -- default: lucide-menu
	if Config.Icon then
		if type(Config.Icon) == "string" and (Config.Icon:find("rbxasset") or Config.Icon:find("http")) then
			IconAsset = Config.Icon
		else
			local resolved = Library:GetIcon(Config.Icon)
			if resolved then
				IconAsset = resolved
			else
				IconAsset = Config.Icon
			end
		end
	end

	local IconImage = New("ImageLabel", {
		Size = IconSize,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = IconAsset,
		ThemeTag = {
			ImageColor3 = "Accent",
		},
	})

	local HoverFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ThemeTag = {
			BackgroundColor3 = "Hover",
		},
	}, {
		New("UICorner", {
			CornerRadius = CornerRadius,
		}),
	})

	local ButtonStroke = New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1.5,
		Transparency = 0.2,
		ThemeTag = {
			Color = "Accent",
		},
	})

	local ButtonCorner = New("UICorner", {
		CornerRadius = CornerRadius,
	})

	local ScaleObject = New("UIScale", {
		Scale = 1,
	})

	local ButtonFrame = New("TextButton", {
		Name = "FloatingButton",
		Text = "",
		AutoButtonColor = false,
		Size = Size,
		Position = Position,
		BackgroundTransparency = 0.15,
		ZIndex = 100,
		Visible = FloatingButton.Visible,
		Parent = Config.Parent or Library.GUI,
		ThemeTag = {
			BackgroundColor3 = "Dialog",
		},
	}, {
		ButtonCorner,
		ButtonStroke,
		HoverFrame,
		IconImage,
		ScaleObject,
	})

	FloatingButton.Frame = ButtonFrame
	FloatingButton.Icon = IconImage
	FloatingButton.Stroke = ButtonStroke

	-- Springs
	local ScaleMotor = Flipper.SingleMotor.new(1)
	ScaleMotor:onStep(function(val)
		ScaleObject.Scale = val
	end)

	local HoverMotor, SetHoverTransparency = Creator.SpringMotor(1, HoverFrame, "BackgroundTransparency")

	-- Dragging State
	local Dragging = false
	local HasMoved = false
	local DragStartMouse = Vector3.new()
	local DragStartPos = Position
	local DragStartTime = 0

	Creator.AddSignal(ButtonFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
			HasMoved = false
			DragStartMouse = Input.Position
			DragStartPos = ButtonFrame.Position
			DragStartTime = os.clock()

			ScaleMotor:setGoal(Spring(0.92, { frequency = 10 }))
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if
			Dragging
			and (
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local Delta = Input.Position - DragStartMouse
			local distance = math.sqrt(Delta.X * Delta.X + Delta.Y * Delta.Y)
			if distance > 6 then
				HasMoved = true
			end

			if HasMoved then
				local targetX = DragStartPos.X.Offset + Delta.X
				local targetY = DragStartPos.Y.Offset + Delta.Y

				local vp = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
				local btnW = ButtonFrame.AbsoluteSize.X > 0 and ButtonFrame.AbsoluteSize.X or 48
				local btnH = ButtonFrame.AbsoluteSize.Y > 0 and ButtonFrame.AbsoluteSize.Y or 48

				local clampedX = math.clamp(targetX, 0, math.max(0, vp.X - btnW))
				local clampedY = math.clamp(targetY, 0, math.max(0, vp.Y - btnH))

				ButtonFrame.Position = UDim2.fromOffset(clampedX, clampedY)
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if
			(
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			)
			and Dragging
		then
			Dragging = false
			ScaleMotor:setGoal(Spring(1, { frequency = 8 }))

			local elapsed = os.clock() - DragStartTime
			if not HasMoved and elapsed < 0.6 then
				-- Trigger Click Callback
				if Callback then
					task.spawn(function()
						local success, err = pcall(Callback)
						if not success then
							warn("[Zensai FloatingButton] Error in callback: " .. tostring(err))
						end
					end)
				end
			end
		end
	end)

	-- Hover effects on PC
	Creator.AddSignal(ButtonFrame.MouseEnter, function()
		if not Dragging then
			ScaleMotor:setGoal(Spring(1.06, { frequency = 8 }))
			SetHoverTransparency(0.92)
		end
	end)

	Creator.AddSignal(ButtonFrame.MouseLeave, function()
		if not Dragging then
			ScaleMotor:setGoal(Spring(1, { frequency = 8 }))
			SetHoverTransparency(1)
		end
	end)

	-- Viewport Bounds Guard
	local function checkBounds()
		local vp = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
		local btnW = ButtonFrame.AbsoluteSize.X > 0 and ButtonFrame.AbsoluteSize.X or 48
		local btnH = ButtonFrame.AbsoluteSize.Y > 0 and ButtonFrame.AbsoluteSize.Y or 48
		local curX = ButtonFrame.Position.X.Offset
		local curY = ButtonFrame.Position.Y.Offset
		if curX > vp.X - btnW or curY > vp.Y - btnH then
			local clampedX = math.clamp(curX, 0, math.max(0, vp.X - btnW))
			local clampedY = math.clamp(curY, 0, math.max(0, vp.Y - btnH))
			ButtonFrame.Position = UDim2.fromOffset(clampedX, clampedY)
		end
	end

	if Camera then
		Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), checkBounds)
	end

	-- API Methods
	function FloatingButton:SetVisible(visible)
		FloatingButton.Visible = visible
		ButtonFrame.Visible = visible
	end

	function FloatingButton:SetPosition(pos)
		ButtonFrame.Position = pos
	end

	function FloatingButton:SetIcon(icon)
		if not icon then return end
		local asset = icon
		if type(icon) == "string" and not icon:find("rbxasset") and not icon:find("http") then
			local resolved = Library:GetIcon(icon)
			if resolved then
				asset = resolved
			end
		end
		IconImage.Image = asset
	end

	function FloatingButton:OnClick(fn)
		Callback = fn
	end

	function FloatingButton:Destroy()
		ScaleMotor:stop()
		HoverMotor:stop()
		ButtonFrame:Destroy()
	end

	return FloatingButton
end
