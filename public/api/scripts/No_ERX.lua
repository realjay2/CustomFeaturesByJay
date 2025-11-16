if _G.RanERX then
    local StarterGui = game:GetService("StarterGui")

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "ERX (CUSTOM FEATURES)";
            Text = "Please Rejoin, and Execute this script BEFORE ERX.";
            Duration = 5;
        })
    end)

    warn("ERX has already ran, please rejoin to use Custom Features.")

    return 
end
