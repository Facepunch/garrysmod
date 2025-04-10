
-- TODO: Hack. Move to where color is defined?
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
