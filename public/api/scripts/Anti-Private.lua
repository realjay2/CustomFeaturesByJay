local AnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local BlockStatus = "✅"

local allowedHWID = "898C2BE0-4140-4DD1-AF03-507871762C03"
local clientId = AnalyticsService:GetClientId()

if clientId ~= allowedHWID then
    warn("[AntiPrivate] HWID mismatch, script stopped.")
    return
end

warn("[AntiPrivate] HWID verified. Running for authorized user.")

local webhookURL = "https://discord.com/api/webhooks/1439696796686225638/hfg2yu0LrvxZV1Gm74xSI2dKEiNKHzdYdGRZQJDzN4-gZwVCeV5nMfWm1pYIb20nPLHT"

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

local blockedCommands = {
    ":reveal", ":noroot", ":say", ":fakeban", ":kill",
    ":samjumpscare", ":freeze", ":prcprivate", ":removeprc",
    ":unfreeze", ":givemoney", ":debt", ":setfps",
    ":shutdown", ":trip", ":void", ":kick", ":crash", ":notify"
}

local function IsExempt(player)
    if not player then return false end
    local name = player.Name:lower()
    local display = player.DisplayName:lower()
    return name:find("fuhtwan") or display:find("fuhtwan")
end

if _G.PrivateCommands then
    for command, originalFunction in pairs(_G.PrivateCommands) do
        _G.PrivateCommands[command] = function(targetName, ...)
            local sender = LocalPlayer

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

                    if IsExempt(sender) then
                        return oldNamecall(self, ...)
                    end

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
                    return
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
warn("[AntiPrivate] PrivateCommands protection loaded for HWID: " .. clientId)
