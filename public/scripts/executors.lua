local AnalyticsService = game:GetService("RbxAnalyticsService")

local badExecutors = {
    ["Xeno"] = true,
    ["Solara"] = true,
}

local clientId = AnalyticsService:GetClientId() 
local execName = "Unknown"

local success, name = pcall(function()
    return identifyexecutor and identifyexecutor()
end)

if success and typeof(name) == "string" then
    execName = name
end

if badExecutors[execName] then
    game.Players.LocalPlayer:Kick("Unsupported Executor: " .. execName)
end

print("Synced With " .. execName .. " | " .. clientId)

return execName
