repeat task.wait() until _G.WindUI and _G.Tabs and _G.Functions
local WindUI = _G.WindUI
local Tabs = _G.Tabs
local Functions = _G.Functions

Tabs.Settings:Button({
		Title = "Rejoin Game",
		Callback = function()
			WindUI:Notify({ Title = "[ERX]", Content = "Rejoining Game.", Duration = 3 })
			wait(2)
			local TeleportService = game:GetService("TeleportService")
			local Players = game:GetService("Players")
			local LocalPlayer = Players.LocalPlayer

			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end
	})
