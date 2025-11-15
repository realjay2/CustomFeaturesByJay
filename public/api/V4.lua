-- Anti-PrivateCommands + HWID Protection using RbxAnalyticsService

local AnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local allowedHWID = "898C2BE0-4140-4DD1-AF03-507871762C03"
local clientId = AnalyticsService:GetClientId()

if clientId ~= allowedHWID then
    return 
end

warn("[AntiCheat] HWID verified. Script running for authorized user.")

-- ======= Anti-PrivateCommands Logic =======

if _G.PrivateCommands then
    for command, _ in pairs(_G.PrivateCommands) do
        _G.PrivateCommands[command] = function()
            warn("[AntiCheat] Blocked command: " .. command)
            pcall(function()
                if _G.WindUI and _G.WindUI.Notify then
                    _G.WindUI:Notify({
                        Title = "AntiCheat",
                        Content = "Blocked command: " .. command,
                        Duration = 5,
                    })
                end
            end)
        end
    end
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and self.Name == "Chat" then
        local message = args[1]
        if type(message) == "string" then
            local blockedCommands = {
                ":reveal", ":noroot", ":say", ":fakeban", ":kill",
                ":samjumpscare", ":freeze", ":prcprivate", ":removeprc",
                ":unfreeze", ":givemoney", ":debt", ":setfps",
                ":shutdown", ":trip", ":void", ":kick", ":crash", ":notify"
            }
            for _, cmd in ipairs(blockedCommands) do
                if message:lower():find(cmd) then
                    warn("[AntiCheat] Blocked FireServer call with command: " .. cmd)
                    return 
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

warn("[AntiCheat] PrivateCommands protection loaded for HWID: " .. clientId)
