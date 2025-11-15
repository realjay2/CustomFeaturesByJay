local required_key = "YglKravMHm"

if typeof(script_key) ~= "string" or script_key ~= required_key then
    if game and game.Players then
        game.Players.LocalPlayer:Kick("Missing or invalid Script Key.")
    end
    return 
end

print("UserID Encrypted")
