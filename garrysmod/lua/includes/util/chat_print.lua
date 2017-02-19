if SERVER then
	util.AddNetworkString("_ChatPrint")
end

if CLIENT then
	net.Receive("_ChatPrint", function()
		local parts = {}

		for _ = 1, net.ReadUInt(16) do
			parts[#parts + 1] = net.ReadType()
		end

		chat.AddText(parts)
	end)
end

local function WriteChatParts(...)
	local parts = {...}

	net.WriteUInt(#parts, 16)

	for i = 1, #parts do
		net.WriteType(parts[i])
	end
end

if CLIENT then
	ChatPrint = chat.AddText
else
	function ChatPrint(...)
		net.Start("_ChatPrint")
			WriteChatParts(...)
		net.Broadcast()
	end
end

local PLAYER = FindMetaTable("Player")
function PLAYER:ChatPrint(...)
	if CLIENT then
		if self == LocalPlayer() then
			chat.AddText(...)
		end
	else
		net.Start("_ChatPrint")
			WriteChatParts(...)
		net.Send(self)
	end
end
