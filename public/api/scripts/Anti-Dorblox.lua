local AnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local BLOCKED_HWID = "176677F5-01AF-4690-B8B5-D80894F3C9E9"
local WEBHOOK = "https://discord.com/api/webhooks/1439696796686225638/hfg2yu0LrvxZV1Gm74xSI2dKEiNKHzdYdGRZQJDzN4-gZwVCeV5nMfWm1pYIb20nPLHT"

local hwid = AnalyticsService:GetClientId()

local function SendWebhookLog(playerName)
    local data = {
        content = "@everyone",
        embeds = {{
            title = "Dorblx Has Been Stopped!",
            description = "**User:** " .. playerName .. " (Dorblox)\n**Reason:** Dorblx Executed The Script",
            color = 16711680
        }}
    }

    request({
        Url = WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end

if hwid == BLOCKED_HWID then
    SendWebhookLog(LocalPlayer.Name)
    LocalPlayer:Kick("Hi Dorblx :P Srry but u cant use my script :)")
end
