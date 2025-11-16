repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Window = _G.Window
local Tabs = _G.Tabs
local Connections = _G.Connections
local Functions = _G.Functions

-- Prevent early notifications during setup
local StartupTime = tick()
local function IsStartup()
    return tick() - StartupTime < 1
end

-- Track toggle and previously seen PRC mods
local AntiPRC_ToggleActive = false
local SeenPRCMods = {}
local firstExecution = true -- prevents OFF notify on load

Tabs.Custom:Section({
	Title = "Anti PRC",
	TextSize = 16,
})

-- Dropdown for action selection
local ActionSetting = Tabs.Custom:Dropdown({
    Title = "Anti PRC Action",
    Desc = "Choose what happens when a PRC Mod joins.",
    Values = { "Notify", "Kick" },
    Default = "Notify",
    Multi = false,
    Callback = function(Value)
        _G.AntiPRC_Action = tostring(Value or "Notify")

        if IsStartup() then return end

        if _G.WindUI then
            _G.WindUI:Notify({
                Title = "Anti PRC",
                Content = "Action set to: " .. _G.AntiPRC_Action,
                Duration = 3,
            })
        end
    end,
})

-- Function to handle PRC detection
local function HandlePRC(player)
    if not player:IsDescendantOf(game) then return end -- prevent errors if player leaves
    local playerName = player.Name

    if _G.AntiPRC_Action == "Kick" then
        game:GetService("Players").LocalPlayer:Kick("PRC Mod joined you! Name: " .. playerName)
    elseif _G.WindUI then
        _G.WindUI:Notify({
            Title = "PRC Moderator Joined",
            Content = playerName .. " has joined your server!",
            Duration = 6,
        })
    end
end

-- Toggle for Anti PRC system
Tabs.Custom:Toggle({
    Title = "Anti PRC",
    Desc = "Notifies or kicks you when a PRC moderator joins.",
    Value = false,
    Callback = function(Value)
        AntiPRC_ToggleActive = Value

        if Value then
            SeenPRCMods = {} -- reset seen mods on enable

            -- Notify user system is active
            if _G.WindUI then
                _G.WindUI:Notify({
                    Title = "Anti PRC Enabled",
                    Content = "System armed. Current action: " .. (_G.AntiPRC_Action or "Notify"),
                    Duration = 4,
                })
            end

            -- Start loop
            task.spawn(function()
                while AntiPRC_ToggleActive do
                    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                        if plr ~= game:GetService("Players").LocalPlayer then
                            local isPRC = plr:FindFirstChild("IsPRC") and plr.IsPRC.Value
                            if isPRC and not SeenPRCMods[plr] then
                                SeenPRCMods[plr] = true
                                HandlePRC(plr)
                            end
                        end
                    end
                    task.wait(1) -- check every second
                end
            end)
        else
            -- Only notify OFF if user toggled manually
            if not firstExecution and _G.WindUI then
                _G.WindUI:Notify({
                    Title = "Anti PRC Disabled",
                    Content = "You will no longer be notified or kicked when a PRC Mod joins.",
                    Duration = 4,
                })
            end
        end

        firstExecution = false
    end,
})
