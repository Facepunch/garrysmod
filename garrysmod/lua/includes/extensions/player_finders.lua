
--[[---------------------------------------------------------
	Name: GetByAccountID( ID )
	Desc: Attempts to get the player by the AccountID
-----------------------------------------------------------]]
local AccountIDMap = setmetatable( {}, { __mode = 'v' } )

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
local UniqueIDMap = setmetatable( {}, { __mode = 'v' } )

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
local SteamIDMap = setmetatable( {}, { __mode = 'v' } )

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
local SteamID64Map = setmetatable( {}, { __mode = 'v' } )

function player.GetBySteamID64( ID )

	ID = tostring( ID )
	local ply = SteamID64Map[ID]

	if ( ply ) then
		return ply
	end

	return false

end

--[[---------------------------------------------------------
	Update the maps
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
	AccountIDMap[AID] = ply

	local UID = tostring( ply:UniqueID() )
	UniqueIDMap[UID] = ply

	local SID = ply:SteamID()
	SteamIDMap[SID] = ply

	local S64 = ply:SteamID64()
	SteamID64Map[S64] = ply

end )
