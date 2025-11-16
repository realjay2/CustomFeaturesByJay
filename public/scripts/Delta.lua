
local executor = identifyexecutor and identifyexecutor():lower() or "unknown"

if executor:find("Delta") then
    local StarterGui = game:GetService("StarterGui")
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Warning",
            Text = "Delta executor detected! Script may be detected.",
            Duration = 5
        })
    end)
end
