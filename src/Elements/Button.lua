local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Idx, Config)
	local ActualConfig = type(Idx) == "table" and Idx or Config
	assert(ActualConfig and ActualConfig.Title, "Button - Missing Title")
	ActualConfig.Callback = ActualConfig.Callback or function() end

	local ButtonFrame = require(Components.Element)(ActualConfig.Title, ActualConfig.Description, self.Container, true)

	local ButtonIco = New("ImageLabel", {
		Image = "rbxassetid://10709791437",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = ButtonFrame.Frame,
		ThemeTag = {
			ImageColor3 = "Text",
		},
	})

	Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
		self.Library:SafeCallback(ActualConfig.Callback)
	end)

	return ButtonFrame
end

return Element
