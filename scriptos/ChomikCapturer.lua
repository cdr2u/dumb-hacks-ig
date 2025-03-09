local fuck = game:GetService("BadgeService")

for _,v in game.Workspace.chomiki:GetDescendants() do
	if v:IsA("BasePart") then
		warn(v.Name)
		if v.Parent == game.Workspace.chomiki then
			print(v.BadgeID.Value)
			if not fuck:UserHasBadgeAsync(game.Players.LocalPlayer.UserId, v.BadgeID.Value) then
				v.CanTouch = true
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.chomiki[v.Name].CFrame
			end
		end
		task.wait(1)
	end
end
