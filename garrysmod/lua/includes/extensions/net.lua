
-- TODO: Hack. Move to where color is defined?
TYPE_COLOR = 255

net.Receivers = {}

--
-- Rate limiting (inspired by HolyLib networking)
-- Prevents clients from flooding the server with net messages
--
local RateLimits = {}		-- [messageName] = maxPerSecond
local RateBuckets = {}		-- [messageName] = { [steamID] = { count, resetTime } }
local RateDropped = 0

function net.SetRateLimit( name, maxPerSecond )
	name = name:lower()
	RateLimits[ name ] = maxPerSecond
	if ( maxPerSecond ) then
		RateBuckets[ name ] = RateBuckets[ name ] or {}
	else
		RateBuckets[ name ] = nil
	end
end

function net.GetRateDropped()
	return RateDropped
end

--
-- Set up a function to receive network messages
--
function net.Receive( name, func )

	net.Receivers[ name:lower() ] = func

end

--
-- A message has been received from the network..
--
function net.Incoming( len, client )

	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )

	if ( !strName ) then return end

	local nameLower = strName:lower()
	local func = net.Receivers[ nameLower ]
	if ( !func ) then return end

	--
	-- Rate limit check (server-side only)
	--
	if ( SERVER and IsValid( client ) and RateLimits[ nameLower ] ) then

		local maxRate = RateLimits[ nameLower ]
		local bucket = RateBuckets[ nameLower ]
		local sid = client:SteamID()
		local now = SysTime()

		if ( !bucket[ sid ] ) then
			bucket[ sid ] = { count = 0, resetTime = now + 1 }
		end

		local b = bucket[ sid ]

		if ( now > b.resetTime ) then
			b.count = 0
			b.resetTime = now + 1
		end

		b.count = b.count + 1

		if ( b.count > maxRate ) then
			RateDropped = RateDropped + 1
			return		-- Silently drop excess messages
		end

	end

	--
	-- len includes the 16 bit int which told us the message name
	--
	len = len - 16

	func( len, client )

end

--
-- Read/Write a boolean to the stream
--
net.WriteBool = net.WriteBit

function net.ReadBool()

	return net.ReadBit() == 1

end

--
-- Read/Write an entity to the stream
--
function net.WriteEntity( ent )

	if ( !IsValid( ent ) ) then
		net.WriteUInt( 0, MAX_EDICT_BITS )
	else
		net.WriteUInt( ent:EntIndex(), MAX_EDICT_BITS )
	end

end

function net.ReadEntity()

	local i = net.ReadUInt( MAX_EDICT_BITS )
	if ( !i ) then return end

	return Entity( i )

end


--
-- Read/Write a player to the stream
--

-- TODO: Replace with MAX_PLAYER_BITS
local maxplayers_bits = math.ceil( math.log( 1 + game.MaxPlayers() ) / math.log( 2 ) )

function net.WritePlayer( ply )
	net.WriteUInt( IsValid( ply ) and ply:IsPlayer() and ply:EntIndex() or 0, maxplayers_bits )
end

function net.ReadPlayer()
	return Entity( net.ReadUInt( maxplayers_bits ) )
end


--
-- Read/Write a color to/from the stream
--
function net.WriteColor( col, writeAlpha )
	if ( writeAlpha == nil ) then writeAlpha = true end

	assert( IsColor( col ), "net.WriteColor: color expected, got ".. type( col ) )

	local r, g, b, a = col:Unpack()
	net.WriteUInt( r, 8 )
	net.WriteUInt( g, 8 )
	net.WriteUInt( b, 8 )

	if ( writeAlpha ) then
		net.WriteUInt( a, 8 )
	end
end

function net.ReadColor( readAlpha )
	if ( readAlpha == nil ) then readAlpha = true end

	local r, g, b =
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 )

	local a = 255
	if ( readAlpha ) then a = net.ReadUInt( 8 ) end

	return Color( r, g, b, a )

end

--
-- Write a whole table to the stream
-- This is less optimal than writing each
-- item individually and in a specific order
-- because it adds type information before each var
--
function net.WriteTable( tab, seq )

	if ( seq ) then

		local len = #tab
		net.WriteUInt( len, 32 )

		for i = 1, len do

			net.WriteType( tab[ i ] )

		end

	else

		for k, v in pairs( tab ) do

			net.WriteType( k )
			net.WriteType( v )

		end

		-- End of table
		net.WriteType( nil )

	end

end

function net.ReadTable( seq )

	local tab = {}

	if ( seq ) then

		for i = 1, net.ReadUInt( 32 ) do

			tab[ i ] = net.ReadType()

		end

	else

		while true do

			local k = net.ReadType()
			if ( k == nil ) then break end

			tab[ k ] = net.ReadType()

		end

	end

	return tab

end

net.WriteVars =
{
	[TYPE_NIL]			= function ( t, v )	net.WriteUInt( t, 8 )								end,
	[TYPE_STRING]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteString( v )		end,
	[TYPE_NUMBER]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteDouble( v )		end,
	[TYPE_TABLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteTable( v )			end,
	[TYPE_BOOL]			= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteBool( v )			end,
	[TYPE_ENTITY]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteEntity( v )		end,
	[TYPE_VECTOR]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteVector( v )		end,
	[TYPE_ANGLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteAngle( v )			end,
	[TYPE_MATRIX]		= function ( t, v ) net.WriteUInt( t, 8 )	net.WriteMatrix( v )		end,
	[TYPE_COLOR]		= function ( t, v ) net.WriteUInt( t, 8 )	net.WriteColor( v )			end,
}

function net.WriteType( v )
	local typeid = nil

	if IsColor( v ) then
		typeid = TYPE_COLOR
	else
		typeid = TypeID( v )
	end

	local wv = net.WriteVars[ typeid ]
	if ( wv ) then return wv( typeid, v ) end

	error( "net.WriteType: Couldn't write " .. type( v ) .. " (type " .. typeid .. ")" )

end

net.ReadVars =
{
	[TYPE_NIL]		= function ()	return nil end,
	[TYPE_STRING]	= function ()	return net.ReadString() end,
	[TYPE_NUMBER]	= function ()	return net.ReadDouble() end,
	[TYPE_TABLE]	= function ()	return net.ReadTable() end,
	[TYPE_BOOL]		= function ()	return net.ReadBool() end,
	[TYPE_ENTITY]	= function ()	return net.ReadEntity() end,
	[TYPE_VECTOR]	= function ()	return net.ReadVector() end,
	[TYPE_ANGLE]	= function ()	return net.ReadAngle() end,
	[TYPE_MATRIX]	= function ()	return net.ReadMatrix() end,
	[TYPE_COLOR]	= function ()	return net.ReadColor() end,
}

function net.ReadType( typeid )

	typeid = typeid or net.ReadUInt( 8 )

	local rv = net.ReadVars[ typeid ]
	if ( rv ) then return rv() end

	error( "net.ReadType: Couldn't read type " .. typeid )

end


--[[---------------------------------------------------------
	SCHEMA-BASED PACKED NET MESSAGES

	Skips per-field type headers by using a pre-defined schema.
	Both sender and receiver must use the same schema.

	Schema format:
	{
		{ "fieldName", "type" },
		{ "fieldName", "type" },
	}

	Supported types:
		"string", "bool", "float", "double",
		"int8", "int16", "int32",
		"uint8", "uint16", "uint32",
		"vector", "angle", "entity", "color", "player"

	Usage:
		local schema = {
			{ "name", "string" },
			{ "health", "uint16" },
			{ "pos", "vector" },
			{ "alive", "bool" },
		}

		-- Sender
		net.Start( "PlayerSync" )
		net.WriteTablePacked( schema, { name = "Jarvis", health = 100, pos = Vector(0,0,0), alive = true } )
		net.Broadcast()

		-- Receiver
		net.Receive( "PlayerSync", function( len )
			local data = net.ReadTablePacked( schema )
			-- data.name, data.health, data.pos, data.alive
		end )
-----------------------------------------------------------]]

local PackedWriters = {
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
	["player"]	= function( v ) net.WritePlayer( v ) end,
}

local PackedReaders = {
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
	["player"]	= function() return net.ReadPlayer() end,
}

--
-- Write a table using a schema (no type headers, pure data)
--
function net.WriteTablePacked( schema, data )

	for i = 1, #schema do

		local field = schema[ i ]
		local name = field[ 1 ]
		local ftype = field[ 2 ]

		local writer = PackedWriters[ ftype ]
		if ( !writer ) then
			error( "net.WriteTablePacked: Unknown type '" .. tostring( ftype ) .. "' for field '" .. name .. "'" )
		end

		writer( data[ name ] )

	end

end

--
-- Read a table using a schema (no type headers, pure data)
--
function net.ReadTablePacked( schema )

	local data = {}

	for i = 1, #schema do

		local field = schema[ i ]
		local name = field[ 1 ]
		local ftype = field[ 2 ]

		local reader = PackedReaders[ ftype ]
		if ( !reader ) then
			error( "net.ReadTablePacked: Unknown type '" .. tostring( ftype ) .. "' for field '" .. name .. "'" )
		end

		data[ name ] = reader()

	end

	return data

end

--
-- Calculate the bit cost of a schema (for budgeting net message size)
--
local PackedBitCosts = {
	["bool"]	= 1,
	["int8"]	= 8,	["uint8"]	= 8,
	["int16"]	= 16,	["uint16"]	= 16,
	["int32"]	= 32,	["uint32"]	= 32,
	["float"]	= 32,
	["double"]	= 64,
	["vector"]	= 96,		-- 3x 32-bit floats
	["angle"]	= 96,		-- 3x 32-bit floats
	["entity"]	= 16,		-- MAX_EDICT_BITS (approx)
	["color"]	= 32,		-- 4x 8-bit
	["player"]	= 8,		-- varies, approximate
}

function net.SchemaSize( schema )

	local bits = 0

	for i = 1, #schema do

		local ftype = schema[ i ][ 2 ]
		local cost = PackedBitCosts[ ftype ]

		if ( cost ) then
			bits = bits + cost
		else
			bits = bits + 128		-- estimate for strings and unknowns
		end

	end

	return bits

end
