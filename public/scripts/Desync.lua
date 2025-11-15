-- Wait until WindUI and Functions are loaded
repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

--// DesyncLib
local DesyncLib = {
    ServerPos = CFrame.new(0, 0, 0),
    Enabled = false,
}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character
local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Head = Character and Character:FindFirstChild("Head")

local Desync = {
    Real = {},
    Fake = { CFrame = CFrame.new() },
    Sent = CFrame.new()
}

-------------------------------------------------
-- Core Desync logic
-------------------------------------------------
RunService:BindToRenderStep("Desync", Enum.RenderPriority.First.Value, function()
    if not DesyncLib.Enabled or not RootPart or not Head then return end

    if Desync.Sent.Position ~= RootPart.Position then
        Desync.Real.CFrame = RootPart.CFrame
    end

    RootPart.CFrame = Desync.Real.CFrame or RootPart.CFrame
    RootPart.Velocity = Desync.Real.Velocity or RootPart.Velocity
    RootPart.RotVelocity = Desync.Real.RotVelocity or RootPart.RotVelocity

    Desync.Fake.CFrame = DesyncLib.ServerPos
end)

RunService.Heartbeat:Connect(function()
    Character = LocalPlayer.Character
    RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    Head = Character and Character:FindFirstChild("Head")
    if not RootPart then return end

    Desync.Real.CFrame = RootPart.CFrame
    Desync.Real.Velocity = RootPart.Velocity
    Desync.Real.RotVelocity = RootPart.RotVelocity

    if DesyncLib.Enabled then
        RootPart.CFrame = Desync.Fake.CFrame or RootPart.CFrame
        RootPart.Velocity = Desync.Fake.Velocity or RootPart.Velocity
        RootPart.RotVelocity = Desync.Fake.RotVelocity or RootPart.RotVelocity
        Desync.Sent = RootPart.CFrame
    end
end)

-------------------------------------------------
-- DesyncLib methods
-------------------------------------------------
function DesyncLib:SetServerPos(Position)
    if not Position then return false, "No position" end
    if typeof(Position) == "Vector3" then
        Position = CFrame.new(Position)
    end
    DesyncLib.ServerPos = Position
    return true, "Success"
end

function DesyncLib:Set(Value)
    if typeof(Value) ~= "boolean" then
        Value = false
    end
    DesyncLib.Enabled = Value
end

-------------------------------------------------
-- WindUI Toggle
-------------------------------------------------
local DesyncToggle -- store reference to toggle

Tabs.Custom:Section({
	Title = "Player Desync",
	TextSize = 16,
})


DesyncToggle = Tabs.Custom:Toggle({
    Title = "Desync",
    Desc = "Toggle player desync",
    Default = false,
    Callback = function(state)
        -- ✅ Check if Disable TP Check (God Mode) is enabled
        if state and not Functions:IsGodModeEnabled() then
            WindUI:Notify({
                Title = "Desync Error",
                Content = "❌ Please enable 'Disable TP Check' before using Desync!",
                Duration = 4,
            })

            -- Disable toggle both logically and visually
            DesyncLib:Set(false)
            task.defer(function()
                if DesyncToggle and DesyncToggle.SetValue then
                    DesyncToggle:SetValue(false)
                end
            end)

            return -- stop here so no "Disabled" notification fires
        end

        -- Normal toggle behavior
        DesyncLib:Set(state)

        -- Only notify if user actually toggled
        if state then
            WindUI:Notify({
                Title = "Desync Enabled",
                Content = "Your movement is now desynced from the server.",
                Duration = 3,
            })
        elseif DesyncLib.Enabled == false then
            WindUI:Notify({
                Title = "Desync Disabled",
                Content = "Server and client position re-synced.",
                Duration = 3,
            })
        end
    end
})
