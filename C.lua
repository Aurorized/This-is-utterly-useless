local base; 
for i, v in pairs(workspace.Tycoons:GetChildren()) do
    if v.Owner.Value == game.Players.LocalPlayer.Name then
        base = v 
    end
end
--[[if base:FindFirstChild("Heavenly Conveyor") then
    base:FindFirstChild("Heavenly Conveyor").Touched:Connect(function(ore) 
        function teleport(item)
            if base[item].Model:FindFirstChild("Upgrade") then
                wait(0.01)
                ore.CFrame = base[item].Model:FindFirstChild("Upgrade").CFrame
            end
        end
        function Loop()
            
        end
        Loop()
        teleport("Tesla")
        Loop()
        teleport("The Final Upgrader")
        Loop()
        teleport("Daestrophe")
        Loop()
        teleport("Void Star")
        Loop()

    end)
end]]
wait(1)
for i, v in pairs(workspace.DroppedParts[base.Name]:GetChildren()) do
    game:GetService("ReplicatedStorage").Pulse:FireServer()
    if v.Name == "Gargantium Mine" then
        function t(...)
            local args = {...}
            local Upgrader = args[1]
            local x = args[2] or 0 
            local y = args[3] or 0
            local z = args[4] or 0
            if base[Upgrader].Model:FindFirstChild("Upgrade") then
                wait(0.01)
                v.CFrame = base[Upgrader].Model:FindFirstChild("Upgrade").CFrame + Vector3.new(x, y, z)
            end
        end
        t("Angel's Blessing")
        t("Empyrean Monument", 0, 6, 0)
    end
end
