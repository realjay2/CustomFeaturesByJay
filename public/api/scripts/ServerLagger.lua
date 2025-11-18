repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions
local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CheckCallsign: RemoteFunction = game.ReplicatedStorage:WaitForChild("FE"):WaitForChild("CheckCallsign")
local CanChange: RemoteFunction = game.ReplicatedStorage:WaitForChild("FE"):WaitForChild("CanChangeTeam")
local TeamChangeRemote: RemoteEvent = game.ReplicatedStorage:WaitForChild("FE"):WaitForChild("TeamChange")
local GetWantedLevel = game:GetService("ReplicatedStorage").FE.GetWantedLevel

local ToolGiverRemote = nil
if _G.FE and typeof(_G.FE) == "table" and _G.FE.ToolGiver then
    ToolGiverRemote = _G.FE.ToolGiver
elseif ReplicatedStorage:FindFirstChild("ToolGiver") then
    ToolGiverRemote = ReplicatedStorage:FindFirstChild("ToolGiver")
elseif ReplicatedStorage:FindFirstChild("FE") and ReplicatedStorage.FE:FindFirstChild("ToolGiver") then
    ToolGiverRemote = ReplicatedStorage.FE.ToolGiver
end

local function isOilAbsorbentName(name)
    if not name then return false end
    return name == "OilAbsorbent" or name == "Oil Absorbent"
end

_G.CrasherConn = _G.CrasherConn or nil

Tabs.Custom:Section({
    Title = "Trolling Features"
})

generateCallsign = function()
	local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local function randomLetters(count)
		local result = ""
		for _ = 1, count do
			local index = math.random(1, #letters)
			result = result .. letters:sub(index, index)
		end
		return result
	end

	local function randomNumbers(min, max)
		return tostring(math.random(min, max))
	end

	local prefix = randomLetters(2)
	local suffix = randomNumbers(10, 99)
	return prefix .. "-" .. suffix
end

CrasherExploit = Tabs.Custom:Toggle({
    Title = "Crash Server [Does not affect you]",
    Desc = "Starts lagging the server.",
    Value = false,
    Callback = function(Value)
        if Value then

            local FireTeam = game.Teams:FindFirstChild("Fire")
            if FireTeam then
                if LocalPlayer.Team ~= FireTeam then

                    local ok, result = pcall(function()
                        return CanChange:InvokeServer(FireTeam)
                    end)

                    if not ok then
                            print("Failure: " .. tostring(result))
                        return
                    elseif result == "Full" then
                            print("Failure: Team is full")
                        return
                    elseif result == "Good" then
                        local Callsign = generateCallsign()

                        local csOK, csRes = pcall(function()
                            return CheckCallsign:InvokeServer(Callsign)
                        end)

                        if csOK and csRes then
                            pcall(function()
                                TeamChangeRemote:FireServer(FireTeam, Callsign)
                            end)
                        else
                                print("Failure: Callsign rejected")
                            return
                        end
                    end
                end
            end
            
            wait(1)

            if not ToolGiverRemote then
                WindUI:Notify({
                    Title = "Server Crasher",
                    Content = "ToolGiver remote not found. Can't get tool.",
                    Duration = 4,
                })

                pcall(function() CrasherExploit:Set(false) end)
                return
            end

            if _G.CrasherConn then
                pcall(function() _G.CrasherConn:Disconnect() end)
                _G.CrasherConn = nil
            end
            _G.CrasherConn = workspace.ChildAdded:Connect(function(obj)
                if isOilAbsorbentName(obj.Name) then
                    task.delay(0.01, function()
                        pcall(function() obj:Destroy() end)
                    end)
                end
            end)

            local hasInCharacter = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Oil Absorbent")
            local hasInBackpack = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Oil Absorbent")

            if not hasInCharacter and not hasInBackpack then
                pcall(function()
                    ToolGiverRemote:FireServer("Oil Absorbent")
                end)

                WindUI:Notify({
                    Title = "Server Crasher",
                    Content = "Attempting to equip Tool!",
                    Duration = 1.2,
                })

                local Start = tick()
                while not (LocalPlayer.Backpack:FindFirstChild("Oil Absorbent") or LocalPlayer.Character:FindFirstChild("Oil Absorbent")) and tick() - Start < 1 do
                    task.wait()
                end
            end

            if LocalPlayer.Backpack:FindFirstChild("Oil Absorbent") then
                pcall(function()
                    LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Oil Absorbent"))
                end)
                task.wait()
            end

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Oil Absorbent") then
                local OilTool = LocalPlayer.Character:FindFirstChild("Oil Absorbent")
                local CrasherEvent = OilTool:FindFirstChild("UseEvent") or OilTool:WaitForChild("UseEvent", 1)

                if not CrasherEvent then
                    WindUI:Notify({
                        Title = "TrollingFeatures",
                        Content = "Tool found but UseEvent missing.",
                        Duration = 4,
                    })
                    pcall(function() CrasherExploit:Set(false) end)
                    if _G.CrasherConn then pcall(function() _G.CrasherConn:Disconnect() end) _G.CrasherConn = nil end
                    return
                end

                pcall(function()
                    OilTool.Grip = CFrame.new(0,100,0)
                    for _, v in pairs(OilTool:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.Massless = true
                        end
                    end
                end)

                pcall(function()
                    LocalPlayer.Character.Humanoid:UnequipTools()
                end)
                task.wait(0.001)
                pcall(function()
                    LocalPlayer.Character.Humanoid:EquipTool(OilTool)
                end)

                task.spawn(function()
                    while task.wait(0.001) do
                        if not CrasherExploit.Value then
                            break
                        end

                        pcall(function()
                            for i, v in pairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                                if v.Name == "ToolNoneAnim" then
                                    v:Stop()
                                end
                            end
                        end)

                        for i = 1, 24 do
                            pcall(function() CrasherEvent:FireServer(true) end)
                        end
                    end
                end)
            else

                WindUI:Notify({
                    Title = "TrollingFeatures",
                    Content = "You need to have the FD Oil Absorbent Tool.",
                    Duration = 5,
                })
                pcall(function() CrasherExploit:Set(false) end)
                if _G.CrasherConn then pcall(function() _G.CrasherConn:Disconnect() end) _G.CrasherConn = nil end
            end
        else
            if _G.CrasherConn then
                pcall(function() _G.CrasherConn:Disconnect() end)
                _G.CrasherConn = nil
            end
        end
    end,
})
