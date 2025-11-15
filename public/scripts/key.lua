local loader = "https://luamour.vercel.app/files/v3/loaders/9bc4fc7e1d8a0c62e72dda22a300c4de.lua"

local success, response = pcall(function()
    return game:HttpGet(loader)
end)

if not success then
    warn("Failed to connect to authentication server.")
    game.Players.LocalPlayer:Kick("Authentication server unreachable.")
    return
end

local loaderFunc = loadstring(response)
if not loaderFunc then
    game.Players.LocalPlayer:Kick("Failed to load authentication script.")
    return
end

local verify = loaderFunc()

local result = false
pcall(function()
    result = verify(script_key)
end)

if not result then
    game.Players.LocalPlayer:Kick("Invalid Script Key")
    return
end

print("V3.2.1 | Custom Features")
