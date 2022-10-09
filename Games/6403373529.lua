if getgenv().Rogue_AlreadyLoaded ~= nil then error("Rogue Hub was already found running or you have other scripts executed!") return else getgenv().Rogue_AlreadyLoaded = 0 end

if game.PlaceId == 6403373529 or game.PlaceId == 9015014224 or game.PlaceId == 9431156611 then else return end

-- easter egg moment
if syn then
  print("DohmBoy is cool!")
end

local teleportFunc = queueonteleport or queue_on_teleport or syn and syn.queue_on_teleport

if teleportFunc then
    teleportFunc([[loadstring(game:HttpGet("https://raw.githubusercontent.com/Kitzoon/Rogue-Hub/main/Main.lua", true))()]])
end

-- walkspeed anticheat bypass for slap royale
if game.PlaceId == 9431156611 and getrawmetatable then
    local gmt = getrawmetatable(game)
    local oldNamecall = gmt.__namecall

    setreadonly(gmt, false)

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if tostring(self) == "WS" and tostring(method) == "FireServer" then
            return
        end

        return oldNamecall(self, ...)
    end)

    setreadonly(gmt, true)
end

local sound = Instance.new("Sound")
sound.Parent = game:GetService("Workspace")
sound.SoundId = "rbxassetid://1548304764"
sound.PlayOnRemove = true
sound.Volume = 0.5

local Config = {
    WindowName = "Rogue Hub | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Color = Color3.fromRGB(30,30,30),
    Keybind = Enum.KeyCode.RightControl
}

local localPlr = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()
local window = library:CreateWindow(Config, game:GetService("CoreGui"))
local mainTab = window:CreateTab("Main")

window:ChangeColor(Color3.fromRGB(201,144,150))

getgenv().settings = {
    gloveExtend = false,
    extendOption = "Meat Stick",
    autoClicker = false,
    autoToxic = false,
    walkSpeed = 20,
    jumpPower = 50,
    noRagdoll = false,
    noReaper = false,
    noTimestop = false,
    noRock = false,
    autoJoin = false,
    joinOption = "Normal Arena",
    noVoid = false,
    auraSlap = false,
    auraOption = "Legit",
    voidRainbow = false,
    voidForce = false,
    playerForce = false,
    fov = 70,
    spamFart = false,
    spin = false,
    spinSpeed = 10,
    autoEquip = false,
    wallNoclip = false
}

if makefolder and isfolder and not isfolder("Rogue Hub") then
    makefolder("Rogue Hub")

    makefolder("Rogue Hub/Configs")
    makefolder("Rogue Hub/Data")
end

if readfile and isfile and isfile("Rogue Hub/Configs/SlapBattles_Config.ROGUEHUB") then
    getgenv().settings = game:GetService("HttpService"):JSONDecode(readfile("Rogue Hub/Configs/SlapBattles_Config.ROGUEHUB"))
end

local function saveSettings()
    if writefile then
        writefile("Rogue Hub/Configs/SlapBattles_Config.ROGUEHUB", game:GetService("HttpService"):JSONEncode(getgenv().settings))
    end
end

function getQuote()
    local userQuotes = game:GetService("HttpService"):JSONDecode(readfile("/Rogue Hub/Configs/Quotes.ROGUEHUB"))
    return userQuotes[math.random(#userQuotes)]
end

local function getTool()
    local tool = localPlr.Character:FindFirstChildOfClass("Tool") or localPlr:WaitForChild("Backpack"):FindFirstChildOfClass("Tool")

    if tool ~= nil and tool:FindFirstChild("Glove") ~= nil then
        return tool
    end
end

localPlr.CharacterAdded:Connect(function()
    local humanoid = localPlr.Character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = getgenv().settings.walkSpeed or 20
    humanoid.JumpPower = getgenv().settings.jumpPower or 50

    task.wait(3)

    if getgenv().settings.noRagdoll then
        if localPlr.Character.HumanoidRootPart == nil then return end

        localPlr.Character.Ragdolled:GetPropertyChangedSignal("Value"):Connect(function()
            if localPlr.Character.HumanoidRootPart == nil or getgenv().settings.noRagdoll == false then return end

            local oldCFrame = localPlr.Character.HumanoidRootPart.CFrame

            pcall(function()
                repeat task.wait()
                    localPlr.Character.HumanoidRootPart.CFrame = oldCFrame
                until localPlr.Character.Ragdolled.Value == false or localPlr.Character == nil or localPlr.Character.HumanoidRootPart == nil
            end)
        end)
    end

    if getgenv().settings.noReaper then
        localPlr.Character.ChildAdded:Connect(function(child)
            if child.Name == "DeathMark" and child:IsA("StringValue") then
                game:GetService("ReplicatedStorage").ReaperGone:FireServer(child)
                game:GetService("Lighting"):WaitForChild("DeathMarkColorCorrection"):Destroy()
                child:Destroy()
            end
        end)
    end

    if getgenv().settings.wallNoclip then
        localPlr.Character:FindFirstChild("HumanoidRootPart").Touched:Connect(function(part)
            if part.Name == "wall" and getgenv().settings.wallNoclip then
                part.CanCollide = not getgenv().settings.wallNoclip
            end
        end)
    end

    repeat task.wait() until getTool() ~= nil

    if getgenv().settings.auraSlap and getgenv().settings.auraOption == "Legit" then
        getTool().Glove.Touched:Connect(function(part)
            if part.Parent:FindFirstChildOfClass("Humanoid") and getgenv().settings.auraSlap and getgenv().settings.auraOption == "Legit" then
                getTool():Activate()
                task.wait(0.3)
            end
        end)
    end
end)

-- Player

local playerSec = mainTab:CreateSection("Player")

playerSec:CreateToggle("Autoclicker", getgenv().settings.autoClicker or false, function(bool)
    getgenv().settings.autoClicker = bool
    saveSettings()
end)

if game.PlaceId ~= 9431156611 then
    local toxicTog = playerSec:CreateToggle("Auto Toxic", getgenv().settings.autoToxic or false, function(bool)
        getgenv().settings.autoToxic = bool
        saveSettings()

        if getgenv().settings.autoToxic then
            localPlr.leaderstats.Slaps:GetPropertyChangedSignal("Value"):Connect(function()
                if not getgenv().settings.autoToxic then return end

                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(getQuote(), "All")
            end)
        end
    end)

    toxicTog:AddToolTip("automatically says a toxic phrase when you slap someone")
end

local noRagTog = playerSec:CreateToggle("Anti Ragdoll", getgenv().settings.noRagdoll or false, function(bool)
    getgenv().settings.noRagdoll = bool
    saveSettings()

    if getgenv().settings.noRagdoll and localPlr.Character:FindFirstChildOfClass("Humanoid") then
        localPlr.Character.Ragdolled:GetPropertyChangedSignal("Value"):Connect(function()
            if localPlr.Character:FindFirstChild("HumanoidRootPart") then
                if localPlr.Character.HumanoidRootPart == nil or getgenv().settings.noRagdoll == false then return end

                local oldCFrame = localPlr.Character.HumanoidRootPart.CFrame

                repeat task.wait()
                    if localPlr.Character:FindFirstChild("HumanoidRootPart") then
                        localPlr.Character.HumanoidRootPart.CFrame = oldCFrame
                    end
                until localPlr.Character:FindFirstChild("HumanoidRootPart") == nil or localPlr.Character.Ragdolled.Value == false
            end
        end)
    end
end)

noRagTog:AddToolTip("looks clunky, but works good")

if game.PlaceId ~= 9431156611 then
    local reaperGod = playerSec:CreateToggle("Reaper Godmode", getgenv().settings.noReaper or false, function(bool)
        getgenv().settings.noReaper = bool
        saveSettings()

        if getgenv().settings.noReaper and localPlr.Character:FindFirstChildOfClass("Humanoid") then
            for _, v in next, localPlr.Character:GetChildren() do
                if v.Name == "DeathMark" and v:IsA("StringValue") then
                    game:GetService("ReplicatedStorage").ReaperGone:FireServer(v)
                    game:GetService("Lighting"):WaitForChild("DeathMarkColorCorrection"):Destroy()
                    v:Destroy()
                end
            end

            localPlr.Character.ChildAdded:Connect(function(child)
                if child.Name == "DeathMark" and child:IsA("StringValue") then
                    game:GetService("ReplicatedStorage").ReaperGone:FireServer(child)
                    game:GetService("Lighting"):WaitForChild("DeathMarkColorCorrection"):Destroy()
                    child:Destroy()
                end
            end)
        end
    end)

    reaperGod:AddToolTip("immune from the reaper death ability")

    local rockGod = playerSec:CreateToggle("Rock Godmode", getgenv().settings.noRock or false, function(bool)
        getgenv().settings.noRock = bool
        saveSettings()

        if getgenv().settings.noRock then
            for _, target in pairs(game:GetService("Players"):GetPlayers()) do
                if target.Character ~= nil and target.Character:FindFirstChild("rock") and target.Character.rock:FindFirstChild("TouchInterest") then
                    target.Character:FindFirstChild("rock").TouchInterest:Destroy()
                end
            end
        end
    end)

    rockGod:AddToolTip("immune from dangerous rocks! sometimes works, sometimes doesnt")

    local noClipWall = playerSec:CreateToggle("Giant Wall Noclip", getgenv().settings.wallNoclip or false, function(bool)
        getgenv().settings.wallNoclip = bool
        saveSettings()

        if getgenv().settings.wallNoclip then
            localPlr.Character:FindFirstChild("HumanoidRootPart").Touched:Connect(function(part)
                if part.Name == "wall" and getgenv().settings.wallNoclip then
                    part.CanCollide = not getgenv().settings.wallNoclip
                end
            end)
        end
    end)

    noClipWall:AddToolTip("clip's through the giant wall ability.")

    playerSec:CreateToggle("Move in Timestop & Cutscenes", getgenv().settings.noTimestop or false, function(bool)
        getgenv().settings.noTimestop = bool
        saveSettings()
    end)

    playerSec:CreateToggle("Anti Void", getgenv().settings.noVoid or false, function(bool)
        getgenv().settings.noVoid = bool
        game:GetService("Workspace").dedBarrier.CanCollide = getgenv().settings.noVoid
        saveSettings()
    end)

    game:GetService("Workspace").dedBarrier.CanCollide = getgenv().settings.noVoid or false
end

local spinTog = playerSec:CreateToggle("Spin", getgenv().settings.spin or false, function(bool)
    getgenv().settings.spin = bool
    saveSettings()
end)

spinTog:AddToolTip("Makes your player spin around, looks derpy :D")

playerSec:CreateSlider("Spin Speed", 10,100,getgenv().settings.spinSpeed or 10,true, function(value)
	getgenv().settings.spinSpeed = value
	saveSettings()
end)

playerSec:CreateSlider("Walk Speed", 20,50,getgenv().settings.walkSpeed or 20,true, function(value)
	getgenv().settings.walkSpeed = value
    localPlr.Character.Humanoid.WalkSpeed = getgenv().settings.walkSpeed
	saveSettings()
end)

playerSec:CreateSlider("Jump Power", 50,100,getgenv().settings.jumpPower or 50,true, function(value)
	getgenv().settings.jumpPower = value
	localPlr.Character.Humanoid.JumpPower = getgenv().settings.jumpPower
	saveSettings()
end)

-- Glove

local gloveSec = mainTab:CreateSection("Glove")

if game.PlaceId ~= 9431156611 then
    local farmTog = gloveSec:CreateToggle("Slap Farm", false, function(bool)
        getgenv().slapFarm = bool

        while task.wait() and getgenv().slapFarm do
            if game.PlaceId ~= 9431156611 then
                for _, target in next, game:GetService("Players"):GetPlayers() do
                    if target ~= localPlr and target.Character ~= nil and target.Character:FindFirstChild("entered") ~= nil and localPlr.Character:FindFirstChild("entered") ~= nil and target.Character:FindFirstChild("rock") == nil and target.Character:FindFirstChild("Ragdolled").Value == false and target.Character:FindFirstChild("Reverse") == nil and target.Character:FindFirstChild("Right Arm") and target.Character:FindFirstChild("Error") == nil and target.Character:FindFirstChild("Orbit") == nil and target.Character:FindFirstChild("Spectator") == nil and target.Backpack:FindFirstChild("Spectator") == nil and getgenv().slapFarm then
                        if getTool() ~= nil and getTool().Name == "Default" and getgenv().slapFarm then
                            localPlr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,15,0)
                            wait(0.3)
                            game:GetService("ReplicatedStorage").b:FireServer(target.Character["Right Arm"])
                        elseif getTool() ~= nil and getTool().Name == "Bull" and getgenv().slapFarm then
                            localPlr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,15,0)
                            wait(0.3)
                            game:GetService("ReplicatedStorage").BullHit:FireServer(target.Character["Right Arm"])
                        elseif getTool() ~= nil and getTool().Name ~= "Default" and getgenv().slapFarm then
                            localPlr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3.5)
                            wait(0.3)
                            getTool():Activate()
                        end

                        wait(0.3)
                    end
                end
            else
                for _, target in next, game:GetService("Players"):GetPlayers() do
                    if target.Character ~= nil and target.Character:FindFirstChild("inMatch").Value and localPlr.Character:FindFirstChild("inMatch").Value and target.Character:FindFirstChild("Ragdolled").Value == false and target.Character:FindFirstChild("Right Arm") and getgenv().slapFarm then
                        if getTool() ~= nil and getTool().Name == "Pack-A-Punch" and getgenv().slapFarm then
                            localPlr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,15,0)
                            game:GetService("ReplicatedStorage").Events.Slap:FireServer(target.Character["Right Arm"])
                        elseif getTool() ~= nil and getTool().Name ~= "Pack-A-Punch" and getgenv().slapFarm then
                            localPlr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3.5)
                            getTool():Activate()
                        end
                    end
                end
            end
        end
    end)

    farmTog:AddToolTip("Auto farm slaps, works best when paired with auto join (ban warning from mods)")
end

if game.PlaceId ~= 9431156611 then
    local fartTog = gloveSec:CreateToggle("Fart Spam", getgenv().settings.spamFart or false, function(bool)
        getgenv().settings.spamFart = bool
        saveSettings()
    end)

    fartTog:AddToolTip("no explanation needed, only works for the default glove")
end

local equip = gloveSec:CreateToggle("Auto Equip", getgenv().settings.autoEquip or false, function(bool)
    getgenv().settings.autoEquip = bool
    saveSettings()
end)

equip:AddToolTip("Automatically equips when you left click and your glove is not equipped.")

localPlr:GetMouse().Button1Down:Connect(function()
    if getgenv().settings.autoEquip and localPlr.Character:FindFirstChild("entered") ~= nil and localPlr:WaitForChild("Backpack"):FindFirstChildOfClass("Tool") ~= nil then
        localPlr.Character.Humanoid:EquipTool(getTool())
        getTool():Activate()
    end
end)

gloveSec:CreateToggle("Glove Extender", getgenv().settings.gloveExtend or false, function(bool)
    getgenv().settings.gloveExtend = bool
    saveSettings()
end)

local extendDrop = gloveSec:CreateDropdown("Extender Type", {"Meat Stick","Pancake", "Growth", "Slight Extend"}, function(option)
	getgenv().settings.extendOption = option
	saveSettings()
end)

extendDrop:SetOption(getgenv().settings.extendOption or "Meat Stick")

if game.PlaceId ~= 9431156611 then
    -- Auto Join
    local joinSec = mainTab:CreateSection("Auto Join")

    local autoEnabled = joinSec:CreateToggle("Enabled", getgenv().settings.autoJoin or false, function(bool)
        getgenv().settings.autoJoin = bool
        saveSettings()
    end)

    autoEnabled:AddToolTip("Automatically join an arena of your choice.")

    local joinDrop = joinSec:CreateDropdown("Auto join in:", {"Normal Arena","Default Only Arena"}, function(option)
    	getgenv().settings.joinOption = option
    	saveSettings()
    end)

    joinDrop:SetOption(getgenv().settings.joinOption or "Normal Arena")
end

-- Slap aura

local auraSec = mainTab:CreateSection("Slap Aura")

auraSec:CreateToggle("Enabled", getgenv().settings.auraSlap or false, function(bool)
    getgenv().settings.auraSlap = bool
    saveSettings()

    while getTool() == nil and wait() do return end

    if getgenv().settings.auraSlap and getgenv().settings.auraOption == "Legit" then
        getTool().Glove.Touched:Connect(function(part)
            if part.Parent:FindFirstChildOfClass("Humanoid") and getgenv().settings.auraSlap and getgenv().settings.auraOption == "Legit" and not getgenv().slapFarm then
                getTool():Activate()
                task.wait(0.3)
            end
        end)
    end
end)

local auraDrop = auraSec:CreateDropdown("Type", {"Legit","Blatant"}, function(option)
	getgenv().settings.auraOption = option
	saveSettings()

	if getgenv().settings.auraOption == "Blatant" then
	    if game.PlaceId ~= 9431156611 then
    	    game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rogue Hub Note",
                Text = "Blatant Type only works on the default glove, use legit for any glove type.",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rogue Hub Note",
                Text = "Blatant Type only works on the Pack-A-Punch glove, use legit for any glove type.",
                Duration = 5
            })
        end
	end
end)

auraDrop:SetOption(getgenv().settings.auraOption or "Blatant")

-- Visuals

local visualSec = mainTab:CreateSection("Visuals")

if game.PlaceId ~= 9431156611 then
    local rainbowVoidTog = visualSec:CreateToggle("Rainbow Void", getgenv().settings.voidRainbow or false, function(bool)
        getgenv().settings.voidRainbow = bool
        saveSettings()
    end)

    rainbowVoidTog:AddToolTip("changes the void's color to rainbow")

    local forceVoidTog = visualSec:CreateToggle("ForceField Void", getgenv().settings.voidForce or false, function(bool)
        getgenv().settings.voidForce = bool
        saveSettings()
    end)

    forceVoidTog:AddToolTip("changes the void's material to a forcefield")
end

local forcePlayerTog = visualSec:CreateToggle("ForceField Player", getgenv().settings.playerForce or false, function(bool)
    getgenv().settings.playerForce = bool
    saveSettings()
end)

forcePlayerTog:AddToolTip("changes your player's material to a forcefield")

local fov = getgenv().settings.fov or 70

local fovSlider = visualSec:CreateSlider("Field of View", 70,120,fov,true, function(value)
	getgenv().settings.fov = value
	game:GetService("Workspace").CurrentCamera.FieldOfView = getgenv().settings.fov
    fov = value
	saveSettings()
end)

fovSlider:AddToolTip("changes the camera's FOV")

local NoCamEffects = visualSec:CreateButton("Disable Camera Effects", function()
    game.Workspace.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        game.Workspace.CurrentCamera.FieldOfView = fov
    end)

    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("CameraOffset"):Connect(function()
           game.Players.LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0,0,0)
        end)
    end

    game.Players.LocalPlayer.CharacterAdded:Connect(function(Character)
        Character.Humanoid:GetPropertyChangedSignal("CameraOffset"):Connect(function()
           Character.Humanoid.CameraOffset = Vector3.new(0,0,0)
        end)
    end)

    for i,v in ipairs(game.ReplicatedStorage:GetChildren()) do
       if v.Name:match("Screenshake") then
            for _, connection in ipairs(getconnections(v.OnClientEvent)) do
                connection:Disable()
            end
        end
    end
end)

NoCamEffects:AddToolTip("Removes all of the games built in camera FOV and camera shake effects")
-- Info

local infoTab = window:CreateTab("Extra")
local uiSec = infoTab:CreateSection("UI Settings")

local uiColor = uiSec:CreateColorpicker("UI Color", function(color)
	window:ChangeColor(color)
end)

uiColor:UpdateColor(Config.Color)

local uiTog = uiSec:CreateToggle("UI Toggle", nil, function(bool)
	window:Toggle(bool)
end)

uiTog:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(key)
	if key == "Escape" or key == "Backspace" then key = "NONE" end

    if key == "NONE" then return else Config.Keybind = Enum.KeyCode[key] end
end)

uiTog:SetState(true)

local uiRainbow = uiSec:CreateToggle("Rainbow UI", nil, function(bool)
	getgenv().rainbowUI = bool

    while getgenv().rainbowUI and task.wait() do
        local hue = tick() % 10 / 10
        local rainbow = Color3.fromHSV(hue, 1, 1)

        window:ChangeColor(rainbow)
        uiColor:UpdateColor(rainbow)
    end
end)

local infoSec = infoTab:CreateSection("Credits")

local req = http_request or request or syn.request

infoSec:CreateButton("Father of Rogue Hub: Kitzoon#7750", function()
    setclipboard("Kitzoon#7750")

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rogue Hub Note",
        Text = "Copied Kitzoon's discord username and tag to your clipboard.",
        Duration = 5
    })
end)

infoSec:CreateButton("Help with a lot: Kyron#6083", function()
    setclipboard("Kyron#6083")

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Notification",
        Text = "Copied Kyron's discord username and tag to your clipboard.",
        Duration = 5
    })
end)

infoSec:CreateButton("Join us on discord!", function()
	if req then
        req({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json",
                ["origin"] = "https://discord.com",
            },

            Body = game:GetService("HttpService"):JSONEncode(
            {
                ["args"] = {
                ["code"] = "VdrHU8KP7c",
                },

                ["cmd"] = "INVITE_BROWSER",
                ["nonce"] = "."
            })
        })
    else
        setclipboard("https://discord.gg/VdrHU8KP7c")

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Rogue Hub Note",
            Text = "Copied our discord server to your clipboard.",
            Duration = 5
        })
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if game.PlaceId ~= 9431156611 and localPlr ~= nil and getTool() ~= nil and localPlr.Character:FindFirstChild("entered") ~= nil or game.PlaceId == 9431156611 and localPlr ~= nil and getTool() ~= nil and localPlr.Character:FindFirstChild("inMatch").Value then
        if getgenv().settings.gloveExtend and getgenv().settings.extendOption == "Meat Stick" and getTool():FindFirstChild("Glove").Size ~= Vector3.new(0, 25, 2) then
            getTool().Glove.Transparency = 0.5
            getTool().Glove.Size = Vector3.new(0, 25, 2)
        elseif getgenv().settings.gloveExtend and getgenv().settings.extendOption == "Pancake" and getTool():FindFirstChild("Glove").Size ~= Vector3.new(0, 25, 25) then
            getTool().Glove.Transparency = 0.5
            getTool().Glove.Size = Vector3.new(0, 25, 25)
        elseif getgenv().settings.gloveExtend and getgenv().settings.extendOption == "Growth" and getTool():FindFirstChild("Glove").Size ~= Vector3.new(25, 25, 25) then
            getTool().Glove.Transparency = 0.5
            getTool().Glove.Size = Vector3.new(25, 25, 25)
        elseif getgenv().settings.gloveExtend and getgenv().settings.extendOption == "Slight Extend" and getTool():FindFirstChild("Glove").Size ~= Vector3.new(0, 3.5, 2) then
            getTool().Glove.Transparency = 0
            getTool().Glove.Size = Vector3.new(2.5, 3.5, 2)
        elseif getgenv().settings.gloveExtend == false then
            getTool().Glove.Transparency = 0
            getTool().Glove.Size = Vector3.new(2.5, 2.5, 1.7)
        end

        if getgenv().settings.autoClicker and not getgenv().slapFarm then
            getTool():Activate()
        end

        if getgenv().settings.noTimestop then
            for _, v in next, localPlr.Character:GetChildren() do
                if v:IsA("Part") or v:IsA("MeshPart") and v.Anchored then
                    v.Anchored = false
                end
            end
        end

        if getgenv().settings.auraSlap and getgenv().settings.auraOption == "Blatant" and not getgenv().slapFarm then
            if game.PlaceId ~= 9431156611 then
                for _, target in next, game:GetService("Players"):GetPlayers() do
                    if target.Character and target.Character:FindFirstChild("Humanoid") ~= nil and target.Character:FindFirstChild("rock") == nil and target.Character:FindFirstChild("Reverse") == nil and getgenv().settings.auraOption == "Blatant" and target:DistanceFromCharacter(localPlr.Character.HumanoidRootPart.Position) <= 20 and getTool().Name == "Default" then
                        game:GetService("ReplicatedStorage").b:FireServer(target.Character.HumanoidRootPart)
                    end
                end
            else
                for _, target in next, game:GetService("Players"):GetPlayers() do
                    if target.Character and target.Character:FindFirstChild("Humanoid") ~= nil and getgenv().settings.auraOption == "Blatant" and target:DistanceFromCharacter(localPlr.Character.HumanoidRootPart.Position) <= 20 and getTool().Name == "Pack-A-Punch" then
                        game:GetService("ReplicatedStorage").Events.Slap:FireServer(target.Character.HumanoidRootPart)
                    end
                end
            end
        end

        if getgenv().settings.noRock and game.PlaceId ~= 9431156611 then
            for _, target in next, game:GetService("Players"):GetPlayers() do
                if target.Character ~= nil and target.Character:FindFirstChild("rock") and target.Character.rock:FindFirstChild("TouchInterest") then
                    target.Character:FindFirstChild("rock").TouchInterest:Destroy()
                end
            end
        end

        if getgenv().settings.playerForce then
            for _, v in next, localPlr.Character:GetChildren() do
                if v:IsA("Part") or v:IsA("MeshPart") then
                    v.Material = "ForceField"
                end
            end
        else
            for _, v in next, localPlr.Character:GetChildren() do
                if v:IsA("Part") or v:IsA("MeshPart") then
                    v.Material = "Plastic"
                end
            end
        end

        if getgenv().settings.spamFart and getTool().Name == "Default" then
            game:GetService("ReplicatedStorage").Fart:FireServer()
        end

        if getgenv().settings.spin and localPlr:GetMouse().Icon ~= "rbxasset://textures/MouseLockedCursor.png" and not getgenv().slapFarm then
            localPlr.Character.HumanoidRootPart.CFrame = localPlr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(getgenv().settings.spinSpeed), 0)
        end
    end

    if getgenv().settings.autoJoin and getgenv().settings.joinOption == "Normal Arena" then
        if game.PlaceId == 9431156611 then return end

        if not localPlr.Character:FindFirstChild("entered") and localPlr.Character:FindFirstChild("HumanoidRootPart") then
            repeat wait(0.5)
                firetouchinterest(localPlr.Character.HumanoidRootPart, game:GetService("Workspace").Lobby.Teleport1, 0)
                firetouchinterest(localPlr.Character.HumanoidRootPart, game:GetService("Workspace").Lobby.Teleport1, 1)
            until localPlr.Character:FindFirstChild("entered") ~= nil
        end
    elseif getgenv().settings.autoJoin and getgenv().settings.joinOption == "Default Only Arena" then
        if game.PlaceId == 9431156611 then return end

        if not localPlr.Character:FindFirstChild("entered") and localPlr.Character:FindFirstChild("HumanoidRootPart") then
            firetouchinterest(localPlr.Character.HumanoidRootPart, game:GetService("Workspace").Lobby.Teleport2, 0)
            firetouchinterest(localPlr.Character.HumanoidRootPart, game:GetService("Workspace").Lobby.Teleport2, 1)
        end
    end

    if getgenv().settings.voidRainbow and game.PlaceId ~= 9431156611 then
        local hue = tick() % 10 / 10
        local rainbow = Color3.fromHSV(hue, 1, 1)

        game:GetService("Workspace").dedBarrier.Transparency = 0
        game:GetService("Workspace").dedBarrier.Color = rainbow
    else
        if game.PlaceId == 9431156611 then return end

        if not getgenv().settings.voidForce then
            game:GetService("Workspace").dedBarrier.Transparency = 1
        end

        game:GetService("Workspace").dedBarrier.Color = Color3.fromRGB(163, 162, 165)
    end

    if getgenv().settings.voidForce and game.PlaceId ~= 9431156611 then
        game:GetService("Workspace").dedBarrier.Transparency = 0
        game:GetService("Workspace").dedBarrier.Material = "ForceField"
    else
        if game.PlaceId == 9431156611 then return end

        if not getgenv().settings.voidRainbow then
            game:GetService("Workspace").dedBarrier.Transparency = 1
        end

        game:GetService("Workspace").dedBarrier.Material = "Plastic"
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Rogue Hub Message",
    Text = "Successfully loaded.",
    Duration = 5
})

sound:Destroy()

task.wait(5)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Please Note",
    Text = "The rogue hub version you are using is currently in alpha, bugs may occur.",
    Duration = 10
})

while getTool() == nil and wait() do return end

if getgenv().settings.auraSlap and getgenv().settings.auraOption == "Legit" then
    getTool().Glove.Touched:Connect(function(part)
        if part.Parent:FindFirstChildOfClass("Humanoid") and getgenv().settings.auraSlap and getgenv().settings.auraOption == "Legit" then
            getTool():Activate()
            task.wait(0.3)
        end
    end)
end
