-- Wait until WindUI and Functions are loaded
repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------------------
-- Fling All with Team + Moderator + PRC Ignore Dropdown
-------------------------------------------------

_G.TPToAllPlayersEnabled = false
local prevState = false -- Track previous toggle state
local IgnoredOptions = {} -- selected teams/moderators/PRC to ignore
local OptionsList = { "Civilian", "DOT", "Fire", "Police", "Sherrif" }

-- Always include Moderator
local PrivateServers = ReplicatedStorage:FindFirstChild("PrivateServers")
if PrivateServers and PrivateServers:FindFirstChild("Info") then
    table.insert(OptionsList, "Moderator")
end

-- Always include PRC Mod
table.insert(OptionsList, "PRC Mod")

-- Function to check if player is a moderator
local function IsModerator(plr)
    if plr:FindFirstChild("IsMod") then
        return plr.IsMod.Value
    end
    return false
end

-- Function to check if player is a PRC Mod
local function IsPRCMod(plr)
    if plr:FindFirstChild("IsPRC") then
        return plr.IsPRC.Value
    end
    return false
end

-- Function to gather all valid players to TP to
local function GetValidPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local teamName = plr.Team and plr.Team.Name or ""
            local isMod = IsModerator(plr)
            local isPRC = IsPRCMod(plr)

            -- Skip if player is a moderator and "Moderator" is selected
            if IgnoredOptions["Moderator"] and isMod then
                continue
            end

            -- Skip if player is a PRC Mod and "PRC Mod" is selected
            if IgnoredOptions["PRC Mod"] and isPRC then
                continue
            end

            -- Skip ignored teams
            if IgnoredOptions[teamName] then
                continue
            end

            table.insert(list, plr)
        end
    end
    return list
end

-- TP Loop
local function TPToAllPlayersLoop()
    while _G.TPToAllPlayersEnabled do
        local godmodeEnabled = Functions:IsGodModeEnabled()
        local walkFlingEnabled = _G.WalkFling == true

        if not (godmodeEnabled or walkFlingEnabled) then
            _G.TPToAllPlayersEnabled = false
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ Disable TP Check / WalkFling disabled, stopping fling!",
                Duration = 4,
            })
            break
        end

        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        if not RootPart then
            task.wait(1)
            continue
        end

        local players = GetValidPlayers()
        for _, plr in ipairs(players) do
            if not _G.TPToAllPlayersEnabled then break end

            local targetRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                RootPart.CFrame = targetRoot.CFrame + Vector3.new(2, 0, 0)

                local timer = 0
                while timer < 2 do
                    if not _G.TPToAllPlayersEnabled then break end
                    RootPart.CFrame = targetRoot.CFrame + Vector3.new(2, 0, 0)
                    timer += RunService.RenderStepped:Wait()
                end
            end
        end

        task.wait(0.5) -- loop delay to continuously update
    end
end

-------------------------------------------------
-- Team + Moderator/PRC Ignore Dropdown
-------------------------------------------------
Tabs.Trolling:Dropdown({
    Title = "Ignore Options",
    Values = OptionsList,
    Multi = true,
    Value = {},
    Callback = function(selected)
        IgnoredOptions = {}
        for _, option in ipairs(selected) do
            IgnoredOptions[option] = true
        end
    end,
})

-------------------------------------------------
-- Toggle button (Trolling Tab)
-------------------------------------------------
Tabs.Trolling:Toggle({
    Title = "Fling All",
    Desc = "Automatically teleport to every player [Disable TP Check / WalkFling required]",
    Default = false,
    Callback = function(state)
        local godmodeEnabled = Functions:IsGodModeEnabled()
        local walkFlingEnabled = _G.WalkFling == true

        if state and not (godmodeEnabled or walkFlingEnabled) then
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ Enable 'Disable TP Check' and `WalkFling` first!",
                Duration = 4,
            })
            _G.TPToAllPlayersEnabled = false
            return
        end

        _G.TPToAllPlayersEnabled = state

        if state and not prevState then
            WindUI:Notify({
                Title = "Fling All",
                Content = "✅ Started.",
                Duration = 3,
            })
            task.spawn(TPToAllPlayersLoop)
        elseif not state and prevState then
            if not (godmodeEnabled or walkFlingEnabled) then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Cannot stop properly without GodMode / WalkFling!",
                    Duration = 4,
                })
            else
                WindUI:Notify({
                    Title = "Fling All",
                    Content = "❌ Stopped.",
                    Duration = 3,
                })
            end

            local Character = LocalPlayer.Character
            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if Humanoid then
                    Humanoid.Health = 0
                end
            end
        end

        prevState = state
    end,
})
