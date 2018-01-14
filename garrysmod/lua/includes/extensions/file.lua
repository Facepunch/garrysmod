local meta = FindMetaTable( "File" )

--
-- Int32
--
meta.WriteInt32 = meta.WriteLong
meta.ReadInt32 = meta.ReadLong

function meta:WriteUInt32( int32 )
	if int32 >= 0x80000000 then
		int32 = int32 - 0x100000000
	end
	self:WriteInt32( int32 )
end

function meta:ReadUInt32()
	local int32 = self:ReadInt32()
	if int32 < 0 then
		int32 = int32 + 0x100000000
	end
	return int32
end

--
-- Int16
--
meta.WriteInt16 = meta.WriteShort
meta.ReadInt16 = meta.ReadShort

function meta:WriteUInt16( int16 )
	if int16 >= 0x8000 then
		int16 = int16 - 0x10000
	end
	self:WriteInt16( int16 )
end

function meta:ReadUInt16()
	local int16 = self:ReadInt16()
	if int16 < 0 then
		int16 = int16 + 0x10000
	end
	return int16
end

--
-- Int8
--
meta.WriteUInt8 = meta.WriteByte
meta.ReadUInt8 = meta.ReadByte

function meta:WriteInt8( int8 )
	if int8 < 0 then
		int8 = int8 + 0x100
	end
	self:WriteUInt8( int8 )
end

function meta:ReadInt8( )
	local int8 = self:ReadUInt8()
	if int8 >= 0x80 then
		int8 = int8 - 0x100
	end
	return int8
end

function file.Read( filename, path )

	if ( path == true ) then path = "GAME" end
	if ( path == nil || path == false ) then path = "DATA" end

	local f = file.Open( filename, "rb", path )
	if ( !f ) then return end

	local str = f:Read( f:Size() )

	f:Close()

	if ( !str ) then str = "" end
	return str

end

function file.Write( filename, contents )

	local f = file.Open( filename, "wb", "DATA" )
	if ( !f ) then return end

	f:Write( contents )
	f:Close()

end

function file.Append( filename, contents )

	local f = file.Open( filename, "ab", "DATA" )
	if ( !f ) then return end

	f:Write( contents )
	f:Close()

end
