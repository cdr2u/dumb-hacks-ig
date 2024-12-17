task.spawn(function()
    while wait(.1) do
      for _,v in pairs(workspace.socky:GetDescendants()) do
        if v:IsA("Part") then
          v.CanCollide = false
        end
      end
      workspace.socky.Torso.CFrame = game.Players.LocalPlayer.Character.Torso.CFrame + Vector3.new(0, 4, 0)
    end
end)

game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
    workspace.socky.Humanoid.Health = 0
end)
