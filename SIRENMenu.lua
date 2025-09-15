-- example script by https://github.com/mstudio45/LinoriaLib/blob/main/Example.lua and modified by deivid
-- You can suggest changes with a pull request or something

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)

local Window = Library:CreateWindow({
	-- Set Center to true if you want the menu to appear in the center
	-- Set AutoShow to true if you want the menu to appear when it is created
	-- Set Resizable to true if you want to have in-game resizable Window
	-- Set MobileButtonsSide to "Left" or "Right" if you want the ui toggle & lock buttons to be on the left or right side of the window
	-- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
	-- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
	-- Position and Size are also valid options here
	-- but you do not need to define them unless you are changing them :)

	Title = "SIREN HUB",
	Footer = "Version: 1.0.0",
	Icon = nil,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
-- You can find more icons in https://lucide.dev/
local Tabs = {
	-- Creates a new tab titled Main
	Information = Window:AddTab("Information", "info"),
	Main = Window:AddTab("Players", "user"),
	Teleports = Window:AddTab("Teleport", "box"),
	-- Key = Window:AddKeyTab("Key System"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}


--[[
Example of how to add a warning box to a tab; the title AND text support rich text formatting.

local WarningTab = Tabs["UI Settings"]:AddTab("Warning Box", "user")

WarningTab:UpdateWarningBox({
	Visible = true,
	Title = "Warning",
	Text = "This is a warning box!",
})

]]

-- Groupbox Kiri: License Info
local LeftGroupBox = Tabs.Information:AddLeftGroupbox("Your License")

-- Ambil data dari login
local data = _G.SIREN_Data or {}
local Key = data.Key or "Unknown"
local HWID = data.HWID or "Unknown"
local ExpireAt = data.ExpireAt or "Unknown"

LeftGroupBox:AddLabel(
    "Your Key: " .. Key ..
    "\nHWID: " .. HWID ..
    "\n\nExpired At: " .. ExpireAt,
    true
)

-- Groupbox Kanan: Roblox Info & Level
local RightGroupBox = Tabs.Information:AddRightGroupbox("Your Account Info")

local RobloxUser = data.RobloxUser or "Unknown"
local RobloxID = data.RobloxID or "Unknown"
local Level = data.Level or "Free"

RightGroupBox:AddLabel(
    "Level: " .. Level ..
    "\n\nRoblox Username: " .. RobloxUser ..
    "\nRoblox ID: " .. RobloxID,
    true
)


-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(Name))
local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on right side

-- ===============================
-- Tab 1: WalkSpeed
-- ===============================
local WalkTab = TabBox:AddTab("WalkSpeed")

-- Default WalkSpeed
_G.CustomWalkSpeed = 16
_G.walkActive = false

-- Toggle WalkSpeed Enable
WalkTab:AddToggle("WalkToggle", {
    Text = "Walkspeed",
    Tooltip = "Activate or deactivate custom walkspeed",
    Default = false,
    Callback = function(Value)
        _G.walkActive = Value
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if Value then
                hum.WalkSpeed = _G.CustomWalkSpeed
                Library:Notify("Custom WalkSpeed Activated!", 5)
            else
                hum.WalkSpeed = 16
                Library:Notify("Custom WalkSpeed Deactivated!", 5)
            end
        end
    end,
})

-- Slider WalkSpeed
WalkTab:AddSlider("WalkSpeedSlider", {
    Text = "Walkspeed Range",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Tooltip = "Adjust walkspeed",
    Callback = function(Value)
        _G.CustomWalkSpeed = Value
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and _G.walkActive then
            hum.WalkSpeed = Value
        end

        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Walk Speed set to " .. Value,
            Duration = 3
        })
    end,
})

-- Reset WalkSpeed saat respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if _G.walkActive then
        hum.WalkSpeed = _G.CustomWalkSpeed or 16
    else
        hum.WalkSpeed = 16
    end
end)

-- ===============================
-- Tab 2: Fly Mode
-- ===============================
local FlyTab = TabBox:AddTab("Fly Mode")

_G.flySpeed = 50
_G.flyActive = false

-- Toggle Fly
FlyTab:AddToggle("FlyToggle", {
    Text = "Fly",
    Tooltip = "Activate or deactivate fly mode",
    Default = false,
    Callback = function(Value)
        _G.flyActive = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")

        if Value then
            Library:Notify("Fly Mode Activated!", 5)

            local BodyGyro = Instance.new("BodyGyro")
            local BodyVel = Instance.new("BodyVelocity")

            BodyGyro.P = 9e4
            BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.CFrame = root.CFrame
            BodyGyro.Parent = root

            BodyVel.Velocity = Vector3.new(0, 0, 0)
            BodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BodyVel.Parent = root

            _G.flyLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.flyActive then return end
                local camera = workspace.CurrentCamera
                local control = Vector3.new()

                if game.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    control = control + camera.CFrame.LookVector
                end
                if game.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    control = control - camera.CFrame.LookVector
                end
                if game.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    control = control - camera.CFrame.RightVector
                end
                if game.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    control = control + camera.CFrame.RightVector
                end
                if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    control = control + camera.CFrame.UpVector
                end
                if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    control = control - camera.CFrame.UpVector
                end

                BodyVel.Velocity = control * _G.flySpeed
                BodyGyro.CFrame = camera.CFrame
            end)
        else
            Library:Notify("Fly Mode Deactivated!", 5)

            if _G.flyLoop then
                _G.flyLoop:Disconnect()
                _G.flyLoop = nil
            end

            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end,
})

-- Slider Fly Speed
FlyTab:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Tooltip = "Adjust fly speed",
    Callback = function(Value)
        _G.flySpeed = Value
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Fly Speed set to " .. Value,
            Duration = 3
        })
    end,
})

local RightGroupBox = Tabs.Main:AddRightGroupbox("Character", "boxes")

-- ========================================
-- Infinite Jump Toggle
-- ========================================
_G.InfiniteJumpEnabled = false
if not _G.InfiniteJumpConnection then
    local UserInputService = game:GetService("UserInputService")
    _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if _G.InfiniteJumpEnabled then
            local plr = game.Players.LocalPlayer
            local char = plr.Character or plr.CharacterAdded:Wait()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local InfiniteJumpToggle = RightGroupBox:AddToggle("InfiniteJumpToggle", {
    Text = "Infinite Jump",
    Tooltip = "Enable infinite jumping",
    Default = false,
    Callback = function(Value)
        _G.InfiniteJumpEnabled = Value
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = Value and "Infinite Jump Activated!" or "Infinite Jump Deactivated!",
            Duration = 5
        })
    end,
})

-- ========================================
-- Invisible Toggle
-- ========================================
local function setTransparency(character, transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparency
        end
    end
end

local function toggleInvisibility(on)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end

    if on then
        local savedpos = char.HumanoidRootPart.CFrame
        char:MoveTo(Vector3.new(-25.95, 84, 3537.55))
        task.wait(0.15)

        local Seat = Instance.new("Seat", workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = "invischair"
        Seat.Transparency = 1
        Seat.Position = Vector3.new(-25.95, 84, 3537.55)

        local weld = Instance.new("Weld", Seat)
        weld.Part0 = Seat
        weld.Part1 = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")

        task.wait()
        Seat.CFrame = savedpos

        setTransparency(char, 0.5)
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Invisibility ON",
            Duration = 3
        })
    else
        local invisChair = workspace:FindFirstChild("invischair")
        if invisChair then invisChair:Destroy() end
        setTransparency(char, 0)
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Invisibility OFF",
            Duration = 3
        })
    end
end

local InvisibleToggle = RightGroupBox:AddToggle("InvisibleToggle", {
    Text = "Invisible",
    Tooltip = "Enable client-side invisibility",
    Default = false,
    Callback = function(Value)
        toggleInvisibility(Value)
    end,
})



-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'SecondTestLabel' & 'TestLabel'
-- To set the text of the label you do label:SetText

-- Options.TestLabel:SetText("first changed!")
-- Options.SecondTestLabel:SetText("second changed!")

-- Groupbox:AddDivider
-- Arguments: None
LeftGroupBox:AddDivider()

--[[
	Groupbox:AddSlider
	Arguments: Idx, SliderOptions

	SliderOptions: {
		Text = string,
		Default = number,
		Min = number,
		Max = number,
		Suffix = string,
		Rounding = number,
		Compact = boolean,
		HideMax = boolean,
	}

	Text, Default, Min, Max, Rounding must be specified.
	Suffix is optional.
	Rounding is the number of decimal places for precision.

	Compact will hide the title label of the Slider

	HideMax will only display the value instead of the value & max value of the slider
	Compact will do the same thing
]]

local RightGroupBox2 = Tabs.Main:AddRightGroupbox("ESP", "boxes")

-- ========================================
-- ESP Sense Custom Toggles
-- ========================================
_G.ESPSenseEnabled = false

-- Load library Sense
local Sense = loadstring(game:HttpGet('https://sirius.menu/sense'))()

-- Minimal shared config
Sense.sharedSettings.textSize = 13
Sense.sharedSettings.textFont = 2
Sense.sharedSettings.limitDistance = false
Sense.sharedSettings.maxDistance = 200
Sense.sharedSettings.useTeamColor = false

-- Enemy config
local enemy = Sense.teamSettings.enemy
enemy.enabled = false
enemy.box = true
enemy.name = true
enemy.healthBar = true
enemy.healthText = true
enemy.distance = true
enemy.tracer = true
enemy.tracerOrigin = "Bottom"

-- Load ESP initially
Sense:Load()

-- =======================
-- ESP Toggles
-- =======================
local function UpdateESP()
    if _G.ESPSenseEnabled then
        enemy.enabled = true
        Sense:Load()
    else
        enemy.enabled = false
        Sense:Unload()
    end
end

-- Main ESP Toggle
local ESPSenseToggle = RightGroupBox2:AddToggle("ESPSenseToggle", {
    Text = "ESP Sense",
    Tooltip = "Enable or disable ESP Sense",
    Default = false,
    Callback = function(Value)
        _G.ESPSenseEnabled = Value
        UpdateESP()
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = Value and "ESP Sense Activated!" or "ESP Sense Deactivated!",
            Duration = 5
        })
    end,
})

-- Health Toggle
local ESPHealthToggle = RightGroupBox2:AddToggle("ESPHealthToggle", {
    Text = "ESP Health",
    Tooltip = "Show/Hide enemy health",
    Default = true,
    Callback = function(Value)
        enemy.healthBar = Value
        enemy.healthText = Value
        if _G.ESPSenseEnabled then Sense:Load() end
    end,
})

-- Distance Toggle
local ESPDistanceToggle = RightGroupBox2:AddToggle("ESPDistanceToggle", {
    Text = "ESP Distance",
    Tooltip = "Show/Hide distance to enemy",
    Default = true,
    Callback = function(Value)
        enemy.distance = Value
        if _G.ESPSenseEnabled then Sense:Load() end
    end,
})

-- Name Toggle
local ESPNameToggle = RightGroupBox2:AddToggle("ESPNameToggle", {
    Text = "ESP Name",
    Tooltip = "Show/Hide enemy names",
    Default = true,
    Callback = function(Value)
        enemy.name = Value
        if _G.ESPSenseEnabled then Sense:Load() end
    end,
})

-- Box Toggle
local ESPBoxToggle = RightGroupBox2:AddToggle("ESPBoxToggle", {
    Text = "ESP Box",
    Tooltip = "Show/Hide boxes around enemy",
    Default = true,
    Callback = function(Value)
        enemy.box = Value
        if _G.ESPSenseEnabled then Sense:Load() end
    end,
})

-- Line/Tracer Toggle
local ESPLineToggle = RightGroupBox2:AddToggle("ESPLineToggle", {
    Text = "ESP Line",
    Tooltip = "Show/Hide tracer lines",
    Default = true,
    Callback = function(Value)
        enemy.tracer = Value
        if _G.ESPSenseEnabled then Sense:Load() end
    end,
})

-- =========================
-- Teleports
-- =========================
local LeftDropdownGroupBox = Tabs.Teleports:AddLeftGroupbox("Teleports 1", "boxes")
local RightDropdownGroupBox = Tabs.Teleports:AddRightGroupbox("Teleports 2", "boxes")

local function teleportTo(cframe)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframe
    end
end

-- Function to check level before teleport
local function canTeleport()
    if Level == "Free" then
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Free users cannot use teleport!",
            Duration = 3
        })
        return false
    end
    return true
end

-- =========================
-- LEFT GROUPBOX TELEPORTS
-- =========================
-- Mount Dombret
LeftDropdownGroupBox:AddDropdown("DombretDropdown", {
    Values = {"Spawn", "Summit"},
    Default = 1,
    Text = "Mount Dombret",
    Tooltip = "Teleport Mount Dombret",
    Callback = function(Value)
        if not canTeleport() then return end
        if Value == "Spawn" then
            teleportTo(CFrame.new(489.839050, 120.997307, 762.160034))
        elseif Value == "Summit" then
            teleportTo(CFrame.new(41.247673, 740.634216, 169.561218))
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Teleported to " .. Value,
            Duration = 3
        })
    end,
})

-- Mount Bae
LeftDropdownGroupBox:AddDropdown("BaeDropdown", {
    Values = {"Spawn", "Summit"},
    Default = 1,
    Text = "Mount Bae",
    Tooltip = "Teleport Mount Bae",
    Callback = function(Value)
        if not canTeleport() then return end
        if Value == "Spawn" then
            teleportTo(CFrame.new(489.839050, 120.997307, 762.160034))
        elseif Value == "Summit" then
            teleportTo(CFrame.new(156.748718, 827.008911, -1026.950317))
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Teleported to " .. Value,
            Duration = 3
        })
    end,
})

-- Mount Sibuatan Anti Delay
LeftDropdownGroupBox:AddDropdown("SibuatanAntiDelayDropdown", {
    Values = {"Spawn", "Summit"},
    Default = 1,
    Text = "Mount Sibuatan No Cooldown",
    Tooltip = "Teleport Mount Sibuatan Anti Delay",
    Callback = function(Value)
        if not canTeleport() then return end
        if Value == "Spawn" then
            teleportTo(CFrame.new(991.195984, 112.798019, -697.489807))
        elseif Value == "Summit" then
            teleportTo(CFrame.new(5386.600586, 8109.058594, 2179.034424))
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Teleported to " .. Value,
            Duration = 3
        })
    end,
})

-- Mount Sibuatan (with 30-minute cooldown)
do
    local cooldown = 30 * 60
    local lastTeleport = 0
    local CooldownLabel = LeftDropdownGroupBox:AddLabel("Cooldown: Ready ✅")

    task.spawn(function()
        while task.wait(1) do
            local now = tick()
            local remaining = cooldown - (now - lastTeleport)
            if remaining > 0 then
                local minutes = math.floor(remaining / 60)
                local seconds = math.floor(remaining % 60)
                CooldownLabel:Set("Cooldown: Active " .. minutes .. "m " .. seconds .. "s")
            else
                CooldownLabel:Set("Cooldown: Ready ✅")
            end
        end
    end)

    LeftDropdownGroupBox:AddDropdown("SibuatanDropdown", {
        Values = {"Spawn", "Summit"},
        Default = 1,
        Text = "Mount Sibuatan",
        Tooltip = "Teleport Mount Sibuatan",
        Callback = function(Value)
            if not canTeleport() then return end
            local now = tick()
            if now - lastTeleport < cooldown then
                local remaining = math.floor(cooldown - (now - lastTeleport))
                local minutes = math.floor(remaining / 60)
                local seconds = remaining % 60
                game.StarterGui:SetCore("SendNotification", {
                    Title = "JCloud Hub",
                    Text = "Teleport cooldown! Wait " .. minutes .. "m " .. seconds .. "s.",
                    Duration = 5
                })
                return
            end

            if Value == "Spawn" then
                teleportTo(CFrame.new(991.195984, 112.798019, -697.489807))
            elseif Value == "Summit" then
                teleportTo(CFrame.new(5386.600586, 8109.058594, 2179.034424))
            end

            lastTeleport = now
            game.StarterGui:SetCore("SendNotification", {
                Title = "JCloud Hub",
                Text = "Teleported to " .. Value,
                Duration = 3
            })
        end,
    })
end

LeftDropdownGroupBox:AddLabel(
    "• For Mount Atin: You must go to CP 23 first before heading to the Summit.\n" ..
    "• For Mount Sibuatan: It is recommended to use the Delay option to avoid suspicion.\n" ..
    "• For Mount Daun: If CP is unavailable, wait approximately 30 seconds after teleporting.\n\n" ..
    "SIRENHUB 2025",
    true
)


-- =========================
-- RIGHT GROUPBOX TELEPORTS
-- =========================
-- Mount Atin
RightDropdownGroupBox:AddDropdown("AtinDropdown", {
    Values = {"Spawn", "Pos 23", "Summit"},
    Default = 1,
    Text = "Mount Atin",
    Tooltip = "Teleport Mount Atin",
    Callback = function(Value)
        if not canTeleport() then return end
        if Value == "Spawn" then
            teleportTo(CFrame.new(10.996780, 60.998020, -964.791565))
        elseif Value == "Pos 23" then
            teleportTo(CFrame.new(-423.112488, 1710.612183, 3419.230225))
        elseif Value == "Summit" then
            teleportTo(CFrame.new(694.734863, 2195.690430, 4010.594482))
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Teleported to " .. Value,
            Duration = 3
        })
    end,
})

-- Mount Lembayana
RightDropdownGroupBox:AddDropdown("LembayanaDropdown", {
    Values = {"Spawn", "Summit"},
    Default = 1,
    Text = "Mount Lembayana",
    Tooltip = "Teleport Mount Lembayana",
    Callback = function(Value)
        if not canTeleport() then return end
        if Value == "Spawn" then
            teleportTo(CFrame.new(756.916748, 252.982285, 681.168152))
        elseif Value == "Summit" then
            teleportTo(CFrame.new(-23508.648438, 6307.981934, -6962.814941))
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Teleported to " .. Value,
            Duration = 3
        })
    end,
})

-- Mount Prau
RightDropdownGroupBox:AddDropdown("PrauDropdown", {
    Values = {"Spawn", "Summit"},
    Default = 1,
    Text = "Mount Prau",
    Tooltip = "Teleport Mount Prau",
    Callback = function(Value)
        if not canTeleport() then return end
        if Value == "Spawn" then
            teleportTo(CFrame.new(125.900627, 2.348172, 1243.795044))
        elseif Value == "Summit" then
            teleportTo(CFrame.new(-1364.789795, 481.025940, -1552.814941))
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "JCloud Hub",
            Text = "Teleported to " .. Value,
            Duration = 3
        })
    end,
})

-- Mount Daun with 1-minute cooldown
do
    local cooldown = 60
    local lastTeleport = 0
    RightDropdownGroupBox:AddDropdown("DaunDropdown", {
        Values = {"Spawn", "Pos 1", "Pos 2", "Pos 3", "Pos 4", "Summit"},
        Default = 1,
        Text = "Mount Daun",
        Tooltip = "Teleport Mount Daun",
        Callback = function(Value)
            if not canTeleport() then return end
            local now = tick()
            if now - lastTeleport < cooldown then
                local remaining = math.floor(cooldown - (now - lastTeleport))
                game.StarterGui:SetCore("SendNotification", {
                    Title = "JCloud Hub",
                    Text = "Teleport cooldown! Wait " .. remaining .. "s.",
                    Duration = 3
                })
                return
            end

            if Value == "Spawn" then
                teleportTo(CFrame.new(24.289274, 13.024839, -6.883502))
            elseif Value == "Pos 1" then
                teleportTo(CFrame.new(-622.821655, 250.330612, -382.938293))
            elseif Value == "Pos 2" then
                teleportTo(CFrame.new(-1204.497314, 261.701355, -487.193481))
            elseif Value == "Pos 3" then
                teleportTo(CFrame.new(-1398.959717, 578.441101, -950.643921))
            elseif Value == "Pos 4" then
                teleportTo(CFrame.new(-1702.220459, 816.613403, -1400.444214))
            elseif Value == "Summit" then
                teleportTo(CFrame.new(-3230.208740, 1714.455566, -2589.435547))
            end

            lastTeleport = now
            game.StarterGui:SetCore("SendNotification", {
                Title = "JCloud Hub",
                Text = "Teleported to " .. Value,
                Duration = 3
            })
        end,
    })
end

-- Long text label to demonstrate UI scrolling behaviour.
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox("Information")
LeftGroupBox2:AddLabel(
	"This feature should be used responsibly to avoid being banned by Roblox admins or staff.\n\nSIRENHUB 2025",
	true
)

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()