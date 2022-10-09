-- hi murder mystery a owner aka crafty ik your here looking to patch shit up :D

if getgenv().Rogue_AlreadyLoaded ~= nil then error("Rogue Hub was already found running or you have other scripts executed!") return else getgenv().Rogue_AlreadyLoaded = 0 end

if game.PlaceId ~= 8227619186 then return end

local func
local exploitFunction = isexecutorclosure or is_synapse_function or is_exploit_function

if getgc and hookfunction and exploitFunction then
    for _, garbage in ipairs(getgc()) do
        if type(garbage) == "function" and not exploitFunction(garbage) and debug.getinfo(garbage).name == "kick" then
            func = garbage
            task.wait()
        end
    end
    
    hookfunction(func, function() end)
end

local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://1548304764"
sound.PlayOnRemove = true
sound.Volume = 0.5

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("AntiCore") then game:GetService("Players").LocalPlayer.PlayerGui.AntiCore:Destroy() end
if game:GetService("StarterGui"):FindFirstChild("AntiCore") then game:GetService("StarterGui").AntiCore:Destroy() end

local Config = {
    WindowName = "Rogue Hub | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Color = Color3.fromRGB(201,144,150),
    Keybind = Enum.KeyCode.RightControl
}

getgenv().settings = {
    murderESP = false,
    sherifESP = false,
    auraKnife = false,
    spamLoop = false,
    revolverAim = false,
    autoSnitch = false,
    autoMurder = false,
    guntog = false,
    gemtog = false,
    message = "Leading a new way to exploit - Rogue Hub",
    walkSpeed = 16,
    jumpPower = 50,
    playerForce = false,
    infJump = false,
    noSnitch = false,
    fov = 70
}

if makefolder and isfolder and not isfolder("Rogue Hub") then
    makefolder("Rogue Hub")
    
    makefolder("Rogue Hub/Configs")
    makefolder("Rogue Hub/Data")
end

if readfile and isfile and isfile("Rogue Hub/Configs/MurderMysteryA_Config.ROGUEHUB") then
    getgenv().settings = game:GetService("HttpService"):JSONDecode(readfile("Rogue Hub/Configs/MurderMysteryA_Config.ROGUEHUB"))
end

local function saveSettings()
    if writefile then
        writefile("Rogue Hub/Configs/MurderMysteryA_Config.ROGUEHUB", game:GetService("HttpService"):JSONEncode(getgenv().settings))
    end
end

local localPlr = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/bracket"))()
local window = library:CreateWindow(Config, game:GetService("CoreGui"))
local mainTab = window:CreateTab("Main")

local function espCreate(object, guiText, guiColor)
    local billboard = Instance.new("BillboardGui", object.Parent)
    billboard.Adornee = object
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0,6,0,6)
    
    local text = Instance.new("TextLabel", billboard)
    text.Text = guiText
    text.Font = "Ubuntu"
    text.TextSize = 16
    text.TextColor3 = guiColor
    text.TextStrokeTransparency = 0
    text.BackgroundTransparency = 1
    
    text.AnchorPoint = Vector2.new(0.5, 0.5)
    text.Size = UDim2.new(0,98,0,78)
end

local function espDelete(objectPath)
    for _,v in ipairs(objectPath:GetChildren()) do
        if v:IsA("BillboardGui") then
            v:Destroy()    
        end
    end
end

local function findMurder()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= nil and player.Character ~= nil and player:WaitForChild("Backpack"):FindFirstChild("Knife") ~= nil or player.Character:FindFirstChild("Knife") ~= nil then
            return player
        end
    end
end

local function findSheriff()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= nil and player.Character ~= nil and player:WaitForChild("Backpack"):FindFirstChild("Revolver") ~= nil or player.Character:FindFirstChild("Revolver") ~= nil then
            return player
        end
    end
end

localPlr.CharacterAdded:Connect(function()
    local humanoid = localPlr.Character:WaitForChild("Humanoid")
    
    humanoid.WalkSpeed = getgenv().settings.walkSpeed
    humanoid.JumpPower = getgenv().settings.jumpPower
end)

-- CODE TO EXECUTE WHEN THE ROUND HAS STARTED
localPlr.Settings.InRound.Changed:Connect(function()
    pcall(function()
        if localPlr.Settings.InRound.Value == false then return end
        
        wait(7)
        
        repeat wait() until findMurder() ~= nil
        
        if getgenv().settings.murderESP then
            espCreate(findMurder().Character:WaitForChild("Head"), findMurder().Name, Color3.fromRGB(255,90,90))
        end
        
        repeat wait() until findSheriff() ~= nil
        
        if getgenv().settings.sherifESP then
            espCreate(findSheriff().Character:WaitForChild("Head"), findSheriff().Name, Color3.fromRGB(110, 110, 255))
        end
        
        if getgenv().settings.autoSnitch then
            if getgenv().settings.noSnitch and findMurder() == localPlr then return end
            game:GetService("ReplicatedStorage").Interactions.Server.SendChatMessage:FireServer("Murderer is: " .. findMurder().Name)
            if getgenv().settings.noSnitch and findSheriff() == localPlr then return end
            game:GetService("ReplicatedStorage").Interactions.Server.SendChatMessage:FireServer("Sheriff is: " .. findSheriff().Name)
        end
        
        if getgenv().settings.autoMurder and findMurder() == localPlr then
            if localPlr:WaitForChild("Backpack"):FindFirstChild("Knife") then
                localPlr.Character:FindFirstChild("Humanoid"):EquipTool(localPlr.Backpack.Knife)
                
                task.wait(0.2)
            end
            
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player ~= localPlr and localPlr.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").Health ~= 0 and localPlr.Character:FindFirstChild("Humanoid") and localPlr.Character:FindFirstChild("Humanoid").Health ~= 0 and player.Settings.InRound.Value and findMurder() == localPlr then
                    local targetDied local localPlrDied
                    
                    player.Character.Humanoid.Died:Connect(function()
                        targetDied = true
                    end)
                    
                    localPlr.Character.Humanoid.Died:Connect(function()
                        localPlrDied = true
                    end)
                    
                    pcall(function()
                        repeat wait()
                            localPlr.Character:FindFirstChild("HumanoidRootPart").CFrame = player.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,1)
                            localPlr.Character:FindFirstChild("Knife").KnifeScript.ClientStab:FireServer()
                        until localPlrDied or targetDied or findMurder() ~= localPlr
                    end)
                end
            end
        end
    end)
end)

-- Player

local playerSec = mainTab:CreateSection("Player")

playerSec:CreateToggle("Infinite Jump", getgenv().settings.infJump or false, function(bool)
    getgenv().settings.infJump = bool
    saveSettings()
end)

local gemTog = playerSec:CreateToggle("Gems Farm", getgenv().settings.gemtog or false, function(bool)
    getgenv().settings.gemtog = bool
    saveSettings()
end)

gemTog:AddToolTip("Automatically grabs gems, useful for easily getting items.")

local grabRevTog = playerSec:CreateToggle("Auto Get Revolver", getgenv().settings.gemtog or false, function(bool)
    getgenv().settings.guntog = bool
    saveSettings()
end)

grabRevTog:AddToolTip("Automatically gets you the revolver when its avaliable.")

if getgc and hookfunction then
    playerSec:CreateSlider("Walkspeed", 16,200,getgenv().settings.walkSpeed or 16,true, function(value)
    	getgenv().settings.walkSpeed = value
    	localPlr.Character:WaitForChild("Humanoid").WalkSpeed = getgenv().settings.walkSpeed
    	
    	saveSettings()
    end)
    
    playerSec:CreateSlider("Jump Power", localPlr.Character.Humanoid.JumpPower,200,getgenv().settings.jumpPower or 50,true, function(value)
    	getgenv().settings.jumpPower = value
    	localPlr.Character:WaitForChild("Humanoid").JumpPower = getgenv().settings.jumpPower
    end)
end

playerSec:CreateButton("Reset", function()
    if localPlr.Character == nil then return end
    
    localPlr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
end)

local step = playerSec:CreateButton("Step Back", function()
    if localPlr.Character == nil then return end
    
    localPlr.Character.PrimaryPart.CFrame = localPlr.Character.PrimaryPart.CFrame * CFrame.new(0,0,15)
end)

step:AddToolTip("Steps back 15 studs, useful for getting away from murderers.")

-- Visuals

local visualSec = mainTab:CreateSection("Visuals")

visualSec:CreateToggle("Murderer ESP", getgenv().settings.murderESP or false, function(bool)
    getgenv().settings.murderESP = bool
    saveSettings()
    
    if findMurder() ~= nil and localPlr.Settings.InRound.Value and getgenv().settings.murderESP then
        espCreate(findMurder().Character:WaitForChild("Head"), findMurder().Name, Color3.fromRGB(255,90,90))
    elseif getgenv().settings.murderESP == false and findMurder() ~= nil then
        espDelete(findMurder().Character)
    end
end)

visualSec:CreateToggle("Sheriff ESP", getgenv().settings.sherifESP or false, function(bool)
    getgenv().settings.sherifESP = bool
    saveSettings()
    
    if findSheriff() ~= nil and localPlr.Settings.InRound.Value and getgenv().settings.sherifESP then
        espCreate(findSheriff().Character:WaitForChild("Head"), findSheriff().Name, Color3.fromRGB(110, 110, 255))
    elseif getgenv().settings.sherifESP == false and findSheriff() ~= nil then
        espDelete(findSheriff().Character)
    end
end)

visualSec:CreateToggle("Player Forcefield", getgenv().settings.playerForce or false, function(bool)
    getgenv().settings.playerForce = bool
    saveSettings()
end)

local fovSlider = visualSec:CreateSlider("Field of View", 70,120,getgenv().settings.fov or 70,true, function(value)
	getgenv().settings.fov = value
	workspace.CurrentCamera.FieldOfView = getgenv().settings.fov
	saveSettings()
end)

fovSlider:AddToolTip("changes the camera's FOV")

-- Fun

local funSec = mainTab:CreateSection("Fun")

local knifeAuraToggle = funSec:CreateToggle("Knife Aura", getgenv().settings.auraKnife or false, function(bool)
    getgenv().settings.auraKnife = bool
    saveSettings()
end)

knifeAuraToggle:AddToolTip("Automatically swings the knife when it collides with a player.")

local spamChat = funSec:CreateToggle("Chat Spam", getgenv().settings.spamLoop or false, function(bool)
    getgenv().settings.spamLoop = bool
    saveSettings()
end)

spamChat:AddToolTip("Constantly sends the same message in chat fast.")

funSec:CreateToggle("Auto Snitch on Roles", getgenv().settings.autoSnitch or false, function(bool)
    getgenv().settings.autoSnitch = bool
    saveSettings()
end)

funSec:CreateToggle("Don't Snitch on Self", getgenv().settings.noSnitch or false, function(bool)
    getgenv().settings.noSnitch = bool
    saveSettings()
end)

funSec:CreateToggle("Auto Murderer Kill All", getgenv().settings.autoMurder or false, function(bool)
    getgenv().settings.autoMurder = bool
    saveSettings()
end)

funSec:CreateButton("Murderer Kill All", function()
    if localPlr.Settings.InRound.Value ~= true or findMurder() ~= localPlr then return end
    
    if localPlr:WaitForChild("Backpack"):FindFirstChild("Knife") then
        localPlr.Character:FindFirstChild("Humanoid"):EquipTool(localPlr.Backpack.Knife)
        
        task.wait(0.2)
    end
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlr and localPlr.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").Health ~= 0 and localPlr.Character:FindFirstChild("Humanoid") and localPlr.Character:FindFirstChild("Humanoid").Health ~= 0 and player.Settings.InRound.Value and findMurder() == localPlr then
            local targetDied local localPlrDied
            
            player.Character.Humanoid.Died:Connect(function()
                targetDied = true
            end)
            
            localPlr.Character.Humanoid.Died:Connect(function()
                localPlrDied = true
            end)
            
            pcall(function()
                repeat wait()
                    localPlr.Character:FindFirstChild("HumanoidRootPart").CFrame = player.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,1)
                    localPlr.Character:FindFirstChild("Knife").KnifeScript.ClientStab:FireServer()
                until localPlrDied or targetDied or findMurder() ~= localPlr
            end)
        end
    end
end)

funSec:CreateButton("TP To Lobby", function()
    if localPlr.Character:FindFirstChild("Humanoid") == nil then return end
    
    localPlr.Character.HumanoidRootPart.CFrame = CFrame.new(-232.713455, -172.167099, -440.492493, 1, 2.10629576e-08, -0.000168945407, -2.10772821e-08, 1, -8.47878141e-08, 0.000168945407, 8.47913739e-08, 1)
end)

funSec:CreateButton("TP To Murderer", function()
    if localPlr.Character:FindFirstChild("Humanoid") == nil or findMurder() == nil or findMurder() == localPlr then return end
    
    localPlr.Character.HumanoidRootPart.CFrame = findMurder().Character.HumanoidRootPart.CFrame
end)

funSec:CreateButton("TP To Sheriff", function()
    if localPlr.Character:FindFirstChild("Humanoid") == nil or findSheriff() == nil or findSheriff() == localPlr then return end
    
    localPlr.Character:FindFirstChild("HumanoidRootPart").CFrame = findSheriff().Character:FindFirstChild("HumanoidRootPart").CFrame
end)

local snitch = funSec:CreateButton("Snitch on Roles", function()
    if findMurder() == nil or getgenv().settings.noSnitch and findMurder() == localPlr then return end
    game:GetService("ReplicatedStorage").Interactions.Server.SendChatMessage:FireServer("Murderer is: " .. findMurder().Name)
    if findSheriff() == nil or getgenv().settings.noSnitch and findSheriff() == localPlr then return end
    game:GetService("ReplicatedStorage").Interactions.Server.SendChatMessage:FireServer("Sheriff is: " .. findSheriff().Name)
end)

snitch:AddToolTip("Tells everyone who the sheriff and murderer is.")

local chatBox = funSec:CreateTextBox("Spam Message", "Your spam message here", false, function(text)
	getgenv().settings.message = text
	saveSettings()
end)

chatBox:SetValue(getgenv().settings.message or "Leading a new way to exploit - Rogue Hub")

-- Aiming

local aimSec = mainTab:CreateSection("Aiming")

aimSec:CreateToggle("Revolver Silent Aim", getgenv().settings.revolverAim or false, function(bool)
    getgenv().settings.revolverAim = bool
    saveSettings()
end)

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
	
	if getgenv().rainbowUI == false then
	    window:ChangeColor(Config.Color)
	end
    
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

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if self.Name == "HitPlayer" and method == "FireServer" and getgenv().settings.knifeAura and findMurder() == localPlr then
        localPlr.Character.Knife.KnifeScript.ClientStab:FireServer()
    elseif self.Name == "ClientLeftDown" and method == "FireServer" then
        if getgenv().settings.revolverAim and findMurder() ~= nil and findMurder() ~= localPlr then
            args[1] = findMurder().Character.HumanoidRootPart.Position
            args[2] = findMurder().Character.HumanoidRootPart
            
            return self.FireServer(self, unpack(args))
        else
            return self.FireServer(self, unpack(args))
        end
    end
    
    return old(self, ...)
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().settings.guntog then
        for _, gun in ipairs(workspace:GetChildren()) do
            if gun.Name == "RevolverPickUp" and localPlr.Character:FindFirstChild("Humanoid") then
                firetouchinterest(localPlr.Character.HumanoidRootPart, gun.Orb, 0)
                firetouchinterest(localPlr.Character.HumanoidRootPart, gun.Orb, 1)
            end
        end
    end
    
    if getgenv().settings.gemtog then
        for _, gem in pairs(workspace:GetChildren()) do
            if gem.Name == "Gem" and localPlr.Character:FindFirstChild("Humanoid") then
                firetouchinterest(localPlr.Character.HumanoidRootPart, gem, 0)
                firetouchinterest(localPlr.Character.HumanoidRootPart, gem, 1)
            end
        end
    end
    
    if getgenv().settings.spamLoop then
        game:GetService("ReplicatedStorage").Interactions.Server.SendChatMessage:FireServer(getgenv().settings.message)    
    end
    
    if getgenv().settings.playerForce and localPlr.Character ~= nil then
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
    
    if localPlr.Character ~= nil and getgenv().settings.infJump and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
        localPlr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    wait()
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
