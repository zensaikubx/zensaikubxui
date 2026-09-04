# Zensai UI 🌸

> **Zensai UI** is an ultra-smooth, modernized, and bug-free Roblox UI library (enhanced & optimized from Fluent UI). Built for 60/144/240 FPS fluidity with zero drag latency, instant responsiveness, and comprehensive executor support.

---

## 🚀 Quick Start (ลิ้งก์พร้อมใช้งาน)


### ตัวเลือกที่ 1: ลิ้งก์ GitHub Raw โดยตรง
```lua
local Zensai = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/InterfaceManager.lua"))()
```

---

## ✨ คุณสมบัติเด่น (Highlights & Optimizations)

- ⚡ **Ultra-Smooth Dragging**: ลากหน้าต่างและปรับขนาดแบบ 1:1 เรียลไทม์ ไม่มีดีเลย์ เมาส์ไม่หลุดแม้สะบัดเมาส์เร็ว
- 🔘 **Draggable Floating Button**: ปุ่มลอยเปิด/ปิด UI ลากได้อิสระบนหน้าจอ แยกแยะระหว่าง Drag กับ Tap 100% พร้อมระบบกันหลุดขอบจอ เหมาะกับทั้ง PC และ Mobile
- 🏎️ **$O(1)$ Theme Updates**: สร้าง UI ได้เร็วขึ้น 90%+ ไม่มีอาการกระตุกตอนโหลด (Lag Spikes)
- 🎯 **Fixed Slider Mouse Lock**: แก้ไขบั๊ก Slider ค้างตามเมาส์ และคลิกเลื่อนบนรางได้ทันที
- 📱 **Mobile & Touch Supported**: รองรับการใช้งานบนมือถือ จอสัมผัส ทุก Element รวมถึง Colorpicker
- 🛡️ **Zero Memory Leaks**: ทำลาย Instance และตัดการเชื่อมต่อสัญญาณอย่างสมบูรณ์เมื่อปิดหน้าต่าง
- 💾 **Smart Config System**: จัดเก็บการตั้งค่าไว้ในโฟลเดอร์ `ZensaiSettings` พร้อมระบบตรวจจับและดึงคอนฟิกเก่าจาก `FluentSettings` ให้อัตโนมัติ
- 🌐 **Universal Executor Compatibility (sUNC & Low UNC)**: รองรับทั้ง Executor สเปกสูง (sUNC) และสเปกต่ำ/ฟรี (Low UNC / Solara / Xeno / Celery / Delta / Codex / Hydrogen) โดยไม่แครชเรื่อง `CoreGui`, `protectgui`, หรือ `readfile/writefile`

---

## 📖 ตัวอย่างการใช้งาน (Example Usage)

```lua
local Zensai = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensaikubx/zensaikubxui/main/InterfaceManager.lua"))()

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
    Title = "Zensai UI",
    SubTitle = "by zensaikubx",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    FloatingButton = true -- หรือระบุ { Icon = "menu", Size = UDim2.fromOffset(48, 48) }
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

## 🔘 Floating Button (ปุ่มเปิด/ปิด UI ลอยบนหน้าจอ)

ปุ่มลอยสำหรับเปิด/ปิด UI ออกแบบมาให้ลากได้อิสระบนหน้าจอ ตอบสนอง 1:1 เรียลไทม์ รองรับทั้งเมาส์ (PC) และการสัมผัส (Mobile Touch)

### วิธีที่ 1: เปิดใช้งานผ่าน `CreateWindow`
```lua
local Window = Zensai:CreateWindow({
    Title = "Zensai UI",
    SubTitle = "by zensaikubx",
    -- ...
    FloatingButton = true -- หรือกำหนด config ตารางได้
})
```

### วิธีที่ 2: เรียกผ่าน `Window:AddFloatingButton`
```lua
local FloatBtn = Window:AddFloatingButton({
    Icon = "menu",                           -- ชื่อ Lucide Icon หรือ rbxassetid://...
    Size = UDim2.fromOffset(48, 48),          -- ขนาดปุ่ม
    Position = UDim2.new(0, 20, 0.5, -24),    -- ตำแหน่งเริ่มต้น
    CornerRadius = UDim.new(0, 14),           -- ความมน
    Visible = true,                           -- แสดงทันทีหรือไม่
    Callback = function()                     -- ปรับแต่ง Callback ได้ (ค่าเริ่มต้นคือ Window:Minimize())
        Window:Minimize()
    end
})

-- Methods ที่สามารถเรียกใช้งานได้:
FloatBtn:SetVisible(false)                   -- ซ่อน/แสดง
FloatBtn:SetPosition(UDim2.fromOffset(50, 50))
FloatBtn:SetIcon("layers")
FloatBtn:Destroy()                           -- ทำลายปุ่ม
```

### วิธีที่ 3: เปิด/ปิดผ่านแท็บ Interface Settings
ใน `InterfaceManager` จะมีสวิตช์ Toggle **"Floating Button"** เพิ่มขึ้นมาให้อัตโนมัติ ผู้ใช้งานสามารถเปิด/ปิดได้จากในเกม และระบบจะบันทึกสถานะลงในไฟล์ Config ให้เอง

---

## 📜 License

Distributed under the MIT License. Based on dawid-scripts/Fluent, enhanced & optimized for Zensai UI.
