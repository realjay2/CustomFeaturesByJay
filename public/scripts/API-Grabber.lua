repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

-------------------------------------------------
Tabs.Custom:Section({
	Title = "API Grabber",
	TextSize = 16,
})

Tabs.Custom:Toggle({
    Title = "API Grabber",
    Desc = "Grabs Private Server API Key (Soon)",
    Default = false,
    Locked = True
    Callback = function(value)
    end
})
