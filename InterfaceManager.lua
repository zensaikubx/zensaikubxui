local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
	local function safeIsFile(path)
		if typeof(isfile) == "function" then
			local s, res = pcall(isfile, path)
			return s and res
		end
		return false
	end

	local function safeReadFile(path)
		if typeof(readfile) == "function" then
			local s, res = pcall(readfile, path)
			if s and type(res) == "string" then
				return res
			end
		end
		return nil
	end

	local function safeWriteFile(path, content)
		if typeof(writefile) == "function" then
			pcall(writefile, path, content)
		end
	end

	local function safeIsFolder(path)
		if typeof(isfolder) == "function" then
			local s, res = pcall(isfolder, path)
			return s and res
		end
		return false
	end

	local function safeMakeFolder(path)
		if typeof(makefolder) == "function" then
			pcall(makefolder, path)
		end
	end

	InterfaceManager.Folder = "ZensaiSettings"
    InterfaceManager.Settings = {
        Theme = "Dark",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl"
    }

    function InterfaceManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

    function InterfaceManager:SetLibrary(library)
		self.Library = library
	end

    function InterfaceManager:BuildFolderTree()
		local paths = {}

		local parts = self.Folder:split("/")
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, idx)
		end

		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/settings")

		for i = 1, #paths do
			local str = paths[i]
			if not safeIsFolder(str) then
				safeMakeFolder(str)
			end
		end
	end

    function InterfaceManager:SaveSettings()
		safeWriteFile(self.Folder .. "/options.json", httpService:JSONEncode(InterfaceManager.Settings))
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if not safeIsFile(path) and safeIsFile("FluentSettings/options.json") then
            path = "FluentSettings/options.json"
        end

        if safeIsFile(path) then
            local data = safeReadFile(path)
			if not data then return end
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)

            if success and type(decoded) == "table" then
                for i, v in next, decoded do
                    InterfaceManager.Settings[i] = v
                end
            end
        end
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
        local Settings = InterfaceManager.Settings

        InterfaceManager:LoadSettings()

		local section = tab:AddSection("Interface")

		local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
			Title = "Theme",
			Description = "Changes the interface theme.",
			Values = Library.Themes,
			Default = Settings.Theme,
			Callback = function(Value)
				Library:SetTheme(Value)
                Settings.Theme = Value
                InterfaceManager:SaveSettings()
			end
		})

        InterfaceTheme:SetValue(Settings.Theme)
	
		if Library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "The blurred background requires graphic quality 8+",
				Default = Settings.Acrylic,
				Callback = function(Value)
					Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
				end
			})
		end
	
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "Makes the interface transparent.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                InterfaceManager:SaveSettings()
			end
		})
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind })
		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager