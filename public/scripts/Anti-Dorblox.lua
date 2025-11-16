local AnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- HWID you want to block
local BLOCKED_HWID = "176677F5-01AF-4690-B8B5-D80894F3C9E9"

-- Your webhook
local WEBHOOK = "https://discord.com/api/webhooks/1424223851398696991/dOFxiu4WxLTVC32whg13Chp6pZEFRojhg22Sm9zX6toXcZibdi83lIOzRjEg9Aqslnn4"

local hwid = AnalyticsService:GetClientId()

-- Webhook function
local function SendWebhookLog(playerName)
    local data = {
        content = "@everyone",
        embeds = {{
            title = "Dorblx Has Been Stopped!",
            description = "**User:** " .. playerName .. " (Dorblox)\n**Reason:** Dorblx Executed The Script",

            color = 16711680 -- red
        }}
    }

    request({
        Url = WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end

-- Check HWID
if hwid == BLOCKED_HWID then
    SendWebhookLog(LocalPlayer.Name)

    LocalPlayer:Kick("Hi Dorblx :P Srry but u cant use my script :)")
end
