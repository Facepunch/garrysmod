
--
-- Validator
--
local player_metatable = FindMetaTable( "Player" )

local function Validate( idType, id, map )

	local GetThisID = player_metatable[idType]

	for _, ply in player.Iterator() do

		if ( id == GetThisID( ply ) ) then

			map[id] = ply
			return ply

		end

	end

	return false

end

--[[---------------------------------------------------------
	Name: GetByAccountID( ID )
	Desc: Attempts to get the player by the passed AccountID
-----------------------------------------------------------]]
local AccountIDMap = {}

function player.GetByAccountID( ID )

	local ply = AccountIDMap[ID]

	if ( IsValid( ply ) ) then
		return ply
	end

	return Validate( "AccountID", ID, AccountIDMap )

end

--[[---------------------------------------------------------
	Name: GetByUniqueID( ID )
	Desc: Attempts to get the player by the passed UniqueID
-----------------------------------------------------------]]
local UniqueIDMap = {}

function player.GetByUniqueID( ID )

	local ply = UniqueIDMap[ID]

	if ( IsValid( ply ) ) then
		return ply
	end

	return Validate( "UniqueID", ID, UniqueIDMap )

end

--[[---------------------------------------------------------
	Name: GetBySteamID( ID )
	Desc: Attempts to get the player by the passed SteamID
-----------------------------------------------------------]]
local SteamIDMap = {}

function player.GetBySteamID( ID )

	ID = string.upper( ID )
	local ply = SteamIDMap[ID]

	if ( IsValid( ply ) ) then
		return ply
	end

	return Validate( "SteamID", ID, SteamIDMap )

end

--[[---------------------------------------------------------
	Name: GetBySteamID64( ID )
	Desc: Attempts to get the player by the passed SteamID64
-----------------------------------------------------------]]
local SteamID64Map = {}

function player.GetBySteamID64( ID )

	local ply = SteamID64Map[ID]

	if ( IsValid( ply ) ) then
		return ply
	end

	return Validate( "SteamID64", ID, SteamID64Map )

end

--
-- GC for the maps
--
local inext = ipairs( {} )
local next = next

local maps = { AccountIDMap; UniqueIDMap; SteamIDMap; SteamID64Map }

local function PlayerFindersGC()

	local IsValid = IsValid

	for _, map in inext, maps, 0 do

		for id, ply in next, map do

			if ( not IsValid( ply ) ) then
				map[id] = nil
			end

		end

	end

end

timer.Create( "PlayerFinders_GC", 30, 0, PlayerFindersGC )
