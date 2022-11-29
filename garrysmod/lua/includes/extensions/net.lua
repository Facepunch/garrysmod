
TYPE_COLOR = 255

local NET_TYPE_NIL = 0
local NET_TYPE_STRING = 1
local NET_TYPE_NUMBER = 2
local NET_TYPE_TABLE = 3
local NET_TYPE_BOOLEAN = 4
local NET_TYPE_ENTITY = 5
local NET_TYPE_VECTOR = 6
local NET_TYPE_ANGLE = 7
local NET_TYPE_VMATRIX = 8
local NET_TYPE_COLOR = 9

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
--
function net.WriteEntity( ent )

	if ( !IsValid( ent ) ) then
		net.WriteUInt( 0, 14 )
	else
		net.WriteUInt( ent:EntIndex(), 14 )
	end

end

function net.ReadEntity()

	local i = net.ReadUInt( 14 )
	if ( !i ) then return end

	return Entity( i )

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
-- item indivdually and in a specific order
-- because it adds type information before each var
--
function net.WriteTable( tab )

	for k, v in pairs( tab ) do

		net.WriteType( k )
		net.WriteType( v )

	end

	-- End of table
	net.WriteType( nil )

end

function net.ReadTable()

	local tab = {}

	while true do

		local k = net.ReadType()
		if ( k == nil ) then return tab end

		tab[ k ] = net.ReadType()

	end

end

net.WriteVars =
{
	[NET_TYPE_NIL]		= function ( t, v ) net.WriteUInt( t, 4 )					end,
	[NET_TYPE_STRING]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteString( v )	end,
	[NET_TYPE_NUMBER]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteDouble( v )	end,
	[NET_TYPE_TABLE]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteTable( v )		end,
	[NET_TYPE_BOOLEAN]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteBool( v )		end,
	[NET_TYPE_ENTITY]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteEntity( v )	end,
	[NET_TYPE_VECTOR]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteVector( v )	end,
	[NET_TYPE_ANGLE]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteAngle( v )		end,
	[NET_TYPE_VMATRIX]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteMatrix( v )	end,
	[NET_TYPE_COLOR]		= function ( t, v ) net.WriteUInt( t, 4 )	net.WriteColor( v )		end,
}

net.Types = {
	[1] 	= NET_TYPE_BOOLEAN, -- boolean
	[3] 	= NET_TYPE_NUMBER,´ -- number
	[4] 	= NET_TYPE_STRING,  -- string
	[5] 	= NET_TYPE_TABLE,   -- table
	[9] 	= NET_TYPE_ENTITY,  -- Entity
	[10] 	= NET_TYPE_VECTOR,  -- Vector
	[11] 	= NET_TYPE_ANGLE,   -- Angle
	[29] 	= NET_TYPE_VMATRIX, -- VMatrix
}

local IsColor = IsColor
local TypeID = TypeID
local function Net_TypeID( v )
	if !v then return NET_TYPE_NIL end

	if IsColor( v ) then
		return NET_TYPE_COLOR
	else
		return net.Types[ TypeID( v ) ] or NET_TYPE_NIL
	end
end

function net.WriteType( v )

	local typeid = Net_TypeID( v )

	local wv = net.WriteVars[ typeid ]
	if ( wv ) then return wv( typeid, v ) end

	error( "net.WriteType: Couldn't write " .. type( v ) .. " (type " .. typeid .. ")" )

end

net.ReadVars =
{
	[NET_TYPE_NIL]	= function ()	return nil 					end,
	[NET_TYPE_STRING]	= function ()	return net.ReadString() 	end,
	[NET_TYPE_NUMBER]	= function ()	return net.ReadDouble() 	end,
	[NET_TYPE_TABLE]	= function ()	return net.ReadTable() 		end,
	[NET_TYPE_BOOLEAN]	= function ()	return net.ReadBool() 		end,
	[NET_TYPE_ENTITY]	= function ()	return net.ReadEntity() 	end,
	[NET_TYPE_VECTOR]	= function ()	return net.ReadVector() 	end,
	[NET_TYPE_ANGLE]	= function ()	return net.ReadAngle() 		end,
	[NET_TYPE_VMATRIX]	= function ()	return net.ReadMatrix() 	end,
	[NET_TYPE_COLOR]	= function ()	return net.ReadColor() 		end,
}

function net.ReadType( typeid )

	typeid = typeid or net.ReadUInt( 4 )

	local rv = net.ReadVars[ typeid ]
	if ( rv ) then return rv() end

	error( "net.ReadType: Couldn't read type " .. typeid )

end
