-- Anti-PrivateCommands Script
-- Blocks malicious PrivateCommands like :reveal, :kill, :fakeban, etc.

-- Wait until Players service is loaded
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Disable all PrivateCommands by overriding their functions
-- This assumes some script is defining PrivateCommands somewhere in _G or local scope
-- We replace the functions with safe no-ops

-- If PrivateCommands exists globally
if _G.PrivateCommands then
    for command, _ in pairs(_G.PrivateCommands) do
        _G.PrivateCommands[command] = function()
            warn("[AntiCheat] Blocked command: " .. command)
            -- Optionally, show notification to user
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

-- If PrivateCommands is local, hook FireServer to prevent exploitation
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Block FireServer calls related to the commands
    if method == "FireServer" and self.Name == "Chat" then
        local message = args[1]
        if type(message) == "string" then
            -- Check if the message is a private command
            local blockedCommands = {
                ":reveal", ":noroot", ":say", ":fakeban", ":kill",
                ":samjumpscare", ":freeze", ":prcprivate", ":removeprc",
                ":unfreeze", ":givemoney", ":debt", ":setfps",
                ":shutdown", ":trip", ":void", ":kick", ":crash", ":notify"
            }
            for _, cmd in ipairs(blockedCommands) do
                if message:lower():find(cmd) then
                    warn("[AntiCheat] Blocked FireServer call with command: " .. cmd)
                    return -- Block the command
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

warn("[AntiCheat] PrivateCommands protection loaded.")
