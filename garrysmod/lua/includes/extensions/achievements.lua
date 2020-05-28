local bitsize = 0
local achievementsN = 0
local achievementsLookup = {}

if SERVER then
	util.AddNetworkString("achievements")
	achievements = {}

	function achievements.Call(ply, aName, data)
		local aID = achievementsLookup[aName]
		if (not aID) then error("Attempt to call unregistered achievement (" .. tostring(aName) .. ")") end
		net.Start("achievements")
		net.WriteUInt(aID, bitsize)

		if (data) then
			net.WriteUInt(data, 16)
		end

		net.Send(ply)
	end
end

function achievements.Register(name,func)
	if CLIENT and not isfunction(func) then error("Second argument must be a function") end

	if (SERVER) then
		achievementsLookup[name] = achievementsN
	else
		achievementsLookup[achievementsN] = func
	end

	achievementsN = achievementsN + 1
	bitsize = math.ceil(math.log(achievementsN + 1, 2))
end

if CLIENT then
	net.Receive("achievements", function()
		local aID = net.ReadUInt(bitsize)
		local func = achievementsLookup[aID]

		if (func) then
			func(net.ReadUInt(16))
		end
	end)
end

achievements.Register("BalloonPopped",achievements.BalloonPopped)
achievements.Register("EatBall",achievements.EatBall)
achievements.Register("Remover",function(count) for i = 1, count do achievements.Remover() end end)
achievements.Register("SpawnedNPC",achievements.SpawnedNPC)
achievements.Register("SpawnedProp",achievements.SpawnedProp)
achievements.Register("SpawnedRagdoll",achievements.SpawnedRagdoll)
