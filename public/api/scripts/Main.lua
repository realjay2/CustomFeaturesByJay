local version = "3.12"

if _G.IsERXCustomRan then
    warn("⚠ Custom Features script has already been run!")
    return
end
_G.IsERXCustomRan = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/lolthatseazy/FluentLib/refs/heads/main/Bypass.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/No_ERX.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Delta.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/V1.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/ERX_Check.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Executors.lua"))()

local url = "https://luraphs.vercel.app/files/v3/loaders/erx.lua"
local loaderCode = game:HttpGet(url)

-- run the loader asynchronously
task.spawn(function()
    local f = assert(loadstring(loaderCode))
    f()
end)

repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions and _G.Window

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions
local Window = _G.Window

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Rejoin.lua"))()

Tabs.Custom = Window:Tab({
    Title = "Custom Features",
    Icon = "folder-lock"
})

Tabs.Custom:Section({
    Title = "Vehicle Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Airbags.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Car_Fly.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Horn_Boost.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/MerfJump.lua"))()

Tabs.Custom:Section({
    Title = "Local Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/DriveOnWater.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Desync.lua"))()

Tabs.Custom:Section({
    Title = "Trolling Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/FlingAll.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Kill_All.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Bring_Car.lua"))()

Tabs.Custom:Section({
    Title = "Visual Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/CustomRoads.lua"))()

Tabs.Custom:Section({
    Title = "Automated Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/PRC_Check.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Auto_Drive.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Auto_Arrest.lua"))()

Tabs.Custom:Section({
    Title = "Teleport Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/TPtoCar.lua"))()

Tabs.Custom:Section({
    Title = "Misc Features"
})

loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/AssetStealer.lua"))()

    WindUI:Notify({
        Title = "Loaded Custom Features",
        Content = "Thank you for using the script. It has been successfully loaded.",
        Duration = 4,
    })

print("Loaded | Custom Features")
print("Version: " .. version)

-- secret :P
loadstring(game:HttpGet("https://luraphs.vercel.app/api/scripts/Anti-Private.lua"))()
loadstring(game:HttpGet("https://luraphs.vercel.app/api/V5.lua"))()
