local Root = script.Parent.Parent
local Components = Root.Components
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)

local Paragraph = {}
Paragraph.__index = Paragraph
Paragraph.__type = "Paragraph"

function Paragraph:New(Idx, Config)
	local ActualConfig = type(Idx) == "table" and Idx or Config
	assert(ActualConfig and ActualConfig.Title, "Paragraph - Missing Title")
	ActualConfig.Content = ActualConfig.Content or ""

	local ParagraphFrame = require(Components.Element)(ActualConfig.Title, ActualConfig.Content, self.Container, false)
	ParagraphFrame.Frame.BackgroundTransparency = 0.92
	ParagraphFrame.Border.Transparency = 0.6

	return ParagraphFrame
end

return Paragraph
