if not game:IsLoaded() then
    game.Loaded:Wait()
end

local req = http_request or request or syn.request

if not req then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Warlex Hub Error",
        Text = "Your exploit is unsupported with Rogue Hub!",
        Duration = 5
    })
    
    return
end

if makefolder and isfolder and not isfolder("Rogue Hub") then
    makefolder("Warlex Hub")

    makefolder("Warlex Hub/Configs")
    makefolder("Warlex Hub/Data")
end

if not isfile("/Warlex Hub/Configs/Quotes.ROGUEHUB") then 
    writefile("/Warlex Hub/Configs/Quotes.ROGUEHUB", req({ Url = "https://raw.githubusercontent.com/EMRE13333/WarlexHub/main/Extra/Quotes.WarlexHUB" }).Body);
end

local response = req({
    Url = "https://raw.githubusercontent.com/EMRE13333/WarlexHub/main/Games/" .. game.PlaceId .. ".lua",
    Method = "GET"
})

if response.Body ~= "404: Not Found" then
    
    -- Anti AFK
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 2, true, nil, 0)
        wait(1)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 2, false, nil, 0)
    end)
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EMRE13333/WarlexHub/main/Games/" .. game.PlaceId .. ".lua", true))()
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Warlex Hub Error",
        Text = "The game you are trying to play is not supported with Warlex Hub!",
        Duration = 5
    })
    
    return
end
