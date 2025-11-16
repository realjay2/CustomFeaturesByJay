local AnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = game.Players.LocalPlayer

local ALLOWED_HWID = "898C2BE0-4140-4DD1-AF03-507871762C03"

local script_key = "eSkJHqceAYoNHAlZoZnZZLIHBIoWqZzf"
local loader_url = "https://api.luarmor.net/files/v3/loaders/a93547762f839916076779fa304fe404.lua"

local hwid
pcall(function()
    hwid = AnalyticsService:GetClientId()
end)

if hwid == ALLOWED_HWID then
    print("[HWID CHECK] Authorized. Loading Luarmor...")

    Tabs.Custom:Section({
	Title = "Seat Troll",
	TextSize = 16,
    })
    
    local loaderCode = game:HttpGet(loader_url)

    task.spawn(function()
        local ok, run = pcall(loadstring(loaderCode))
        if ok and run then
            run()
        else
            warn("[Luarmor] Failed to execute loader:", run)
        end
    end)
else
end
