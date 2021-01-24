TYPE_COLOR = 255

net.Receivers = {}

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

	local func = net.Receivers[ strName:lower() ]
	if ( !func ) then return end

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
-- CClientEntityList::GetMaxEntityIndex() returns 8096
--
function net.WriteEntity( e )
	if ( IsValid( e ) or game.GetWorld() == e) then

		net.WriteBool( true )
		net.WriteUInt( e:EntIndex(), 13 )

		return

	end

	net.WriteBool( false ) -- NULL
end

function net.ReadEntity()
	if ( net.ReadBool() ) then -- non null
		return Entity( net.ReadUInt( 13 ) )
	end

	return NULL
end

--
-- Read/Write a color to/from the stream
--
function net.WriteColor( col )

	assert( IsColor( col ), "net.WriteColor: color expected, got ".. type( col ) )

	net.WriteUInt( col.r, 8 )
	net.WriteUInt( col.g, 8 )
	net.WriteUInt( col.b, 8 )
	net.WriteUInt( col.a, 8 )

end

function net.ReadColor()

	return Color(
		net.ReadUInt( 8 ), net.ReadUInt( 8 ),
		net.ReadUInt( 8 ), net.ReadUInt( 8 )
	)

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

--
-- Sizes for ints to send
--
local TYPE_SIZE = 4
local UINTV_SIZE = 5

local Char2HexaLookup, Hexa2CharLookup = {}, {}

--
-- Generate Hexa Lookups
-- Hexa is a 6-bit English character encoding
--
local HexaRanges = {
	{ "a", "z" }, -- 26
	{ "A", "Z" }, -- 52
	{ "0", "9" }, -- 62
	{ "_", "_" }, -- 63
}

local offset = 1

for k, v in ipairs( HexaRanges ) do
	local starts, ends = v[ 1 ]:byte(), v[ 2 ]:byte()

	for char = starts, ends do
		local hexa = char - starts + offset

		Char2HexaLookup[ char ] = hexa
		Hexa2CharLookup[ hexa ] = string.char( char )
	end

	offset = offset + 1 + ends - starts
end


--
-- Converts an ASCII character in to a Hexa Character
--
local function CharToHexa( c )
	return Char2HexaLookup[ c ]
end

--
-- Converts a Hexa character in to an ASCII character
--
local function HexaToChar( h )
	return Hexa2CharLookup[ h ]
end

--
-- Returns true if the string can be represented in 7-Bit ASCII
-- Null bytes are not allowed as they are used for termination
--
local function Is7BitString( str )
	return str:find( "[\x80-\xFF%z]" ) == nil
end

--
-- Returns true if the string can be represented in Hexa
--
local function IsHexaString( str )
	return str:find( "[^a-zA-Z0-9_]" ) == nil
end

--
-- Returns true if the argument is NaN ( can also be interpreted as 0/0 )
--
local function IsNaN( x )
	return x ~= x
end

--
-- An imaginary NaN table for caching in writing.table
--
local NaN = {}

--
-- This exists because you can't make a table index NaN
-- We need to do this so we can cache it in our references table
--
local function IndexSafe( x )
	if ( IsNaN( x ) ) then return NaN end
	return x
end

local reading, writing

--
-- Gets the type of way we are going to send the data
-- Not all of these exist in reality
-- We are only going to add 16 types ( 0-15 ) since that's
-- the max we can fit into 4 bits
--
local function SendType( x )

	local t = type( x )

	if ( IsColor( x ) ) then
		return "Color"
	end

	if ( TypeID( x ) == TYPE_ENTITY ) then
		return "Entity"
	end

	if ( x == 1 or x == 0 ) then return "bit" end

	--
	-- check if a number has no decimal places
	-- and is able to be sent in an int
	--

	if ( t == "number" and x % 1 == 0 and x >= -0x7FFFFFFF and x <= 0xFFFFFFFF ) then

		-- test if we can fit it in a single iteration with uintv
		if ( x < bit.lshift( 1, UINTV_SIZE ) and x >= 0 ) then
			return "uintv"
		end

		if ( x <= 0x7FFF and x >= -0x7FFF ) then
			return "int16"
		end

		if ( x <= 0x7FFFFFFF and x >= -0x7FFFFFFF ) then
			return "int32"
		end

		return "uintv"

	end

	if ( t == "string" and IsHexaString( x ) ) then
		return "hexastring"
	end

	if ( t == "string" and Is7BitString( x ) ) then
		return "string7"
	end

	return t

end

local StringToTypeLookup, TypeToStringLookup = { }, { }

do
	--
	-- MUST BE 16 OR LESS TYPES
	--
	StringToTypeLookup = {
		-- strings
		string       = 0,
		hexastring   = 1,
		string7      = 2,

		--numbers
		bit          = 3,
		int16        = 4,
		int32        = 5,
		number       = 6,
		uintv        = 7,

		-- default things
		boolean      = 8,

		--float arrays
		Vector       = 9,
		Angle        = 10,

		--tables
		table        = 11,
		reference    = 13,


		-- Garry's Mod specific
		VMatrix      = 12,
		Color        = 14,
		Entity       = 15,
	}

	--
	-- backwards lookup
	--
	for k,v in pairs( StringToTypeLookup ) do
		TypeToStringLookup[ v ] = k
	end

end

local function TypeToString( n )
	return TypeToStringLookup[ n ]
end

local function StringToType( s )
	return StringToTypeLookup[ s ]
end

local ReferenceType = StringToType( "reference" )
local TableType     = StringToType( "table" )

reading = {
	--
	-- Normal gmod types we can't really improve
	--
	Color       = net.ReadColor,
	boolean     = net.ReadBool,
	number      = net.ReadDouble,
	bit         = net.ReadBit,
	Entity      = net.ReadEntity,
	VMatrix     = net.ReadMatrix,
	Angle       = net.ReadAngle,
	Vector      = net.ReadVector,

	--
	-- Simple integers
	--
	int16 = function() return net.ReadInt( 16 ) end,
	int32 = function() return net.ReadInt( 32 ) end,

	--
	-- A reference index in our already-sent-table
	--
	reference = function( references ) return references[ reading.uintv() ] end,

	--
	-- Variable length unsigned integers
	--
	uintv = function()
		local i = 0
		local ret = 0

		while net.ReadBool() do
			local t = net.ReadUInt( UINTV_SIZE )
			ret = ret + bit.lshift( t, i * UINTV_SIZE )

			i = i + 1
		end

		return ret
	end,

	--
	-- 7 bit encoded strings
	-- NULL terminated
	--
	string7 = function()
		if ( net.ReadBool() ) then -- it's compressed
			return util.Decompress( net.ReadData( reading.uintv() ) )
		else -- it's not compressed
			local ret = ""

			while true do
				local chr = net.ReadUInt( 7 )
				if ( chr == 0 ) then return ret end
				ret = ret..string.char( chr )
			end
		end
	end,

	--
	-- Our 6-bit encoded strings
	-- NULL terminated
	--
	hexastring = function()
		if ( net.ReadBool() ) then
			return util.Decompress( net.ReadData( reading.uintv() ) )
		else
			local ret = ""

			while true do
				local chr = net.ReadUInt( 6 )
				if ( chr == 0 ) then return ret end -- terminator
				ret = ret..Hexa2CharLookup[ chr ]
			end
		end
	end,

	--
	-- C String
	-- NULL terminated
	-- NOTE: Must be NULL terminated or else will break compatibility
	-- with some addons! Also could lead to exploits
	--
	string = function()
		if ( net.ReadBool() ) then -- compressed or not
			return util.Decompress( net.ReadData( reading.uintv() ) )
		else
			return net.ReadString()
		end
	end,

	--
	-- our readtable
	-- directly used as net.ReadTable
	--
	table = function( references )
		local ret = {}

		references = references or {}

		local reference = function( type, value )
			if ( not type or ( type ~= TableType and type ~= ReferenceType ) ) then
				table.insert( references, value )
			end
		end

		reference(nil, ret)

		for i = 1, reading.uintv() do
			local type = net.ReadUInt( TYPE_SIZE )
			local value = reading[ TypeToString( type ) ]( references )

			reference(type, value)

			ret[ i ] = value
		end

		for i = 1, reading.uintv() do
			local keytype = net.ReadUInt(TYPE_SIZE)
			local keyvalue = reading[ TypeToString( keytype ) ]( references )

			reference(keytype, keyvalue)

			local valuetype = net.ReadUInt(TYPE_SIZE)
			local valuevalue = reading[ TypeToString( valuetype ) ]( references )

			reference(valuetype, valuevalue)

			ret[ keyvalue ] = valuevalue

		end

		return ret
	end
}

--
-- We need this since #table returns undefined values
-- by the lua spec if it doesn't have incremental keys
-- we use pairs since it's backwards compatible
--
local function array_len(x)
	local indices = {}
	for k,v in pairs(x) do
		indices[k] = true
	end

	for i = 1, 8096 do
		if(nil == indices[i]) then
			return i - 1
		end
	end

	return 8096
end

writing = {

	bit      = net.WriteBit,
	Color    = net.WriteColor,
	boolean  = net.WriteBool,
	number   = net.WriteDouble,
	Entity   = net.WriteEntity,
	VMatrix  = net.WriteMatrix,
	Vector   = net.WriteVector,
	Angle    = net.WriteAngle,

	int16 = function( w ) net.WriteInt( w, 16 ) end,
	int32 = function( d ) net.WriteInt( d, 32 ) end,

	--
	-- Variable length unsigned integers
	--
	uintv = function( n )
		while( n > 0 ) do
			net.WriteBool(true)
			net.WriteUInt( n, UINTV_SIZE )
			n = bit.rshift( n, UINTV_SIZE )
		end

		net.WriteBool(false)
	end,


	--
	-- 7 bit encoded strings
	-- NULL terminated
	--
	string7 = function( s )
		local null = s:find( "%z" )

		if (null) then
			s = s:sub( 1, null - 1 )
		end

		local compressed = util.Compress( s )

		-- add one for the null terminator
		if ( compressed and compressed:len() < (s:len() + 1) / 8 * 7 ) then
			net.WriteBool( true )
			writing.uintv( compressed:len() )
			net.WriteData( compressed, compressed:len() )
		else
			net.WriteBool( false )

			for i = 1, s:len() do
				net.WriteUInt( s:byte( i, i ), 7 )
			end

			net.WriteUInt( 0, 7 )
		end
	end,

	--
	-- Our 6-bit encoded strings
	-- NULL terminated
	--
	hexastring = function( s )
		local null = s:find( "%z" )

		if (null) then
			s = s:sub( 1, null - 1 )
		end

		local compressed = util.Compress( s )

		-- add one for the null terminator
		if ( compressed and compressed:len() < ( s:len() + 1 ) / 8 * 6 ) then
			net.WriteBool( true )
			writing.uintv( compressed:len() )
			net.WriteData( compressed, compressed:len() )
		else
			net.WriteBool( false )

			for i = 1, s:len() do
				net.WriteUInt( Char2HexaLookup[ s:byte( i, i ) ], 6 )
			end

			net.WriteUInt( 0, 6 )
		end
	end,

	--
	-- C String
	-- NULL terminated
	-- NOTE: Must be NULL terminated or else will break compatibility
	-- with some addons! Also could lead to exploits
	--
	string = function( x )
		local null = x:find( "%z" )

		if (null) then
			x = x:sub( 1, null - 1 )
		end

		local compressed = util.Compress( x )

		if ( compressed and compressed:len() < x:len() + 1 ) then
			net.WriteBool( true )
			writing.uintv( compressed:len() )
			net.WriteData( compressed, compressed:len() )
		else
			net.WriteBool( false )
			net.WriteString( x )
		end
	end,


	--
	-- our writetable
	-- directly used as net.WriteTable
	--

	table = function( tbl, references, num )
		references = references or {[tbl] = 1}
		num = num or 1

		local SendValue = function( value )
			if ( references[ IndexSafe( value ) ] ) then
				net.WriteUInt( ReferenceType, TYPE_SIZE )
				writing.uintv( references[ IndexSafe( value ) ] )

				return
			end

			local sendtype = SendType( value )

			num = num + 1
			references[ IndexSafe( value ) ] = num

			net.WriteUInt( StringToType( sendtype ), TYPE_SIZE )

		 	num = writing[ sendtype ]( value, references, num ) or num
		end

		local pairs_table = {}

		for k,v in pairs(tbl) do
			pairs_table[k] = v
		end

		local array_size = array_len( pairs_table )

		writing.uintv( array_size )

		for i = 1, array_size do
			local value = pairs_table[ i ]
			pairs_table[ i ] = nil

			SendValue( value )
		end

		local object_key_count = table.Count( pairs_table )

		writing.uintv( object_key_count )

		for k,v in next, pairs_table, nil do
			SendValue( k )
			SendValue( v )
		end

		return num
	end
}

net.WriteTable = function(t) writing.table(t) end
net.ReadTable = function() return reading.table() end
