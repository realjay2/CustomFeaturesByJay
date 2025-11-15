local version = "3.12"

loadstring(game:HttpGet("https://luamour.vercel.app/scripts/check-erx.lua"))()
loadstring(game:HttpGet("https://luamour.vercel.app/scripts/key.lua"))()
loadstring(game:HttpGet("https://luamour.vercel.app/scripts/executors.lua"))()

-- Wait for WindUI, Tabs and other globals from your example to exist
repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions
local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

Tabs.Custom = Window:Tab({
	Title = "Custom Features",
	Icon = "folder-lock"
})

print("Loaded | Custom Features")
print("Version: " .. version)
