repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

-------------------------------------------------
Tabs.Custom:Section({
	Title = "Auto Drive",
	TextSize = 16,
})

Tabs.Custom:Toggle({
    Title = "Auto Drive",
    Desc = "Auto Drive To Waypoint (Soon)",
    Default = false,
    Locked = True
    Callback = function(value)
    end
})
