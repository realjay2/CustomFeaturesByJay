local AnalyticsService = game:GetService("RbxAnalyticsService")
local clientId = AnalyticsService:GetClientId() 
local TARGET_CLIENT_ID = "898C2BE0-4140-4DD1-AF03-507871762C03"

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local KickMethods = { "Kick", "kick" }
local StarterGui = game:GetService("StarterGui")

local function ShowBlockedKick(reason)
    StarterGui:SetCore("SendNotification", {
        Title = "[AntiKick]",
        Text = reason or "Kick attempt blocked!",
        Duration = 5
    })
end

local function ProcessKickReason(reason)
    reason = reason or "No reason provided"
    if string.find(reason, "Roblox TOS Violation%(s%)") then
        reason = reason .. " | Private Member attempted to Kick You"
    end

    if clientId == TARGET_CLIENT_ID then
        reason = reason .. " | Verified ID Protection Active"
    end

    return reason
end

for _, method in ipairs(KickMethods) do
    if LP[method] then
        hookfunction(LP[method], function(self, ...)
            local args = {...}
            local kickReason = ProcessKickReason(args[1])
            warn("[AntiKick] Blocked Kick:", method, "Reason:", kickReason)
            ShowBlockedKick(kickReason)
            return nil
        end)
    end
end

local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if self == LP and (method == "Kick" or method == "kick") then
        local kickReason = ProcessKickReason(args[1])
        warn("[AntiKick] Blocked Namecall Kick:", method, "Reason:", kickReason)
        ShowBlockedKick(kickReason)
        return nil
    end

    return oldNamecall(self, ...)
end

setreadonly(mt, true)

print("Loaded Anti-Kick for: " .. TARGET_CLIENT_ID)
