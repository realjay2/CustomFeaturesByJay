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
_G.FakeChatLooping = false

-- Function to noclip entire character
local function NoclipCharacter(character)
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide ~= false then
                part.CanCollide = false
            end
        end
    end
end

-- Toggle FakeChat (also TP to user and follow while enabled)
Tabs.Custom:Toggle({
    Title = "Toggle FakeChat",
    Desc = "Teleport to person, and speak for them. (Requires Invisibility)",
    Default = false,
    Callback = function(value)
        _G.FakeChatEnabled = value

        if value then
            -- REQUIREMENTS: BOTH invisibility AND disable TP check must be true
            if not (_G.Invisibility == true or (_G.Functions and _G.Functions:IsGodModeEnabled())) then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ You must have Invisibility AND Disable TP Check enabled!",
                    Duration = 4
                })
                _G.FakeChatEnabled = false
                return
            end

            -- VALIDATION
            if not _G.FakeChatUser or _G.FakeChatUser == "" then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ No name set in FakeChat User!",
                    Duration = 3
                })
                _G.FakeChatEnabled = false
                return
            end

            local target = Players:FindFirstChild(_G.FakeChatUser)
            if not target or not target.Character then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Target player not found!",
                    Duration = 3
                })
                _G.FakeChatEnabled = false
                return
            end

            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if not targetRoot then
                WindUI:Notify({
                    Title = "TP Error",
                    Content = "❌ Target has no HumanoidRootPart!",
                    Duration = 3
                })
                _G.FakeChatEnabled = false
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
                _G.FakeChatEnabled = false
                return
            end

            -- Start looping follow & noclip
            if not _G.FakeChatLooping then
                _G.FakeChatLooping = true
                task.spawn(function()
                    while _G.FakeChatEnabled do
                        local char = LocalPlayer.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        local target = Players:FindFirstChild(_G.FakeChatUser)
                        local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                        if char and root and targetRoot then
                            -- Perfect inside body
                            root.CFrame = targetRoot.CFrame
                            -- Full-body noclip
                            NoclipCharacter(char)
                        end
                        task.wait(0.03) -- smooth follow
                    end
                    _G.FakeChatLooping = false
                end)
            end

            WindUI:Notify({
                Title = "TP Success",
                Content = "✅ You are now following " .. target.Name .. " with full noclip",
                Duration = 3
            })
        end
    end
})

-- FakeChat Username input
Tabs.Custom:Input({
    Title = "FakeChat User",
    Desc = "User to FakeChat",
    Placeholder = LocalPlayer.Name,
    Callback = function(text)
        if text and text ~= "" then
            _G.FakeChatUser = text
        end
    end
})
