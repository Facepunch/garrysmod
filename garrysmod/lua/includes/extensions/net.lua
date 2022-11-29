
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
	[0]		= function (t, v) net.WriteUInt(t, 4)							end,
	[1]		= function (t, v) net.WriteUInt(t, 4)	net.WriteString(v)		end,
	[2]		= function (t, v) net.WriteUInt(t, 4)	net.WriteDouble(v)		end,
	[3]		= function (t, v) net.WriteUInt(t, 4)	net.WriteTable(v)		end,
	[4]		= function (t, v) net.WriteUInt(t, 4)	net.WriteBool(v)		end,
	[5]		= function (t, v) net.WriteUInt(t, 4)	net.WriteEntity(v)		end,
	[6]		= function (t, v) net.WriteUInt(t, 4)	net.WriteVector(v)		end,
	[7]		= function (t, v) net.WriteUInt(t, 4)	net.WriteAngle(v)		end,
	[8]		= function (t, v) net.WriteUInt(t, 4)	net.WriteMatrix(v)		end,
	[9]		= function (t, v) net.WriteUInt(t, 4)	net.WriteColor(v)		end,
}

local types = {
	[1] 	= 4, -- boolean
	[3] 	= 2, -- number
	[4] 	= 1, -- string
	[5] 	= 3, -- table
	[9] 	= 5, -- Entity
	[10] 	= 6, -- Vector
	[11] 	= 7, -- Angle
	[29] 	= 8, -- VMatrix
}

local IsColor = IsColor
local TypeID = TypeID
local function NetTypeID(v)
	if !v then return 0 end

	if IsColor(v) then
		return 9
	else
		return types[TypeID(v)] or 0
	end
end

function net.WriteType( v )

	local typeid = NetTypeID( v )

	local wv = net.WriteVars[ typeid ]
	if ( wv ) then return wv( typeid, v ) end

	error( "net.WriteType: Couldn't write " .. type( v ) .. " (type " .. typeid .. ")" )

end

net.ReadVars =
{
	[0]	= function ()	return nil 				end,
	[1]	= function ()	return net.ReadString() 	end,
	[2]	= function ()	return net.ReadDouble() 	end,
	[3]	= function ()	return net.ReadTable() 	end,
	[4]	= function ()	return net.ReadBool() 		end,
	[5]	= function ()	return net.ReadEntity() 	end,
	[6]	= function ()	return net.ReadVector() 	end,
	[7]	= function ()	return net.ReadAngle() 		end,
	[8]	= function ()	return net.ReadMatrix() 	end,
	[9]	= function ()	return net.ReadColor() 		end,
}

function net.ReadType( typeid )

	typeid = typeid or net.ReadUInt( 4 )

	local rv = net.ReadVars[ typeid ]
	if ( rv ) then return rv() end

	error( "net.ReadType: Couldn't read type " .. typeid )

end
