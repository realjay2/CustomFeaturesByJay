-- Wait until WindUI and Functions are loaded
repeat task.wait() until _G.WindUI and _G.Functions

local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-------------------------------------------------
-- Fake Chat V2
-------------------------------------------------

Tabs.Custom:Section({
    Title = "Fake Chat V2",
    TextSize = 18,
})

_G.FakeChatEnabled = false
_G.FakeChatUser = LocalPlayer.Name

-- Toggle FakeChat (also TP to user when enabled)
Tabs.Custom:Toggle({
    Title = "Toggle FakeChat",
    Desc = "Enable fake chat system + teleport to FakeChat User",
    Default = false,
    Callback = function(value)
        _G.FakeChatEnabled = value

        if value then
            -- REQUIREMENTS: Need invisibility OR disable TP check
            if not (_G.Invisibility == true or (_G.Functions and _G.Functions:IsGodModeEnabled())) then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Need Invisibility OR Disable TP Check!",
                    Duration = 4
                })
                return
            end

            -- VALIDATION
            if not _G.FakeChatUser or _G.FakeChatUser == "" then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ No name set in FakeChat User!",
                    Duration = 3
                })
                return
            end

            local target = Players:FindFirstChild(_G.FakeChatUser)
            if not target or not target.Character then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Target player not found!",
                    Duration = 3
                })
                return
            end

            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if not targetRoot then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Target has no HumanoidRootPart!",
                    Duration = 3
                })
                return
            end

            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Your body isn't loaded!",
                    Duration = 3
                })
                return
            end

            -- PERFECT ALIGNMENT TELEPORT
            root.CFrame = targetRoot.CFrame

            WindUI:Notify({
                Title = "TP Success",
                Content = "✅ You are now inside " .. target.Name,
                Duration = 3
            })
        end
    end
})

-- FakeChat Username input
Tabs.Custom:Input({
    Title = "FakeChat User",
    Desc = "Name to appear in chat + TP target",
    Placeholder = LocalPlayer.Name,
    Callback = function(text)
        if text and text ~= "" then
            _G.FakeChatUser = text
        end
    end
})
