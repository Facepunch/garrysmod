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
	-- max networked entity index is 2048 according to
	--https://developer.valvesoftware.com/wiki/Entity_limit
	if( ( IsValid( e ) or game.GetWorld( ) == e ) and e:EntIndex( ) < 2048 ) then
		net.WriteBool( true )
		net.WriteUInt( e:EntIndex( ), 12 )
		return
	end
	net.WriteBool( false )
end

function net.ReadEntity()

	if(net.ReadBool()) then -- non null
		-- max networked entity index is 2048 according to
		--https://developer.valvesoftware.com/wiki/Entity_limit
		return Entity(net.ReadUInt(12))
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

	return Color( net.ReadUInt( 8 ), net.ReadUInt( 8 ), 
		net.ReadUInt( 8 ), net.ReadUInt( 8 ) )

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

local reading, writing


local function send_type(x)
	local t = type(x)
	if(t == "table" and IsColor(x)) then
		return "Color"
	end
	if(TypeID(x) == TYPE_ENTITY) then
		return "Entity"
	end
	-- since we are forced to above 3 bits in MAX_BIT we are going to add 
	-- 7 types that will make it decrease
	-- network load
	if(x == 1 or x == 0) then return "bit" end
	if(t == "number" and x % 1 == 0) then
		if(x <= 127 and x >= 127) then
			return "byte"
		end
		if(x <= 0x7FFF and x >= -0x7FFF) then
			return "word"
		end
		if(x <= 0x7FFFFFFF and x >= 0x7FFFFFFF) then
			return "dword"
		end
	end
	return t
end

local headers = {
	string 	= 0
	number 	= 1
	table 	= 2
	boolean	= 3
	endtable= 4
	Vector	= 5
	Angle	= 6
	Color	= 7
	Entity	= 8
	bit		= 9
	word	= 10
	dword	= 11
	reference=12
}
local rheader = {}
for k,v in pairs(headers) do rheader[v] = k end

local MAX_BIT = 4 -- max = 15
local REFERENCE_BIT = 12

reading = {
	Color 		= net.ReadColor,
	boolean 	= net.ReadBool,
	number 		= net.ReadDouble,
	Entity 		= net.ReadEntity,
	bit 		= net.ReadBit,
	reference = function(rs)
		return rs[net.ReadUInt(REFERENCE_BIT)]
	end,
	byte = function()
		return net.ReadInt(8)
	end,
	word = function()
		return net.ReadInt(16)
	end,
	dword = function()
		return net.ReadInt(32)
	end,
	string = function()
		if(net.ReadBool()) then -- compressed or not
			return util.Decompress(net.ReadData(net.ReadUInt(16)))
		else
			return net.ReadData(net.ReadUInt(16))
		end
	end,
	Vector = function()
		return Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
	end,
	Angle = function()
		return Angle(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
	end,
	table = function(references)
		local ret = {}
		local references = references or {}
		references[#references + 1] = ret
		local num = #references + 1
		if(net.ReadBool()) then -- indices start at 1 and
			local max = net.ReadUInt(16) -- go to max
			for i = 1, max do
				local type = net.ReadUInt(MAX_BIT)
				local v = reading[rheader[type]](references)
				if(type ~= headers.reference) then
					if(type == headers.table) then
						num = #references + 1
					else
						references[num] = v
						num = num + 1
					end
				end
				ret[i] = v
			end
		end
		while(true) do
			local type = net.ReadUInt(MAX_BIT)
			if(rheader[type] == "endtable") then break end
			local k = reading[rheader[type]](references)
			if(type ~= headers.reference) then
				if(type == headers.table) then
					num = #references + 1
				else
					references[num] = k
					num = num + 1
				end
			end
			type = net.ReadUInt(MAX_BIT)
			local v = reading[rheader[type]](references)
			if(type ~= headers.reference) then
				if(type == headers.table) then
					num = #references + 1
				else
					references[num] = v
					num = num + 1
				end
			end
			ret[k] = v
		end
		return ret
	end
}


writing = {
	bit = net.WriteBit,
	Color = net.WriteColor,
	boolean = net.WriteBool,
	number = net.WriteDouble,
	byte = function(b)
		net.WriteInt(b, 8)
	end,
	word = function(w)
		net.WriteInt(w, 16)
	end,
	dword = function(d)
		net.WriteInt(d, 32)
	end,
	Entity = function(e)
		if(IsValid(e) or game.GetWorld() == e and e:EntIndex() < 2048) then
			net.WriteBool(true)
			net.WriteUInt(e:EntIndex(), 12)
			return
		end
		net.WriteBool(false)
	end,
	Vector = function(v)
		net.WriteFloat(v.x)
		net.WriteFloat(v.y)
		net.WriteFloat(v.z)
	end,
	Angle = function(a)
		net.WriteFloat(a.p)
		net.WriteFloat(a.y)
		net.WriteFloat(a.r)
	end,
	string = function(x)
		local compressed = util.Compress(x)
		if(#compressed < #x) then
			net.WriteBool(true)
			local len = bit.band(#compressed, 0x7FFF)
			net.WriteUInt(len, 16)
			net.WriteData(compressed, len)
		else -- we are doing this for zero embedded strings
			net.WriteBool(false)
			local len = bit.band(#x, 0x7FFF)
			net.WriteUInt(len, 16)
			net.WriteData(x, len)
		end
	end,
	table = function(tbl, indices, num)
		local done = {}
		num = num or 1
		local indices = indices or {}
		indices[tbl] = num
		num = num + 1
		if(#tbl ~= 0) then
			net.WriteBool(true)
			net.WriteUInt(#tbl, 16)
			for i = 1, #tbl do
				done[i] = true
				local v = tbl[i]
				if(indices[v]) then
					net.WriteUInt(headers.reference, MAX_BIT)
					net.WriteUInt(indices[v], REFERENCE_BIT)
				else
					local t = send_type(v)
					net.WriteUInt(headers[t], MAX_BIT)
					local _num = writing[t](v, rs, num)
					if(t ~= "table") then
						indices[v] = num
						num = num + 1
					else
						num = _num
					end
				end
			end
		else
			net.WriteBool(false)
		end
		for k,v in next, tbl, nil do
			if(done[k]) then continue end
			if(indices[k]) then
				net.WriteUInt(headers.reference, MAX_BIT)
				net.WriteUInt(indices[k], REFERENCE_BIT)
			else
				local t = send_type(k)
				net.WriteUInt(headers[t], MAX_BIT)
				local _num = writing[t](k, rs, num)
				if(t ~= "table") then
					indices[k] = num
					num = num + 1
				else
					num = _num
				end
			end
			
			if(indices[v]) then
				net.WriteUInt(headers.reference, MAX_BIT)
				net.WriteUInt(indices[v], REFERENCE_BIT)
			else
				local t = send_type(v)
				net.WriteUInt(headers[t], MAX_BIT)
				local _num = writing[t](v,rs, num)
				if(t ~= "table") then
					indices[v] = num
					num = num + 1
				else
					num = _num
				end
			end
		end
		net.WriteUInt(headers.endtable, MAX_BIT)
		return num
	end
}

net.WriteTable = writing.table
net.ReadTable = reading.table
