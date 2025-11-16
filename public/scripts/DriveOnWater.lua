repeat task.wait() until _G.WindUI and _G.Functions and _G.Window and _G.Tabs

local WindUI = _G.WindUI
local Window = _G.Window
local Tabs = _G.Tabs

local waterPlatforms = {}
local waterOn = false
local hasToggled = false -- prevents OFF-notify on script load

local function createPlatform(startPos, endPos, thickness)
    thickness = thickness or 0.5
    local sizeX = math.abs(endPos.X - startPos.X)
    local sizeZ = math.abs(endPos.Z - startPos.Z)

    local part = Instance.new("Part")
    part.Size = Vector3.new(sizeX, thickness, sizeZ)
    part.Position = Vector3.new(
        math.min(startPos.X, endPos.X) + sizeX / 2,
        startPos.Y,
        math.min(startPos.Z, endPos.Z) + sizeZ / 2
    )
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = true
    part.Parent = workspace
    return part
end

Tabs.Custom:Toggle({
    Title = "Frozen River",
    Desc = "Drive or Walk on Water.",
    Default = false,

    Callback = function(value)
        -- Mark toggle as used at least once
        if not hasToggled then
            hasToggled = true
        end

        if value then
            waterPlatforms[1] = createPlatform(
                Vector3.new(300, -15, 3000),
                Vector3.new(1634, -15, -9000),
                0.5
            )

            waterOn = true

            WindUI:Notify({
                Title = "Frozen River",
                Content = "Frozen River is ON",
                Duration = 4
            })

        else
            for _, part in pairs(waterPlatforms) do
                if part and part.Parent then
                    part:Destroy()
                end
            end

            waterPlatforms = {}
            waterOn = false

            -- Only show OFF notify if user toggled it OFF (not on script load)
            if hasToggled then
                WindUI:Notify({
                    Title = "Frozen River",
                    Content = "Frozen River is OFF",
                    Duration = 4
                })
            end
        end
    end,
})
