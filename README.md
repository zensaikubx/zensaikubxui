# Zensai UI 🌸

> **Zensai UI** is an ultra-smooth, modernized, and bug-free Roblox UI library (enhanced & optimized from Fluent UI). Built for 60/144/240 FPS fluidity with zero drag latency, instant responsiveness, and comprehensive executor support.

---

## 🚀 Quick Start (ลิ้งก์พร้อมใช้งาน)

วางสคริปต์นี้ใน Executor (Delta, Hydrogen, Wave, Synapse, Solara, etc.) เพื่อเรียกใช้งานได้ทันที:

```lua
local Zensai = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/InterfaceManager.lua"))()
```

---

## ✨ คุณสมบัติเด่น (Highlights & Optimizations)

- ⚡ **Ultra-Smooth Dragging**: ลากหน้าต่างและปรับขนาดแบบ 1:1 เรียลไทม์ ไม่มีดีเลย์ เมาส์ไม่หลุดแม้สะบัดเมาส์เร็ว
- 🏎️ **$O(1)$ Theme Updates**: สร้าง UI ได้เร็วขึ้น 90%+ ไม่มีอาการกระตุกตอนโหลด (Lag Spikes)
- 🎯 **Fixed Slider Mouse Lock**: แก้ไขบั๊ก Slider ค้างตามเมาส์ และคลิกเลื่อนบนรางได้ทันที
- 📱 **Mobile & Touch Supported**: รองรับการใช้งานบนมือถือ จอสัมผัส ทุก Element รวมถึง Colorpicker
- 🛡️ **Zero Memory Leaks**: ทำลาย Instance และตัดการเชื่อมต่อสัญญาณอย่างสมบูรณ์เมื่อปิดหน้าต่าง
- 💾 **Smart Config System**: จัดเก็บการตั้งค่าไว้ในโฟลเดอร์ `ZensaiSettings` พร้อมระบบตรวจจับและดึงคอนฟิกเก่าจาก `FluentSettings` ให้อัตโนมัติ

---

## 📖 ตัวอย่างการใช้งาน (Example Usage)

```lua
local Zensai = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/InterfaceManager.lua"))()

local Window = Zensai:CreateWindow({
    Title = "Zensai UI",
    SubTitle = "by zensaikubx",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Zensai.Options

-- Notification
Zensai:Notify({
    Title = "Zensai UI",
    Content = "Script loaded successfully!",
    Duration = 5
})

-- Paragraph
Tabs.Main:AddParagraph({
    Title = "Welcome",
    Content = "This is Zensai UI - Smooth & Optimized!"
})

-- Button
Tabs.Main:AddButton({
    Title = "Click Me",
    Description = "A simple button",
    Callback = function()
        print("Button clicked!")
    end
})

-- Toggle
local Toggle = Tabs.Main:AddToggle("MyToggle", {
    Title = "Auto Farm",
    Default = false
})

Toggle:OnChanged(function()
    print("Auto Farm:", Options.MyToggle.Value)
end)

-- Slider
local Slider = Tabs.Main:AddSlider("MySlider", {
    Title = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Dropdown
local Dropdown = Tabs.Main:AddDropdown("MyDropdown", {
    Title = "Select Mode",
    Values = {"Fast", "Normal", "Legit"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        print("Mode selected:", Value)
    end
})

-- Colorpicker
Tabs.Main:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 50, 50)
})

-- Keybind
Tabs.Main:AddKeybind("FarmKeybind", {
    Title = "Farm Toggle Key",
    Mode = "Toggle",
    Default = "RightShift"
})

-- Input
Tabs.Main:AddInput("PlayerTarget", {
    Title = "Target Player",
    Default = "",
    Placeholder = "Enter username...",
    Finished = true,
    Callback = function(Value)
        print("Target:", Value)
    end
})

-- SaveManager & InterfaceManager
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
```

---

## 📜 License

Distributed under the MIT License. Based on dawid-scripts/Fluent, enhanced & optimized for Zensai UI.
