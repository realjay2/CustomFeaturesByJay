repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

-------------------------------------------------
Tabs.Custom:Section({
	Title = "Bring Car",
	TextSize = 16,
})

Tabs.Custom:Toggle({
    Title = "Bring Car",
    Desc = "Bring Anyones Car (Soon)",
    Default = false,
    Locked = true,
    Callback = function(value)
    end
})
