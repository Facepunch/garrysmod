
--[[---------------------------------------------------------
	Name: GetByAccountID( ID )
	Desc: Attempts to get the player by the AccountID
-----------------------------------------------------------]]
local AccountIDMap = {}

function player.GetByAccountID( ID )

	ID = tostring( ID )
	local ply = AccountIDMap[ID]

	if ( ply ) then
		return ply
	end

	return false

end

--[[---------------------------------------------------------
	Name: GetByUniqueID( ID )
	Desc: Attempts to get the player by the UniqueID
-----------------------------------------------------------]]
local UniqueIDMap = {}

function player.GetByUniqueID( ID )

	ID = tostring( ID )
	local ply = UniqueIDMap[ID]

	if ( ply ) then
		return ply
	end

	return false

end

--[[---------------------------------------------------------
	Name: GetBySteamID( ID )
	Desc: Attempts to get the player by the SteamID
-----------------------------------------------------------]]
local SteamIDMap = {}

function player.GetBySteamID( ID )

	ID = string.upper( tostring( ID ) )
	local ply = SteamIDMap[ID]

	if ( ply ) then
		return ply
	end

	return false

end

--[[---------------------------------------------------------
	Name: GetBySteamID64( ID )
	Desc: Attempts to get the player by the SteamID64
-----------------------------------------------------------]]
local SteamID64Map = {}

function player.GetBySteamID64( ID )

	ID = tostring( ID )
	local ply = SteamID64Map[ID]

	if ( ply ) then
		return ply
	end

	return false

end

--[[---------------------------------------------------------
	Manage the maps
-----------------------------------------------------------]]
hook.Add( "OnEntityCreated", "PlayerFinders", function( ent )

	if ( not ent:IsPlayer() ) then
		return
	end

	local ply = ent

	--
	-- Store in the maps
	--
	local AID = tostring( ply:AccountID() )
	local UID = tostring( ply:UniqueID() )
	local SID = ply:SteamID()
	local S64 = ply:SteamID64()

	AccountIDMap[AID] = ply
	AccountIDMap[ply] = AID

	UniqueIDMap[UID] = ply
	UniqueIDMap[ply] = UID

	SteamIDMap[SID] = ply
	SteamIDMap[ply] = SID

	SteamID64Map[S64] = ply
	SteamID64Map[ply] = S64

end )

hook.Add( "EntityRemoved", "PlayerFinders", function( ent, fullUpdate )

	if ( fullUpdate ) then
		return
	end

	if ( not ent:IsPlayer() ) then
		return
	end

	local ply = ent

	--
	-- Clear from the maps
	--
	local AID = AccountIDMap[ply]
	local UID = UniqueIDMap[ply]
	local SID = SteamIDMap[ply]
	local S64 = SteamID64Map[ply]

	AccountIDMap[AID] = nil
	AccountIDMap[ply] = nil

	UniqueIDMap[UID] = nil
	UniqueIDMap[ply] = nil

	SteamIDMap[SID] = nil
	SteamIDMap[ply] = nil

	SteamID64Map[S64] = nil
	SteamID64Map[ply] = nil

end )
