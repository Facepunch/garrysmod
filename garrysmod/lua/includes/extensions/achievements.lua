if SERVER then
	util.AddNetworkString("achievements")
	achievements = { }
end

function achievements.Call(ply, aID, removerCount)
	if (CLIENT) then return end
	net.WriteUInt(aID, 3)

	if (aID == 2) then
		net.WriteUInt(removerCount, 16)
	end

	net.Send(ply)
end

if CLIENT then
	local idToAchievement = {
		[0] = achievements.BalloonPopped,
		achievements.EatBall,
		achievements.Remover,
		achievements.SpawnedNPC,
		achievements.SpawnedProp,
		achievements.SpawnedRagdoll
	}

	net.Receive("achievements", function()
		local aID = net.ReadUInt(3)

		if (aID == 2) then
			local func = idToAchievement[aID]

			for k = 1, net.ReadUInt(16) do
				func()
			end
		else
			idToAchievement[aID]()
		end
	end)
end
