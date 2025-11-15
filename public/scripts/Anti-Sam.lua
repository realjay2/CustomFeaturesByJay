repeat task.wait() until _G.WindUI and _G.Functions

local Tabs = _G.Tabs

local OriginalAssets = {}

local function StoreOriginalAssets()
    OriginalAssets = {}
    for _, V in ipairs(game:GetDescendants()) do
        if V:IsA("ImageLabel") or V:IsA("ImageButton") then
            OriginalAssets[V] = V.Image
        elseif V:IsA("Decal") or V:IsA("Texture") then
            OriginalAssets[V] = V.Texture
        elseif V:IsA("TextLabel") or V:IsA("TextButton") then
            OriginalAssets[V] = V.Text
        end
    end
end

local function RevertChanges()
    for Object, Original in pairs(OriginalAssets) do
        if Object and Object.Parent then
            if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
                if Object.Image ~= Original then
                    Object.Image = Original
                end
            elseif Object:IsA("Decal") or Object:IsA("Texture") then
                if Object.Texture ~= Original then
                    Object.Texture = Original
                end
            elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
                if Object.Text ~= Original then
                    Object.Text = Original
                end
            end
        end
    end
end

local function RemoveMaliciousParticles()
    for _, V in ipairs(workspace:GetDescendants()) do
        if V:IsA("ParticleEmitter") then
            if V.Rate == 5 and V.Lifetime == NumberRange.new(2, 4) and V.Speed == NumberRange.new(0.5, 1.5) then
                V:Destroy()
            end
        end
    end
end

Tabs.Custom:Toggle({
    Title = "Anti Sam Jumpscare",
    Desc = "Prevents Sam jumpscare assets from appearing",
    Default = false,
    Callback = function(Value)
        if Value then
            StoreOriginalAssets()
            task.spawn(function()
                while _G.WindUI and Value do
                    RevertChanges()
                    RemoveMaliciousParticles()
                    task.wait(0.5)
                end
            end)
            _G.WindUI:Notify("Anti Sam Jumpscare Enabled")
        else
            _G.WindUI:Notify("Anti Sam Jumpscare Disabled")
        end
    end
})
