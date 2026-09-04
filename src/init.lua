local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer and not RunService:IsStudio() then
	local start = os.clock()
	while not LocalPlayer and (os.clock() - start) < 5 do
		LocalPlayer = Players.LocalPlayer
		task.wait(0.05)
	end
end

local Root = script
local Creator = require(Root.Creator)
local ElementsTable = require(Root.Elements)
local Acrylic = require(Root.Acrylic)
local Components = Root.Components
local NotificationModule = require(Components.Notification)

local New = Creator.New

local function GetGuiParent()
	-- 1. UNC gethui function (hidden UI container)
	if typeof(gethui) == "function" then
		local success, hui = pcall(gethui)
		if success and hui and typeof(hui) == "Instance" then
			local testSuccess = pcall(function()
				local test = Instance.new("ScreenGui")
				test.Parent = hui
				test:Destroy()
			end)
			if testSuccess then
				return hui
			end
		end
	end

	-- 2. Studio mode
	if RunService:IsStudio() then
		if LocalPlayer then
			local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
			if playerGui then
				return playerGui
			end
		end
	end

	-- 3. Try CoreGui if identity has permission
	local successCore, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if successCore and coreGui then
		local testSuccess = pcall(function()
			local test = Instance.new("ScreenGui")
			test.Parent = coreGui
			test:Destroy()
		end)
		if testSuccess then
			return coreGui
		end
	end

	-- 4. Low UNC / Level 2-3 / Solara / Mobile fallback: PlayerGui
	if LocalPlayer then
		local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
		if playerGui then
			return playerGui
		end
	end

	return coreGui or game:GetService("StarterGui")
end

local function SafeProtectGui(gui)
	pcall(function()
		if typeof(protectgui) == "function" then
			protectgui(gui)
		elseif typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
			syn.protect_gui(gui)
		end
	end)
end

local GUI = New("ScreenGui", {
	Name = "Zensai",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
SafeProtectGui(GUI)

local guiParent = GetGuiParent()
local setParentSuccess = pcall(function()
	GUI.Parent = guiParent
end)
if not setParentSuccess and LocalPlayer then
	pcall(function()
		GUI.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
	end)
end

NotificationModule:Init(GUI)

local Library = {
	Version = "1.1.0",

	OpenFrames = {},
	Options = {},
	Themes = require(Root.Themes).Names,

	Window = nil,
	WindowFrame = nil,
	Unloaded = false,

	Theme = "Dark",
	DialogOpen = false,
	UseAcrylic = false,
	Acrylic = false,
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.LeftControl,

	GUI = GUI,
}

function Library:SafeCallback(Function, ...)
	if not Function then
		return
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		local _, i = Event:find(":%d+: ")

		if not i then
			return Library:Notify({
				Title = "Interface",
				Content = "Callback error",
				SubContent = Event,
				Duration = 5,
			})
		end

		return Library:Notify({
			Title = "Interface",
			Content = "Callback error",
			SubContent = Event:sub(i + 1),
			Duration = 5,
		})
	end
end

function Library:Round(Number, Factor)
	if not Factor or Factor == 0 then
		return math.round(Number)
	end
	local Mult = 10 ^ Factor
	return math.round(Number * Mult) / Mult
end

local Icons = require(Root.Icons).assets
function Library:GetIcon(Name)
	if Name ~= nil and Icons["lucide-" .. Name] then
		return Icons["lucide-" .. Name]
	end
	return nil
end

local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in ipairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		return ElementComponent:New(Idx, Config)
	end
end

Library.Elements = Elements

function Library:CreateWindow(Config)
	assert(Config.Title, "Window - Missing Title")

	if Library.Window then
		print("You cannot create more than one window.")
		return
	end

	Library.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.LeftControl
	Library.UseAcrylic = Config.Acrylic or false
	Library.Acrylic = Config.Acrylic or false
	Library.Theme = Config.Theme or "Dark"
	if Config.Acrylic then
		Acrylic.init()
	end

	local Window = require(Components.Window)({
		Parent = GUI,
		Size = Config.Size,
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		TabWidth = Config.TabWidth,
	})

	Library.Window = Window
	Library:SetTheme(Config.Theme)

	return Window
end

function Library:SetTheme(Value)
	if Library.Window and table.find(Library.Themes, Value) then
		Library.Theme = Value
		Creator.UpdateTheme()
	end
end

function Library:Destroy()
	Library.Unloaded = true
	pcall(function()
		if Library.UseAcrylic and Library.Window and Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then
			Library.Window.AcrylicPaint.Model:Destroy()
		end
		Creator.Disconnect()
		if Library.GUI then
			Library.GUI:Destroy()
		end
	end)
end

function Library:ToggleAcrylic(Value)
	if Library.Window then
		if Library.UseAcrylic then
			Library.Acrylic = Value
			if Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then
				Library.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
			end
			if Value then
				Acrylic.Enable()
			else
				Acrylic.Disable()
			end
		end
	end
end

function Library:ToggleTransparency(Value)
	if Library.Window and Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Frame then
		Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = Value and 0.35 or 0
	end
end

function Library:Notify(Config)
	return NotificationModule:New(Config)
end

local globalEnv = (typeof(getgenv) == "function" and getgenv()) or _G or shared
if typeof(globalEnv) == "table" then
	pcall(function()
		globalEnv.Zensai = Library
		globalEnv.Fluent = Library
	end)
end

return Library
