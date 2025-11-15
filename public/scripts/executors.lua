local badExecutors = {
    ["Xeno"] = true,
    ["Solara"] = true,
}

return function()
    local execName = "Unknown"

    local s, r = pcall(function()
        return identifyexecutor and identifyexecutor()
    end)

    if s and typeof(r) == "string" then
        execName = r
    end

    if badExecutors[execName] then
        game.Players.LocalPlayer:Kick("Unsupported Executor: " .. execName)
        return
    end

    return execName
end
