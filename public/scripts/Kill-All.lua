repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

-------------------------------------------------
Tabs.Custom:Section({
	Title = "Kill All",
	TextSize = 16,
})

Tabs.Custom:Toggle({
    Title = "Kill All",
    Desc = "I have the method, but Dorblx said I cant release :(",
    Default = false,
    Locked = True,
    Callback = function(value)
    end
})
