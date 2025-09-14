local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "SIRENHUB",
    Footer = "Version: 1.0.0", --small text in the bottom of page
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true,
    Resizable = false, --not rezizeable
    Size = UDim2.fromOffset(700, 500) -- size of ui
})

local KeyTab = Window:AddKeyTab("Login") -- use addkeytab because this will be for our key box
local InfoTab = Window:AddTab("Info", "info") -- this will be for how to get key
local Analytics = game:GetService("RbxAnalyticsService")
local HttpService = game:GetService("HttpService")
local hwid = Analytics:GetClientId()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local username = player and player.Name or "Unknown"
local userid = player and player.UserId or "Unknown"


KeyTab:AddLabel({
	Text = "Welcome To\nSIRENHUB",
	DoesWrap = true,
	Size = 36,
})

local function ValidateKey(Key)
    local Url = "https://sirenpedia.site/check.php?key=" .. Key .. "&hwid=" .. hwid

    local success, response = pcall(function()
        return game:HttpGet(Url, true)
    end)

    if not success then
        return false, "HTTP Request failed"
    end

    local decoded
    local ok, err = pcall(function()
        decoded = HttpService:JSONDecode(response)
    end)

    if not ok then
        return false, "Invalid JSON response"
    end

    if decoded.success then
        return true, decoded
    else
        return false, decoded.message or "Key invalid"
    end
end

-- Mengubah bagian AddKeyBox
KeyTab:AddKeyBox(function(Success, RecivedKey)
    -- RecivedKey adalah input user dari TextBox
    local isValid, dataOrMsg = ValidateKey(RecivedKey)

    if isValid then
        Library:Notify("Correct Key!", 5) 
        task.delay(1, function()
            Library:Unload()  
            loadstring(game:HttpGet("https://raw.githubusercontent.com/apies13/sirenhub/refs/heads/main/SIRENMenu.lua?token=GHSAT0AAAAAADLE2XYJVFHLC6BG2YBXAZJC2GHCZPQ", true))()
        end)
    else
        Library:Notify("Incorrect Key! " .. tostring(dataOrMsg), 5) 
    end
end)



KeyTab:AddButton({
    Text = "Don't have the key? Go to the <font color='rgb(0, 195, 255)'>Info</font> Tab!",
    Func = function()
        -- buka tab Info
        Window:SelectTab(InfoTab)
    end,
    DoubleClick = false
})


local LeftGroupbox = InfoTab:AddLeftGroupbox("How To Get Key", "key")

local WrappedLabel = LeftGroupbox:AddLabel({
    Text = "You can get a key in two ways:\n\n1️⃣ Buy a key from authorized sellers.\n2️⃣ Get a free key valid for 10 minutes with limited features.\n\nUse the buttons below to copy key links or access the free trial! (Note: copying only prints the key link here in this demo)",
    DoesWrap = true
})

local Button = LeftGroupbox:AddButton({
    Text = "<font color='rgb(0, 123, 255)'>Discord</font>",
    Func = function()
        print("Copied Discord link: https://dsc.gg/sirenhub")
        setclipboard("https://dsc.gg/sirenhub") -- optional, jika mau auto-copy
    end,
    DoubleClick = false
})

-- OPTIONAL: Additional button for Linktree
Button:AddButton({
    Text = "<font color='rgb(255, 165, 0)'>Linktree</font>",
    Func = function()
        print("Copied Linktree link: https://linktr.ee/sirenhub")
        setclipboard("https://linktr.ee/sirenhub") -- optional, jika mau auto-copy
    end
})


local RightGroupbox = InfoTab:AddRightGroupbox("Your Information", "info")

RightGroupbox:AddLabel({
    Text = "Your HWID :\n" .. hwid .. "\n\nYour Roblox Username :\n" .. username .. "\n\nYour Roblox UserId :\n" .. tostring(userid),
    DoesWrap = true
})

local Button = RightGroupbox:AddButton({
    Text = "Copy HWID",
    Func = function()
        setclipboard(hwid)
        Library:Notify("HWID copied to clipboard!", 5)
    end,
    DoubleClick = false
})

local Button = RightGroupbox:AddButton({
    Text = "Copy Username",
    Func = function()
        setclipboard(username)
        Library:Notify("Username copied to clipboard!", 5)
    end,
    DoubleClick = false
})

local Button = RightGroupbox:AddButton({
    Text = "Copy RobloxID",
    Func = function()
        setclipboard(userid)
        Library:Notify("RobloxID copied to clipboard!", 5)
    end,
    DoubleClick = false
})


local UIGroupbox = InfoTab:AddLeftGroupbox("Menu", "settings")

local KeyLabel = UIGroupbox:AddLabel("Menu Bind") --creates a label to attach keybind since it cant be standalone

local Keybind = KeyLabel:AddKeyPicker("MyKeybind", {
    Default = "K",
    Text = "Menu Bind",
    Mode = "Toggle", -- Options: "Toggle", "Hold", "Always"
    
    -- Sets the toggle's value according to the keybind state if Mode is Toggle
    SyncToggleState = false,
    
    Callback = function(Value)
        Library:Unload()
    end
})

local Button = UIGroupbox:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})