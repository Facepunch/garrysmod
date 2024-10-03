
local meta = FindMetaTable( "Player" )
local entity = FindMetaTable( "Entity" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

--
-- Entity index accessor. This used to be done in engine, but it's done in Lua now because it's faster
--
function meta:__index( key )

	--
	-- Search the metatable. We can do this without dipping into C, so we do it first.
	--
	local val = meta[key]
	if ( val ~= nil ) then return val end

	--
	-- Search the entity metatable
	--
	local entval = entity[key]
	if ( entval ~= nil ) then return entval end

	--
	-- Search the entity table
	--
	local tab = entity.GetTable( self )
	if ( tab ) then
		return tab[ key ]
	end

	return nil

end

if ( !sql.TableExists( "playerpdata" ) ) then

	sql.Query( "CREATE TABLE IF NOT EXISTS playerpdata ( infoid TEXT NOT NULL PRIMARY KEY, value TEXT );" )

end

--[[---------------------------------------------------------
	Name: DebugInfo
	Desc: Prints debug information for the player
		( this is just an example )
-----------------------------------------------------------]]
function meta:DebugInfo()

	Msg( "Name: " .. self:Name() .. "\n" )
	Msg( "Pos: " .. tostring( self:GetPos() ) .. "\n" )

end

-- Helpful aliases
meta.GetName = meta.Nick
meta.Name = meta.Nick

--[[---------------------------------------------------------
	Name: ConCommand
	Desc: Overrides the default ConCommand function
-----------------------------------------------------------]]
if ( CLIENT ) then

	local SendConCommand = meta.ConCommand
	local CommandList = nil

	function meta:ConCommand( command, bSkipQueue )

		if ( bSkipQueue or IsConCommandBlocked( command ) ) then
			SendConCommand( self, command )
		else
			CommandList = CommandList or {}
			table.insert( CommandList, command )
		end

	end

	local function SendQueuedConsoleCommands()

		if ( !CommandList ) then return end

		local BytesSent = 0

		for k, v in pairs( CommandList ) do

			SendConCommand( LocalPlayer(), v )
			CommandList[ k ] = nil

			-- Only send x bytes per tick
			BytesSent = BytesSent + v:len()
			if ( BytesSent > 128 ) then
				break
			end

		end

		-- Turn the table into a nil so we can return easy
		if ( table.IsEmpty( CommandList ) ) then

			CommandList = nil

		end

	end

	hook.Add( "Tick", "SendQueuedConsoleCommands", SendQueuedConsoleCommands )

end

--[[---------------------------------------------------------
	GetPData
	Saves persist data for this player
-----------------------------------------------------------]]
function meta:GetPData( name, default )

	-- First try looking up using the new key
	local key = Format( "%s[%s]", self:SteamID64(), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr( key ) .. " LIMIT 1" )
	if ( val == nil ) then

		-- Not found? Look using the old key
		local oldkey = Format( "%s[%s]", self:UniqueID(), name )
		val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr( oldkey ) .. " LIMIT 1" )
		if ( val == nil ) then return default end

	end

	return val

end

--[[---------------------------------------------------------
	SetPData
	Set persistant data
-----------------------------------------------------------]]
function meta:SetPData( name, value )

	-- Remove old value
	local oldkey = Format( "%s[%s]", self:UniqueID(), name )
	sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( oldkey ) )

	local key = Format( "%s[%s]", self:SteamID64(), name )
	return sql.Query( "REPLACE INTO playerpdata ( infoid, value ) VALUES ( " .. SQLStr( key ) .. ", " .. SQLStr( value ) .. " )" ) ~= false

end

--[[---------------------------------------------------------
	RemovePData
	Remove persistant data
-----------------------------------------------------------]]
function meta:RemovePData( name )

	-- First old key
	local oldkey = Format( "%s[%s]", self:UniqueID(), name )
	local removed = sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( oldkey ) ) ~= false

	-- Then new key
	local key = Format( "%s[%s]", self:SteamID64(), name )
	local removed2 = sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( key ) ) ~= false

	return removed or removed2

end

--
-- If they have their preferred default weapon then switch to it
--
function meta:SwitchToDefaultWeapon()

	local weapon = self:GetInfo( "cl_defaultweapon" )

	if ( self:HasWeapon( weapon ) ) then
		self:SelectWeapon( weapon )
	end

end

--
-- Can use flashlight?
--
function meta:AllowFlashlight( bAble ) self.m_bFlashlight = bAble end
function meta:CanUseFlashlight() return self.m_bFlashlight == true end

-- A function to set up player hands, so coders don't have to copy all the code everytime.
-- Call this in PlayerSpawn hook
function meta:SetupHands( ply )

	local oldhands = self:GetHands()
	if ( IsValid( oldhands ) ) then
		oldhands:Remove()
	end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		hands:DoSetup( self, ply )
		hands:Spawn()
	end

end

--
-- Those functions have been removed from the engine since AddFlag and RemoveFlag
-- made them obsolete, but we'll keep a Lua version of them for backward compatibility
--
if ( SERVER ) then

--[[---------------------------------------------------------
	Freeze
	Freezes or unfreezes the player
-----------------------------------------------------------]]
function meta:Freeze( b )

	if ( b ) then
		self:AddFlags( FL_FROZEN )
	else
		self:RemoveFlags( FL_FROZEN )
	end

end

--[[---------------------------------------------------------
	GodEnable
	Enables godmode on the player
-----------------------------------------------------------]]
function meta:GodEnable()

	self:AddFlags( FL_GODMODE )

end

--[[---------------------------------------------------------
	GodDisable
	Disables godmode on the player
-----------------------------------------------------------]]
function meta:GodDisable()

	self:RemoveFlags( FL_GODMODE )

end

end

--[[---------------------------------------------------------
	IsFrozen
	Returns true if the player is frozen
-----------------------------------------------------------]]
function meta:IsFrozen()

	return self:IsFlagSet( FL_FROZEN )

end

--[[---------------------------------------------------------
	HasGodMode
	Returns true if the player is in godmode
-----------------------------------------------------------]]
function meta:HasGodMode()

	return self:IsFlagSet( FL_GODMODE )

end

-- These are totally in the wrong place.
local accountID={}
local uniqueID={}
local steamID64={}
local steamID={}
local bots={}
function player.GetByAccountID( ID )
	local ret = accountID[ID]
	if ( ret and ret:IsValid() ) then
		return ret
	end

	return false
end

function player.GetByUniqueID( ID )
	local ret = uniqueID[ID]
	if ( ret and ret:IsValid() ) then
		return ret
	end
	return false
end

function player.GetBySteamID( ID )
	ID = string.upper( ID )
	local ret = steamID[ID]--ret could be nil if there was never an entry, or NULL if the player DCed
	if ( ret and ret:IsValid() ) then
		return ret
	end
	if ( ret and ID=="BOT" ) then--the original function would return the first bot it could find,
		while ( ret ) do
			ret = bots[1]--get the first bot on the list
			if ( not ret ) then--bots is now empty, we failed
				steamID.BOT = nil
				return false
			end
			if ( ret:IsValid() ) then--is it a valid entity?
				steamID.BOT = ret--update entry for BOT so that hopefully we don't have to do this again
				return ret--return the bot
			end
			table.remove(bots,1)--remove a null entity from the list
		end
	end

	return false
end

function player.GetBySteamID64( ID )
	ID = tostring( ID )
	local ret = steamID64[ID]
	if ( ret and ret:IsValid() ) then
		return ret
	end

	return false
end

local inext = ipairs( {} )
local PlayerCache = nil

function player.Iterator()

	if ( PlayerCache == nil ) then PlayerCache = player.GetAll() end

	return inext, PlayerCache, 0

end

hook.Add( "OnEntityCreated", "PlayerCache", function( ent )
	if ( ent:IsPlayer() ) then 
		PlayerCache = player.GetAll()
		accountID[ent:AccountID()] = ent
		if ( CLIENT ) then--workaround to https://github.com/Facepunch/garrysmod-issues/issues/6012
			uniqueID[ ent:UniqueID() ] = ent
		else
			timer.Simple(0, function()
				if ent:IsValid()then
					uniqueID[ ent:UniqueID() ] = ent
				end
			end)
		end
		steamID64[ent:SteamID64()] = ent
		local ID=ent:SteamID()
		if ( ID == "BOT" ) then--if a bot joined, we got a bit more work to do
			bots = {}--lets rebuild the bot cache
			for i = 1, #PlayerCache do
				local p = PlayerCache[i]
				if ( p:SteamID() == "BOT" ) then--this is more reliable than Player:IsBot() which checks entity flags that may be added or removed
					table.insert(bots, p)
					steamID.BOT = steamID.BOT or p
				end
			end
		else
			steamID[ID] = ent
		end
	end
end )
hook.Add( "EntityRemoved", "PlayerCache", function( ent )
	if ( ent:IsPlayer() ) then 
		PlayerCache = nil
	end
end )
