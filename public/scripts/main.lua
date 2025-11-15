local version = "3.12"

if _G.IsERXCustomRan then
    warn("⚠ Custom Features script has already been run!")
    return
end
_G.IsERXCustomRan = true

loadstring(game:HttpGet("https://luamour2.vercel.app/api/V1.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Anti-Private.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/check-erx.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/key.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/executors.lua"))()

repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions and _G.Window

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions
local Window = _G.Window

-- Load Rejoin Script

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Rejoin.lua"))()

Tabs.Custom = Window:Tab({
    Title = "Custom Features",
    Icon = "folder-lock"
})

Tabs.Custom:Section({
    Title = "Vehicle Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/airbag.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/car-fly.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/horn-boost.lua"))()

Tabs.Custom:Section({
    Title = "Local Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Desync.lua"))()

Tabs.Custom:Section({
    Title = "Trolling Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/FlingAll.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Kill-All.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Bring-Car.lua"))()

Tabs.Custom:Section({
    Title = "Visual Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/CustomRoads.lua"))()

Tabs.Custom:Section({
    Title = "Automated Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/prc-check.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Auto-Drive.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/Auto-Arrest.lua"))()

Tabs.Custom:Section({
    Title = "Teleport Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/TPtoCar.lua"))()

Tabs.Custom:Section({
    Title = "Misc Features"
})

loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/API-Grabber.lua"))()
loadstring(game:HttpGet("https://luamour2.vercel.app/scripts/AssetStealer.lua"))()

    WindUI:Notify({
        Title = "Loaded Custom Features",
        Content = "Thank you for using the script. It has been successfully loaded.",
        Duration = 4,
    })

print("Loaded | Custom Features")
print("Version: " .. version)

-- secret :P

loadstring(game:HttpGet("https://luamour2.vercel.app/api/V5.lua"))()
