---------------
	NET DELTA COMPRESSION & CHUNKED TRANSFER

	Two features in one file:

	1. DELTA COMPRESSION
	   Only sends fields that changed since the last transmission.
	   Tracks per-player, per-channel state tables.

	2. CHUNKED TRANSFER
	   Splits large payloads past the 64KB net message limit
	   into multiple messages and reassembles at the receiver.

	Both work on top of the existing net library.
----------------


---------------
	DELTA COMPRESSION

	Usage:
		-- Define a channel schema (same on server + client)
		local schema = {
			{ "health", "uint16" },
			{ "armor", "uint16" },
			{ "pos", "vector" },
			{ "name", "string" },
		}

		-- Server: send only changed fields
		net.Start( "PlayerSync" )
		net.WriteDelta( "player_data", schema, {
			health = ply:Health(),
			armor = ply:Armor(),
			pos = ply:GetPos(),
			name = ply:Nick(),
		}, ply )   -- pass target player for per-player state tracking
		net.Send( ply )

		-- Client: receive and apply delta
		net.Receive( "PlayerSync", function( len )
			local data = net.ReadDelta( "player_data", schema )
			-- data contains the full merged state
		end )
----------------

-- Per-player, per-channel state tracking (server side)
local ServerState = {}		-- [playerSteamID][channel] = { field = value }

-- Client-side state tracking
local ClientState = {}		-- [channel] = { field = value }

-- Writers and readers matching net.lua PackedWriters/PackedReaders
local DeltaWriters = {
	["string"]	= function( v ) net.WriteString( v ) end,
	["bool"]	= function( v ) net.WriteBool( v ) end,
	["float"]	= function( v ) net.WriteFloat( v ) end,
	["double"]	= function( v ) net.WriteDouble( v ) end,
	["int8"]	= function( v ) net.WriteInt( v, 8 ) end,
	["int16"]	= function( v ) net.WriteInt( v, 16 ) end,
	["int32"]	= function( v ) net.WriteInt( v, 32 ) end,
	["uint8"]	= function( v ) net.WriteUInt( v, 8 ) end,
	["uint16"]	= function( v ) net.WriteUInt( v, 16 ) end,
	["uint32"]	= function( v ) net.WriteUInt( v, 32 ) end,
	["vector"]	= function( v ) net.WriteVector( v ) end,
	["angle"]	= function( v ) net.WriteAngle( v ) end,
	["entity"]	= function( v ) net.WriteEntity( v ) end,
	["color"]	= function( v ) net.WriteColor( v ) end,
}

local DeltaReaders = {
	["string"]	= function() return net.ReadString() end,
	["bool"]	= function() return net.ReadBool() end,
	["float"]	= function() return net.ReadFloat() end,
	["double"]	= function() return net.ReadDouble() end,
	["int8"]	= function() return net.ReadInt( 8 ) end,
	["int16"]	= function() return net.ReadInt( 16 ) end,
	["int32"]	= function() return net.ReadInt( 32 ) end,
	["uint8"]	= function() return net.ReadUInt( 8 ) end,
	["uint16"]	= function() return net.ReadUInt( 16 ) end,
	["uint32"]	= function() return net.ReadUInt( 32 ) end,
	["vector"]	= function() return net.ReadVector() end,
	["angle"]	= function() return net.ReadAngle() end,
	["entity"]	= function() return net.ReadEntity() end,
	["color"]	= function() return net.ReadColor() end,
}


--
-- Compare two values for equality (handles vectors/angles)
--
local function ValuesEqual( a, b )
	if ( a == b ) then return true end
	if ( type( a ) != type( b ) ) then return false end

	-- Vector comparison
	if ( isvector( a ) ) then
		return a.x == b.x and a.y == b.y and a.z == b.z
	end

	-- Angle comparison
	if ( isangle( a ) ) then
		return a.pitch == b.pitch and a.yaw == b.yaw and a.roll == b.roll
	end

	return false
end


--
-- Server: Write only changed fields
--
function net.WriteDelta( channel, schema, data, targetPlayer )

	-- Get or create state for this player/channel
	local playerKey = IsValid( targetPlayer ) and targetPlayer:SteamID64() or "broadcast"

	if ( !ServerState[ playerKey ] ) then ServerState[ playerKey ] = {} end
	if ( !ServerState[ playerKey ][ channel ] ) then ServerState[ playerKey ][ channel ] = {} end

	local lastState = ServerState[ playerKey ][ channel ]

	-- Build bitmask of changed fields
	local changedBits = 0
	local numFields = #schema

	for i = 1, numFields do
		local fieldName = schema[ i ][ 1 ]
		if ( !ValuesEqual( data[ fieldName ], lastState[ fieldName ] ) ) then
			changedBits = bit.bor( changedBits, bit.lshift( 1, i - 1 ) )
		end
	end

	-- Write change bitmask (supports up to 32 fields)
	net.WriteUInt( changedBits, math.min( numFields, 32 ) )

	-- Write only changed fields
	for i = 1, numFields do
		if ( bit.band( changedBits, bit.lshift( 1, i - 1 ) ) != 0 ) then

			local field = schema[ i ]
			local writer = DeltaWriters[ field[ 2 ] ]

			if ( writer ) then
				writer( data[ field[ 1 ] ] )
			end
		end
	end

	-- Update stored state
	for i = 1, numFields do
		local fieldName = schema[ i ][ 1 ]
		lastState[ fieldName ] = data[ fieldName ]
	end

	return changedBits

end


--
-- Client: Read delta and merge with cached state
--
function net.ReadDelta( channel, schema )

	if ( !ClientState[ channel ] ) then ClientState[ channel ] = {} end

	local state = ClientState[ channel ]
	local numFields = #schema

	-- Read change bitmask
	local changedBits = net.ReadUInt( math.min( numFields, 32 ) )

	-- Read only changed fields and merge
	for i = 1, numFields do
		if ( bit.band( changedBits, bit.lshift( 1, i - 1 ) ) != 0 ) then

			local field = schema[ i ]
			local reader = DeltaReaders[ field[ 2 ] ]

			if ( reader ) then
				state[ field[ 1 ] ] = reader()
			end
		end
	end

	-- Return full merged state
	local result = {}
	for i = 1, numFields do
		local fieldName = schema[ i ][ 1 ]
		result[ fieldName ] = state[ fieldName ]
	end

	return result, changedBits

end


--
-- Reset delta state (call when player reconnects or state is invalid)
--
function net.ResetDelta( channel, targetPlayer )

	if ( SERVER ) then
		local playerKey = IsValid( targetPlayer ) and targetPlayer:SteamID64() or "broadcast"
		if ( ServerState[ playerKey ] ) then
			ServerState[ playerKey ][ channel ] = nil
		end
	else
		ClientState[ channel ] = nil
	end

end


-- Clean up state when player disconnects
if ( SERVER ) then
	hook.Add( "PlayerDisconnected", "NetDelta_Cleanup", function( ply )
		local key = ply:SteamID64()
		if ( key ) then
			ServerState[ key ] = nil
		end
	end )
end


---------------
	CHUNKED TRANSFER

	Splits large data payloads into multiple net messages.
	Automatically reassembles on the receiver.

	Usage:
		-- Server
		local bigData = util.TableToJSON( massiveTable )
		net.WriteChunked( "BigTransfer", bigData, ply )

		-- Client
		net.ReceiveChunked( "BigTransfer", function( data )
			local tbl = util.JSONToTable( data )
			-- Process complete data
		end )
----------------

local CHUNK_SIZE = 60000		-- bytes per chunk (below 64KB net limit)
local ChunkBuffers = {}			-- [channel] = { chunks = {}, expected = 0 }


--
-- Send large data in chunks
--
function net.WriteChunked( channel, data, target )

	local totalLen = string.len( data )
	local numChunks = math.ceil( totalLen / CHUNK_SIZE )

	for i = 1, numChunks do

		local startPos = ( i - 1 ) * CHUNK_SIZE + 1
		local endPos = math.min( i * CHUNK_SIZE, totalLen )
		local chunk = string.sub( data, startPos, endPos )

		net.Start( "_chunk_" .. channel )
		net.WriteUInt( i, 16 )				-- chunk index
		net.WriteUInt( numChunks, 16 )		-- total chunks
		net.WriteUInt( totalLen, 32 )		-- total data length
		net.WriteData( chunk, #chunk )

		if ( SERVER ) then
			if ( target ) then
				net.Send( target )
			else
				net.Broadcast()
			end
		else
			net.SendToServer()
		end

	end

end


--
-- Register a chunked receiver
-- The net message "_chunk_<channel>" must be registered with util.AddNetworkString
--
function net.ReceiveChunked( channel, callback )

	local netName = "_chunk_" .. channel

	-- Auto-register network string on server
	if ( SERVER and util.AddNetworkString ) then
		util.AddNetworkString( netName )
	end

	net.Receive( netName, function( len, client )

		local chunkIndex = net.ReadUInt( 16 )
		local numChunks = net.ReadUInt( 16 )
		local totalLen = net.ReadUInt( 32 )

		-- Calculate this chunk's size
		local chunkLen
		if ( chunkIndex == numChunks ) then
			chunkLen = totalLen - ( numChunks - 1 ) * CHUNK_SIZE
		else
			chunkLen = CHUNK_SIZE
		end

		local chunkData = net.ReadData( chunkLen )

		-- Store in buffer
		local bufferKey = channel .. "_" .. ( IsValid( client ) and client:SteamID64() or "server" )

		if ( !ChunkBuffers[ bufferKey ] ) then
			ChunkBuffers[ bufferKey ] = { chunks = {}, expected = numChunks }
		end

		local buffer = ChunkBuffers[ bufferKey ]
		buffer.chunks[ chunkIndex ] = chunkData

		-- Check if all chunks received
		local received = 0
		for k, v in pairs( buffer.chunks ) do
			received = received + 1
		end

		if ( received >= numChunks ) then

			-- Reassemble
			local parts = {}
			for i = 1, numChunks do
				parts[ i ] = buffer.chunks[ i ] or ""
			end

			local fullData = table.concat( parts )

			-- Clear buffer
			ChunkBuffers[ bufferKey ] = nil

			-- Fire callback
			callback( fullData, client )

		end

	end )

end

MsgN( "[NetDelta] Delta compression and chunked transfer loaded." )
