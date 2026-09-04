--[[
    Zensai UI - Complete Example Script
    Ultra-Smooth & Enhanced Roblox Interface Suite
--]]

local function safeLoad(url, fallbackUrl)
    local get = function(u)
        local c = nil
        pcall(function() if game and game.HttpGet then c = game:HttpGet(u) end end)
        if c and c ~= "" then return c end
        pcall(function() if typeof(HttpGet) == "function" then c = HttpGet(u) end end)
        if c and c ~= "" then return c end
        local r = (typeof(request) == "function" and request)
            or (typeof(http_request) == "function" and http_request)
            or (typeof(syn) == "table" and typeof(syn.request) == "function" and syn.request)
        if r then
            pcall(function()
                local res = r({ Url = u, Method = "GET" })
                if typeof(res) == "table" and res.Body and res.Body ~= "" then c = res.Body end
            end)
        end
        return c
    end

    local code = get(url)
    if (not code or code == "") and fallbackUrl then
        code = get(fallbackUrl)
    end
    if not code or code == "" then
        error("[Zensai UI] ไม่สามารถดาวน์โหลดสคริปต์ได้ ตรวจสอบอินเทอร์เน็ตหรือ URL: " .. tostring(url), 2)
    end

    local loader = loadstring or (typeof(load) == "function" and load)
    if not loader then
        error("[Zensai UI] Executor ของคุณไม่มีฟังก์ชัน loadstring!", 2)
    end

    local fn, err = loader(code)
    if not fn then
        error("[Zensai UI] เกิดข้อผิดพลาดในการโหลดสคริปต์: " .. tostring(err), 2)
    end
    return fn()
end

local Zensai = safeLoad(
    "https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/main.lua",
    "https://cdn.jsdelivr.net/gh/zensaikubx/zensaikubxui@main/main.lua"
)
local SaveManager = safeLoad(
    "https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/SaveManager.lua",
    "https://cdn.jsdelivr.net/gh/zensaikubx/zensaikubxui@main/SaveManager.lua"
)
local InterfaceManager = safeLoad(
    "https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/InterfaceManager.lua",
    "https://cdn.jsdelivr.net/gh/zensaikubx/zensaikubxui@main/InterfaceManager.lua"
)

-- Wait for Roblox camera to initialize
local Camera

repeat
    Camera = workspace.CurrentCamera
    task.wait()
until Camera

-- Wait until ViewportSize is valid
repeat
    task.wait()
until Camera.ViewportSize.X > 0 and Camera.ViewportSize.Y > 0

local Window = Zensai:CreateWindow({
    Title = "Zensai UI " .. Zensai.Version,
    SubTitle = "Ultra-Smooth Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Smooth blur effect
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Zensai.Options

do
    Zensai:Notify({
        Title = "Zensai UI",
        Content = "Welcome to Zensai UI!",
        SubContent = "Optimized for maximum smoothness.",
        Duration = 5
    })

    Tabs.Main:AddParagraph({
        Title = "Zensai UI",
        Content = "Optimized for 60/144/240 FPS fluidity.\nZero-latency dragging and instant responsiveness."
    })

    Tabs.Main:AddButton({
        Title = "Test Dialog",
        Description = "Opens a smooth confirmation modal",
        Callback = function()
            Window:Dialog({
                Title = "Confirmation",
                Content = "This is a smooth dialog box in Zensai UI.",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed dialog")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled dialog")
                        end
                    }
                }
            })
        end
    })

    local Toggle = Tabs.Main:AddToggle("MyToggle", {
        Title = "Smooth Toggle",
        Description = "Fluid state switch with accent animation",
        Default = false
    })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    local Slider = Tabs.Main:AddSlider("MySlider", {
        Title = "Slider Control",
        Description = "Drag or click anywhere along the rail",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            print("Slider value:", Value)
        end
    })

    local Dropdown = Tabs.Main:AddDropdown("MyDropdown", {
        Title = "Dropdown Selector",
        Values = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},
        Multi = false,
        Default = 1,
        Callback = function(Value)
            print("Dropdown selected:", Value)
        end
    })

    local MultiDropdown = Tabs.Main:AddDropdown("MyMultiDropdown", {
        Title = "Multi Dropdown",
        Values = {"Feature A", "Feature B", "Feature C", "Feature D"},
        Multi = true,
        Default = {"Feature A"},
        Callback = function(Value)
            print("MultiDropdown updated")
        end
    })

    local Colorpicker = Tabs.Main:AddColorpicker("MyColorpicker", {
        Title = "Accent Color",
        Default = Color3.fromRGB(96, 205, 255),
        Transparency = 0,
        Callback = function(Value)
            print("Color chosen:", Value)
        end
    })

    local Keybind = Tabs.Main:AddKeybind("MyKeybind", {
        Title = "Custom Keybind",
        Mode = "Toggle",
        Default = "RightShift",
        Callback = function(Value)
            print("Keybind toggled:", Value)
        end
    })

    local Input = Tabs.Main:AddInput("MyInput", {
        Title = "Text Input",
        Default = "",
        Placeholder = "Enter text here...",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            print("Input text:", Value)
        end
    })
end

-- SaveManager and InterfaceManager Setup
SaveManager:SetLibrary(Zensai)
InterfaceManager:SetLibrary(Zensai)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("ZensaiSettings")
SaveManager:SetFolder("ZensaiSettings")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
