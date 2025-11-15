if not _G.RanERX then
    local StarterGui = game:GetService("StarterGui")

    StarterGui:SetCore("SendNotification", {
        Title = "ERX (CUSTOM FEATURES)";
        Text = "ERX has not loaded yet. Please start ERX.";
        Duration = 5;
    })

    warn("ERX Gui Has not Loaded.")
    
end
