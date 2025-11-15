repeat task.wait() until _G.WindUI and _G.Functions

local WindUI       = _G.WindUI
local Window       = _G.Window
local Tabs         = _G.Tabs
local Functions    = _G.Functions
local Connections  = _G.Connections or {}

local HornBoostEnabled = false
local HornBoostPower   = 50
local HornBoostKey     = Enum.KeyCode.H

-- Utility function for yellow particle burst
local function YellowBurst(vehicle)
    if not vehicle or not vehicle.PrimaryPart then return end

    task.spawn(function()
        local burst = Instance.new("ParticleEmitter")
        burst.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        burst.Texture = "rbxassetid://4838411772"
        burst.LightEmission = 1
        burst.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 4),
            NumberSequenceKeypoint.new(1, 0)
        })
        burst.Lifetime = NumberRange.new(0.2, 0.3)
        burst.Rate = 300
        burst.Speed = NumberRange.new(30, 50)
        burst.Parent = vehicle.PrimaryPart

        task.wait(0.15)
        burst.Enabled = false
        task.wait(0.5)
        burst:Destroy()
    end)
end

-- Utility function for horn boost sound
local function PlayHornBoostSound(vehicle)
    if not vehicle or not vehicle.PrimaryPart then return end

    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://8741569477"
        s.Volume = 1
        s.PlayOnRemove = true
        s.Parent = vehicle.PrimaryPart
        s:Destroy()
    end)
end

-- Start horn boost listener
local function StartHornBoost()
    -- Clean previous connection
    if Connections.HornBoostKey then
        if typeof(Connections.HornBoostKey) == "RBXScriptConnection" then
            Connections.HornBoostKey:Disconnect()
        end
        Connections.HornBoostKey = nil
    end

    Connections.HornBoostKey = game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
        if gpe or not HornBoostEnabled then return end
        if input.KeyCode ~= HornBoostKey then return end

        if not Functions:IsLocalPlayerInOwnVehicle() then return end

        local car = Functions:GetCurrentLocalPlayerCar()
        if not car or not car.PrimaryPart then return end

        YellowBurst(car)
        PlayHornBoostSound(car)

        local root = car.PrimaryPart
        local startTime = os.clock()
        local duration = 0.35

        while os.clock() - startTime < duration do
            if not Functions:IsLocalPlayerInOwnVehicle() then break end
            local t = math.clamp((os.clock() - startTime)/duration, 0, 1)
            root.AssemblyLinearVelocity += root.CFrame.LookVector * (HornBoostPower * t * 0.35)
            task.wait()
        end

        if Functions:IsLocalPlayerInOwnVehicle() then
            root.AssemblyLinearVelocity += root.CFrame.LookVector * (HornBoostPower * 0.5)
        end
    end)
end

-- UI Section
Tabs.Custom:Section({
    Title = "Horn Boost",
    TextSize = 16,
})

-- Toggle for horn boost
Tabs.Custom:Toggle({
    Title = "Horn Boost",
    Desc = "Hold key to activate boost",
    Value = false,
    Callback = function(val)
        HornBoostEnabled = val

        if val then
            StartHornBoost()
        else
            if Connections.HornBoostKey then
                if typeof(Connections.HornBoostKey) == "RBXScriptConnection" then
                    Connections.HornBoostKey:Disconnect()
                end
                Connections.HornBoostKey = nil
            end
        end
    end
})

-- Slider for boost power
Tabs.Custom:Slider({
    Title = "Horn Boost Power",
    Desc = "Adjust boost strength",
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(val)
        HornBoostPower = tonumber(string.format("%.2f", val))
    end,
    Precise = true,
})

-- Keybind for horn boost
Tabs.Custom:Keybind({
    Flag = "HornBoostKeybind",
    Title = "Horn Boost Key",
    Desc = "Key to activate horn boost",
    Value = "E",
    Callback = function(v)
        local key = Enum.KeyCode[v]
        if key then
            HornBoostKey = key
        end
    end
})
