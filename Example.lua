--[[
    Zensai UI - Example Script
    https://github.com/zensaikubx/zensaikubxui
--]]

-- ════════════════════════════════════════════
--  โหลด Library
-- ════════════════════════════════════════════
local function safeLoad(url, fallback)
    local function get(u)
        local c
        pcall(function() c = game:HttpGet(u) end)
        if c and c ~= "" then return c end
        local r = (typeof(request) == "function" and request)
            or (typeof(http_request) == "function" and http_request)
            or (typeof(syn) == "table" and syn.request)
        if r then
            pcall(function()
                local res = r({ Url = u, Method = "GET" })
                if typeof(res) == "table" and res.Body ~= "" then c = res.Body end
            end)
        end
        return c
    end
    local code = get(url)
    if (not code or code == "") and fallback then code = get(fallback) end
    assert(code and code ~= "", "[Zensai] โหลดไม่ได้: " .. tostring(url))
    local fn, err = loadstring(code)
    assert(fn, "[Zensai] loadstring error: " .. tostring(err))
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

-- ════════════════════════════════════════════
--  สร้าง Window
-- ════════════════════════════════════════════
local Window = Zensai:CreateWindow({
    Title    = "Zensai UI " .. Zensai.Version,
    SubTitle = "by zensaikubx",
    TabWidth = 160,
    Size     = UDim2.fromOffset(580, 460),
    Acrylic  = true,               -- blur effect
    Theme    = "Dark",             -- Dark / Light / Darker / Rose / Aqua / Amethyst
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ════════════════════════════════════════════
--  Tabs
-- ════════════════════════════════════════════
local Tabs = {
    Main     = Window:AddTab({ Title = "Main",     Icon = "home"     }),
    Visual   = Window:AddTab({ Title = "Visual",   Icon = "eye"      }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Zensai.Options

-- ════════════════════════════════════════════
--  Notification ต้อนรับ
-- ════════════════════════════════════════════
Zensai:Notify({
    Title      = "Zensai UI",
    Content    = "โหลดสำเร็จ!",
    SubContent = "Version " .. Zensai.Version,
    Duration   = 4,
})

-- ════════════════════════════════════════════
--  Tab: Main
-- ════════════════════════════════════════════
do
    Tabs.Main:AddSection("Info")

    Tabs.Main:AddParagraph({
        Title   = "ยินดีต้อนรับ",
        Content = "Zensai UI พร้อมใช้งานแล้ว\nรองรับ 60 / 144 / 240 FPS",
    })

    Tabs.Main:AddSection("Controls")

    -- Button + Dialog
    Tabs.Main:AddButton({
        Title       = "เปิด Dialog",
        Description = "ทดสอบกล่องยืนยัน",
        Callback    = function()
            Window:Dialog({
                Title   = "ยืนยัน",
                Content = "คุณต้องการดำเนินการต่อหรือไม่?",
                Buttons = {
                    {
                        Title    = "ยืนยัน",
                        Callback = function() print("ยืนยันแล้ว") end,
                    },
                    {
                        Title    = "ยกเลิก",
                        Callback = function() print("ยกเลิกแล้ว") end,
                    },
                },
            })
        end,
    })

    -- Toggle
    local SpeedToggle = Tabs.Main:AddToggle("SpeedEnabled", {
        Title       = "Speed Hack",
        Description = "เปิด/ปิด Speed",
        Default     = false,
    })
    SpeedToggle:OnChanged(function()
        print("Speed:", Options.SpeedEnabled.Value)
    end)

    -- Slider
    Tabs.Main:AddSlider("SpeedValue", {
        Title       = "Speed Amount",
        Description = "ค่าความเร็ว",
        Default     = 16,
        Min         = 1,
        Max         = 200,
        Rounding    = 0,
        Callback    = function(v) print("Speed:", v) end,
    })

    -- Dropdown (single)
    Tabs.Main:AddDropdown("TeamSelect", {
        Title    = "เลือกทีม",
        Values   = { "Red", "Blue", "Green", "Yellow" },
        Multi    = false,
        Default  = 1,
        Callback = function(v) print("ทีม:", v) end,
    })

    -- Dropdown (multi)
    Tabs.Main:AddDropdown("FeatureSelect", {
        Title    = "เลือก Features",
        Values   = { "ESP", "Aimbot", "NoClip", "Fly" },
        Multi    = true,
        Default  = { "ESP" },
        Callback = function(v) print("Features อัพเดท") end,
    })

    -- Keybind
    Tabs.Main:AddKeybind("KillKey", {
        Title    = "Kill Aura Key",
        Mode     = "Hold",     -- Hold / Toggle
        Default  = "E",
        Callback = function(held) print("KillAura:", held) end,
    })

    -- Input
    Tabs.Main:AddInput("TargetName", {
        Title       = "ชื่อเป้าหมาย",
        Placeholder = "พิมพ์ชื่อผู้เล่น...",
        Default     = "",
        Numeric     = false,
        Finished    = true,   -- true = callback เมื่อกด Enter เท่านั้น
        Callback    = function(v) print("Target:", v) end,
    })
end

-- ════════════════════════════════════════════
--  Tab: Visual
-- ════════════════════════════════════════════
do
    Tabs.Visual:AddSection("ESP")

    Tabs.Visual:AddToggle("ESPEnabled", {
        Title   = "ESP",
        Default = false,
    })

    Tabs.Visual:AddColorpicker("ESPColor", {
        Title        = "ESP Color",
        Default      = Color3.fromRGB(255, 50, 50),
        Transparency = 0,
        Callback     = function(c) print("ESP Color:", c) end,
    })

    Tabs.Visual:AddSection("Chams")

    Tabs.Visual:AddToggle("ChamsEnabled", {
        Title   = "Chams",
        Default = false,
    })

    Tabs.Visual:AddColorpicker("ChamsColor", {
        Title        = "Chams Color",
        Default      = Color3.fromRGB(96, 205, 255),
        Transparency = 0,
        Callback     = function(c) print("Chams Color:", c) end,
    })
end

-- ════════════════════════════════════════════
--  Tab: Settings  (SaveManager + InterfaceManager)
-- ════════════════════════════════════════════
SaveManager:SetLibrary(Zensai)
InterfaceManager:SetLibrary(Zensai)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("ZensaiUI")
SaveManager:SetFolder("ZensaiUI")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ════════════════════════════════════════════
--  เปิด Tab แรก และโหลด Config อัตโนมัติ
-- ════════════════════════════════════════════
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()


