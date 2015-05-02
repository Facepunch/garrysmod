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

	local r, g, b, a = 
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 )

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
	[TYPE_NIL]			= function ( t, v )	net.WriteUInt( t, 8 )								end,
	[TYPE_STRING]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteString( v )		end,
	[TYPE_NUMBER]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteDouble( v )		end,
	[TYPE_TABLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteTable( v )			end,
	[TYPE_BOOL]			= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteBool( v )			end,
	[TYPE_ENTITY]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteEntity( v )		end,
	[TYPE_VECTOR]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteVector( v )		end,
	[TYPE_ANGLE]		= function ( t, v )	net.WriteUInt( t, 8 )	net.WriteAngle( v )			end,
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
	[TYPE_NIL]		= function ()	return end,
	[TYPE_STRING]	= function ()	return net.ReadString() end,
	[TYPE_NUMBER]	= function ()	return net.ReadDouble() end,
	[TYPE_TABLE]	= function ()	return net.ReadTable() end,
	[TYPE_BOOL]		= function ()	return net.ReadBool() end,
	[TYPE_ENTITY]	= function ()	return net.ReadEntity() end,
	[TYPE_VECTOR]	= function ()	return net.ReadVector() end,
	[TYPE_ANGLE]	= function ()	return net.ReadAngle() end,
	[TYPE_COLOR]	= function ()	return net.ReadColor() end,
}

function net.ReadType( typeid )

	typeid = typeid or net.ReadUInt( 8 )

	local rv = net.ReadVars[ typeid ]
	if ( rv ) then return rv() end

	error( "net.ReadType: Couldn't read type " .. typeid )
end

--Here a chunk library by thegrb93 which allows sending large streams of data without overflowing the reliable channel
net.Chunk = {}
net.Chunk.Queues = {}            --This holds a queue for each player, or one if CLIENT
net.Chunk.Data = {}            --This holds the data to send        
net.Chunk.MaxSendSize = 20000            --This is the maximum size of each chunk to send
net.Chunk.Timeout = 2            --How long the data should exist in the store without being used before being destroyed

--Send the data sender a request for data
function net.Chunk:Request( ply )

	net.Start( "ChunkRequest" )
	net.WriteBit( false )
	net.WriteString( self.crc )
	net.WriteUInt( #self.data, 32 )
	
	--print("Requesting",self.crc,#self.data)
	
	if CLIENT then net.SendToServer() else net.Send( ply ) end
	
	timer.Create( "ChunkDlTimeout" .. self.crc, 1, net.Chunk.Timeout, function() self:Remove() end )
	
end

--Begin requesting data
function net.Chunk:Start( ply )

	if not self.active then
	
		timer.Remove( "ChunkKeepAlive" .. self.crc )
		self.active = true
		self:Request( ply )
		
	end
	
end

--Received data so process it
function net.Chunk:Read( len, ply )

	local size = math.floor( len / 8 )
	
	if size == 0 then self:Remove() return end
	--print("Got", size)
	
	self.data[ #self.data + 1 ] = net.ReadData( size )
	if #self.data == self.numchunks then
		self.returndata = util.Decompress( table.concat( self.data ) )
		self:Remove()
	else
		self:Request( ply )
	end

end

--Pop the queue and start the next task
function net.Chunk:Remove()
	
	pcall( self.callback, self.returndata )
	
	timer.Remove( "ChunkDlTimeout" .. self.crc )
	table.remove( self.queue, 1 )
	if self.queue[ 1 ] then
		self.queue[ 1 ]:Start()
	else
		net.Chunk.Queues[ self.crc ] = nil
	end
	
end

net.Chunk.__index = net.Chunk

--Store the data and write the file info so receivers can request it.
function net.WriteChunk( data )

	if type( data ) ~= "string" then
		error( "bad argument #1 to 'WriteChunk' (string expected, got " .. type( data ) .. ")", 2 )
	end
		
	local compressed = util.Compress( data )
	local crc = util.CRC( compressed )
	
	net.Chunk.Data[ crc ] = compressed
	timer.Create( "ChunkUlTimeout" .. crc, 1, net.Chunk.Timeout, function() net.Chunk.Data[ crc ] = nil end )
	
	net.WriteUInt( math.ceil( #compressed / net.Chunk.MaxSendSize ), 32 )
	net.WriteString( crc )
	
end

--If the receiver is a player then add it to a queue.
--If the receiver is the server then add it to a queue for each individual player
function net.ReadChunk( ply, callback )

	if CLIENT then 
		ply = NULL
	else
		if type( ply ) ~= "Player" then
			error( "bad argument #1 to 'ReadChunk' (Player expected, got " .. type( ply ) .. ")", 2 )
		elseif not ply:IsValid() then
			error( "bad argument #1 to 'ReadChunk' (Tried to use a NULL entity!)", 2 )
		end
	end
	if type( callback ) ~= "function" then
		error( "bad argument #2 to 'ReadChunk' (function expected, got " .. type( callback ) .. ")", 2 )
	end
	
	local queue = net.Chunk.Queues[ ply ]
	if not queue then queue = {} net.Chunk.Queues[ ply ] = queue end
	
	local numchunks = net.ReadUInt( 32 )
	local crc = net.ReadString()
	
	--print("Got info", numchunks, crc)
	
	local chunk = {
		numchunks = numchunks,
		crc = crc,
		data = {},
		active = false,
		callback = callback,
		queue = queue
	}
		
	queue[ #queue + 1 ] = setmetatable( chunk, net.Chunk )
	if #queue > 1 then
		timer.Create( "ChunkKeepAlive" .. crc, net.Chunk.Timeout / 2, 0, function() 
			net.Start( "ChunkRequest" )
			net.WriteBit( true )
			net.WriteString( crc )
		end )
	end
	queue[ 1 ]:Start( ply )
	
end

if SERVER then

	util.AddNetworkString( "ChunkRequest" )
	util.AddNetworkString( "ChunkDownload" )
	
end

--Chunk data is requested
net.Receive( "ChunkRequest", function( len, ply )

	local keepalive = net.ReadBit() == 1
	local crc = net.ReadString()
	local data = net.Chunk.Data[ crc ]
	
	if data then
		timer.Adjust( "ChunkUlTimeout" .. crc, 1, net.Chunk.Timeout, function() net.Chunk.Data[ crc ] = nil end )
	end
	
	if not keepalive then

		local index = net.ReadUInt( 32 )
		
		net.Start( "ChunkDownload" )
			
		if data then
		
			local start = math.min( index * net.Chunk.MaxSendSize + 1, #data )
			local endpos = math.min( start + net.Chunk.MaxSendSize - 1, #data )
			local senddata = data:sub( start, endpos )
			
			--print("Responding",#senddata,start,endpos)
			
			net.WriteData( senddata, #senddata )
			
		end
	
		if CLIENT then net.SendToServer() else net.Send( ply ) end
	end
	
end )

--Downloaded the chunk data
net.Receive( "ChunkDownload", function( len, ply )

	ply = ply or NULL
	local queue = net.Chunk.Queues[ ply ]
	if queue and queue[ 1 ] then
	
		queue[ 1 ]:Read( len, ply )
	
	end
	
end )

