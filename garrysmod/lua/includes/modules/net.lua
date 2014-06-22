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
	-- len includes the 16 byte int which told us the message name
	--
	len = len - 16
	
	func( len, client )

end

--
-- Read/Write an entity to the stream
--
function net.WriteEntity( ent )

	if ( !IsValid( ent ) ) then 
		net.WriteUInt( 0, 16 )
	else
		net.WriteUInt( ent:EntIndex(), 16 )
	end

end

function net.ReadEntity()

	local i = net.ReadUInt( 16 )
	if ( !i ) then return end
	
	return Entity( i )
	
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
	net.WriteUInt( 0, 8 )

end

function net.ReadTable()

	local tab = {}
	
	while true do
	
		local t = net.ReadUInt( 8 )
		if ( t == 0 ) then return tab end
		local k = net.ReadType( t )
	
		local t = net.ReadUInt( 8 )
		if ( t == 0 ) then return tab end
		local v = net.ReadType( t )
		
		tab[ k ] = v
		
	end

end

net.WriteVars = 
{
	[TYPE_NIL]			= function ( t, v )	net.WriteUInt( t, 8 )								end,
	[TYPE_STRING]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteString( v )		end,
	[TYPE_NUMBER]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteDouble( v )		end,
	[TYPE_TABLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteTable( v )			end,
	[TYPE_BOOL]			= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteBit( v )			end,
	[TYPE_ENTITY]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteEntity( v )		end,
	[TYPE_VECTOR]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteVector( v )		end,
	[TYPE_ANGLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteAngle( v )			end,
		
}

function net.WriteType( v )

	local typeid = TypeID( v )
	local wv = net.WriteVars[ typeid ]
	if ( wv ) then return wv( typeid, v ) end
	
	Error( "Couldn't write type " .. typeid )

end

net.ReadVars = 
{
	[TYPE_NIL]		= function ()	return end,
	[TYPE_STRING]	= function ()	return net.ReadString() end,
	[TYPE_NUMBER]	= function ()	return net.ReadDouble() end,
	[TYPE_TABLE]	= function ()	return net.ReadTable() end,
	[TYPE_BOOL]		= function ()	return net.ReadBit() == 1 end,
	[TYPE_ENTITY]	= function ()	return net.ReadEntity() end,
	[TYPE_VECTOR]	= function ()	return net.ReadVector() end,
	[TYPE_ANGLE]	= function ()	return net.ReadAngle() end,
}

function net.ReadType( typeid )

	local rv = net.ReadVars[ typeid ]
	if ( rv ) then return rv( v ) end
	
	Error( "Couldn't read type " .. typeid )

end
