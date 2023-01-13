
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
	if ( val != nil ) then return val end

	--
	-- Search the entity metatable
	--
	local val = entity[key]
	if ( val != nil ) then return val end

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

-- These are totally in the wrong place.
function player.GetByAccountID( ID )
	local players = player.GetAll()
	for i = 1, #players do
		if ( players[i]:AccountID() == ID ) then
			return players[i]
		end
	end
	
	return false
end

function player.GetByUniqueID( ID )
	local players = player.GetAll()
	for i = 1, #players do
		if ( players[i]:UniqueID() == ID ) then
			return players[i]
		end
	end
	
	return false
end

function player.GetBySteamID( ID )
	ID = string.upper( ID )
	local players = player.GetAll()
	for i = 1, #players do
		if ( players[i]:SteamID() == ID ) then
			return players[i]
		end
	end
	
	return false
end

function player.GetBySteamID64( ID )
	ID = tostring( ID )
	local players = player.GetAll()
	for i = 1, #players do
		if ( players[i]:SteamID64() == ID ) then
			return players[i]
		end
	end
	
	return false
end

if (SERVER) then
	util.AddNetworkString("GMOD_player_SendMsg_Text")
	util.AddNetworkString("GMOD_player_SendMsg_Color")

	local function SendMsgError(uArg, v)
		error(string.format("bad argument #%u to player.SendMsg (string or Color expected, got %s)",
			uArg + 1, type(v)), 3)
	end

	function player.SendMsg(filter, ...)
		local tParts = {...}
		local bLastString = false

		local bFirstColor = false
		local tWriteParts = {}
		local uWriteParts = 0

		for i = 1, select("#", ...) do
			local part = tParts[i]

			if (bLastString) then
				if (IsTableColor(part, false)) then
					uWriteParts = uWriteParts + 1
					tWriteParts[uWriteParts] = part
					bLastString = false
				elseif (isstring(part)) then
					tWriteParts[uWriteParts] = tWriteParts[uWriteParts] .. part
				else
					SendMsgError(i, part)
				end
			elseif (isstring(part)) then
				uWriteParts = uWriteParts + 1
				tWriteParts[uWriteParts] = part
				bLastString = true
			elseif (IsTableColor(part, false)) then
				if (tWriteParts == 0) then
					bFirstColor = true
					uWriteParts = uWriteParts + 1
				end

				tWriteParts[uWriteParts] = part
			else
				SendMsgError(i, part)
			end
		end

		if (bFirstColor) then
			-- Don't proceed if there's nothing to send
			if (uWriteParts == 1) then return end

			net.Start("GMOD_player_SendMsg_Color")
			net.WriteUInt(uWriteParts, 32)
		else
			if (uWriteParts == 0) then return end

			net.Start("GMOD_player_SendMsg_Text")
			net.WriteUInt(uWriteParts, 32)

			-- Align for the loop below
			net.WriteString(tWriteParts[1])
		end

		for i = bFirstColor and 1 or 2, uWriteParts, 2 do
			net.WriteColor(tWriteParts[i], false)
			net.WriteString(tWriteParts[i + 1])
		end

		net.Send(filter)
	end
else
	net.Receive("GMOD_player_SendMsg_Text", function()
		local uPartCount = net.ReadUInt(32)

		if (uPartCount == 0) then return end

		local tParts = {}
		tParts[1] = net.ReadString()

		for i = 2, uPartCount, 2 do
			tParts[i] = net.ReadColor(false)
			tParts[i + 1] = net.ReadString()
		end

		chat.AddText(unpack(tParts))
	end)

	net.Receive("GMOD_player_SendMsg_Color", function()
		local uPartCount = net.ReadUInt(32)

		if (uPartCount == 0) then return end

		local tParts = {}

		for i = 1, uPartCount, 2 do
			tParts[i] = net.ReadColor(false)
			tParts[i + 1] = net.ReadString()
		end

		chat.AddText(unpack(tParts))
	end)
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

		if ( bSkipQueue || IsConCommandBlocked( command ) ) then
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

	name = Format( "%s[%s]", self:UniqueID(), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr( name ) .. " LIMIT 1" )
	if ( val == nil ) then return default end

	return val

end

--[[---------------------------------------------------------
	SetPData
	Set persistant data
-----------------------------------------------------------]]
function meta:SetPData( name, value )

	name = Format( "%s[%s]", self:UniqueID(), name )
	return sql.Query( "REPLACE INTO playerpdata ( infoid, value ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( value ) .. " )" ) ~= false

end

--[[---------------------------------------------------------
	RemovePData
	Remove persistant data
-----------------------------------------------------------]]
function meta:RemovePData( name )

	name = Format( "%s[%s]", self:UniqueID(), name )
	return sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( name ) ) ~= false

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
