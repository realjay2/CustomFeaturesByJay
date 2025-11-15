if _G.RanERX then
    local StarterGui = game:GetService("StarterGui")

    -- Notify player
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "ERX (CUSTOM FEATURES)";
            Text = "Please Rejoin, and Execute this script BEFORE ERX.";
            Duration = 5;
        })
    end)

    -- Warn in output
    warn("ERX has already run. Script stopped. Rejoin and execute before ERX.")

    return -- stop further execution
end
