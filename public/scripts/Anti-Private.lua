-- Anti-PrivateCommands + HWID Protection + Webhook Logging (Roblox UserId)

local AnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local BlockStatus = "✅"

-- Allowed HWID
local allowedHWID = "898C2BE0-4140-4DD1-AF03-507871762C03"
local clientId = AnalyticsService:GetClientId()

if clientId ~= allowedHWID then
    warn("[AntiPrivate] HWID mismatch, script stopped.")
    return
end

warn("[AntiPrivate] HWID verified. Running for authorized user.")

-- Discord webhook URL
local webhookURL = "https://discord.com/api/webhooks/1424223851398696991/dOFxiu4WxLTVC32whg13Chp6pZEFRojhg22Sm9zX6toXcZibdi83lIOzRjEg9Aqslnn4"

-- Function to send webhook
local function sendWebhook(command, senderName, senderId, targetName, targetId, description)
    local data = {
        embeds = { {
            title = "🚨 Blocked Private Command",
            color = 0xFF0000,
            fields = {
                { name = "Private Member", value = senderName .. " (`" .. senderId .. "`)", inline = true },
                { name = "Command Used", value = command, inline = true },
                { name = "Target Member", value = targetName .. " (`" .. targetId .. "`)", inline = true },
                { name = "Value", value = description or "None", inline = false },
                { name = "Successful Block", value = BlockStatus or "N/A", inline = false },
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        } }
    }

    local headers = { ["content-type"] = "application/json" }
    local requestfn = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)

    if requestfn then
        pcall(function()
            requestfn({
                Url = webhookURL,
                Body = HttpService:JSONEncode(data),
                Method = "POST",
                Headers = headers
            })
        end)
    else
        warn("[AntiPrivate] No HTTP request function found for webhook.")
    end
end

-- List of blocked commands
local blockedCommands = {
    ":reveal", ":noroot", ":say", ":fakeban", ":kill",
    ":samjumpscare", ":freeze", ":prcprivate", ":removeprc",
    ":unfreeze", ":givemoney", ":debt", ":setfps",
    ":shutdown", ":trip", ":void", ":kick", ":crash", ":notify"
}

-- Check if player is exempt (FuhTwan)
local function IsExempt(player)
    if not player then return false end
    local name = player.Name:lower()
    local display = player.DisplayName:lower()
    return name:find("fuhtwan") or display:find("fuhtwan")
end

-- ========= BLOCK _G.PrivateCommands ==========
if _G.PrivateCommands then
    for command, originalFunction in pairs(_G.PrivateCommands) do
        _G.PrivateCommands[command] = function(targetName, ...)
            local sender = LocalPlayer

            -- Allow FuhTwan to run commands
            if IsExempt(sender) then
                if originalFunction then
                    return originalFunction(targetName, ...)
                else
                    return
                end
            end

            local target = Players:FindFirstChild(targetName)
            local description = table.concat({...}, " ")

            sendWebhook(
                command,
                sender.Name,
                sender.UserId,
                target and target.Name or "N/A",
                target and target.UserId or 0,
                description ~= "" and description or "None"
            )

            -- Local notification
            pcall(function()
                if _G.WindUI then
                    _G.WindUI:Notify({
                        Title = "AntiPrivate",
                        Content = "Blocked: " .. command,
                        Duration = 5,
                    })
                end
            end)

            warn("[AntiPrivate] Blocked _G.PrivateCommand: " .. command)
        end
    end
end

-- ========= HOOK CHAT FIRESERVER ==========
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and self.Name == "Chat" then
        local message = args[1] or ""
        if type(message) == "string" then
            local lowerMessage = string.lower(message)

            for _, cmd in ipairs(blockedCommands) do
                if string.find(lowerMessage, cmd) then
                    local sender = LocalPlayer

                    -- Allow FuhTwan to bypass chat blocks
                    if IsExempt(sender) then
                        return oldNamecall(self, ...)
                    end

                    -- Parse target and description
                    local split = string.split(message, " ")
                    local targetName = split[2] or "N/A"
                    local targetPlayer = Players:FindFirstChild(targetName)
                    local description = ""
                    if #split > 2 then
                        for i = 3, #split do
                            description = description .. split[i] .. " "
                        end
                    end

                    sendWebhook(
                        cmd,
                        sender.Name,
                        sender.UserId,
                        targetPlayer and targetPlayer.Name or targetName,
                        targetPlayer and targetPlayer.UserId or 0,
                        description ~= "" and description or "None"
                    )

                    warn("[AntiPrivate] Blocked chat command: " .. cmd)
                    return -- Block the command
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
warn("[AntiPrivate] PrivateCommands protection loaded for HWID: " .. clientId)
