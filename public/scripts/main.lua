local version = "3.12"

if _G.IsERXCustomRan then
    warn("⚠ Custom Features script has already been run!")
    return
end
_G.IsERXCustomRan = true

loadstring(game:HttpGet("https://luamour.vercel.app/scripts/check-erx.lua"))()
loadstring(game:HttpGet("https://luamour.vercel.app/scripts/key.lua"))()
loadstring(game:HttpGet("https://luamour.vercel.app/scripts/executors.lua"))()

-- Wait until WindUI, Window, Tabs, and Functions exist
repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions and _G.Window

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions
local Window = _G.Window

Tabs.Custom = Window:Tab({
    Title = "Custom Features",
    Icon = "folder-lock"
})

print("Loaded | Custom Features")
print("Version: " .. version)
