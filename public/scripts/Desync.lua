-- Wait until WindUI and Functions are loaded
repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs   = _G.Tabs
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
-- UI Toggle
-------------------------------------------------
local DesyncToggle
local firstExecution = true  -- prevent OFF notify on initial load

Tabs.Custom:Section({
    Title = "Player Desync",
    TextSize = 16,
})

DesyncToggle = Tabs.Custom:Toggle({
    Title = "Desync",
    Desc = "Toggle player desync",
    Default = false,

    Callback = function(state)

        -------------------------------------------------
        -- Check for TP Check requirement
        -------------------------------------------------
        if state and not Functions:IsGodModeEnabled() then
            WindUI:Notify({
                Title = "Desync Error",
                Content = "❌ Please enable 'Disable TP Check' first.",
                Duration = 4,
            })

            DesyncLib:Set(false)

            -- Force UI toggle back off
            task.defer(function()
                if DesyncToggle and DesyncToggle.SetValue then
                    DesyncToggle:SetValue(false)
                end
            end)

            return
        end

        -------------------------------------------------
        -- Apply Desync state
        -------------------------------------------------
        DesyncLib:Set(state)

        -------------------------------------------------
        -- Notifications (with no OFF notify at load)
        -------------------------------------------------
        if state then
            WindUI:Notify({
                Title = "Desync Enabled",
                Content = "Your movement is now desynced.",
                Duration = 3,
            })
        else
            if not firstExecution then
                WindUI:Notify({
                    Title = "Desync Disabled",
                    Content = "Server position restored.",
                    Duration = 3,
                })
            end
        end

        firstExecution = false
    end
})
