repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
if not vehiclesFolder then
    WindUI:Notify({
        Title = "TP Error",
        Content = "❌ 'Vehicles' folder not found in Workspace!",
        Duration = 4
    })
    return
end

local selectedVehicleName = nil
local vehicleDropdown

local function GetVehicleNames()
    local names = {}
    for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
        if vehicle:IsA("Model") then
            table.insert(names, vehicle.Name)
        end
    end
    return names
end

Tabs.Custom:Section({
	Title = "Teleport To Vehicle",
	TextSize = 16,
})

vehicleDropdown = Tabs.Custom:Dropdown({
    Title = "Select Vehicle",
    Values = GetVehicleNames(),
    Multi = false,
    Value = None,
    Callback = function(Value)
        selectedVehicleName = Value
    end,
})

task.spawn(function()
    while task.wait(2) do
        if vehicleDropdown and vehicleDropdown.UpdateValues then
            local names = GetVehicleNames()
            vehicleDropdown:UpdateValues(names)
            if selectedVehicleName and table.find(names, selectedVehicleName) then
                vehicleDropdown:SetValue(selectedVehicleName)
            elseif #names > 0 then
                selectedVehicleName = names[1]
                vehicleDropdown:SetValue(selectedVehicleName)
            else
                selectedVehicleName = nil
            end
        end
    end
end)

Tabs.Custom:Button({
    Title = "TP To Car",
    Desc = "Teleports you to the selected car",
    Callback = function()
        if not _G.Functions or typeof(_G.Functions.IsGodModeEnabled) ~= "function" or not _G.Functions:IsGodModeEnabled() then
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ Enable 'Disable TP Check' first!",
                Duration = 4
            })
            return
        end

        if not selectedVehicleName then
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ No vehicle selected!",
                Duration = 3
            })
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(selectedVehicleName)
        if not vehicle then
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ Vehicle not found!",
                Duration = 3
            })
            return
        end

        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        if not RootPart then
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ Your character is not loaded!",
                Duration = 3
            })
            return
        end

        local primary = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
        if primary then
            RootPart.CFrame = primary.CFrame + Vector3.new(0, 5, 0)
            WindUI:Notify({
                Title = "TP Success",
                Content = "✅ Teleported to " .. vehicle.Name,
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "TP Error",
                Content = "❌ Failed to bring the vehicle!",
                Duration = 3
            })
        end
    end
})
