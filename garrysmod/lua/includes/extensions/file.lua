--[[---------------------------------------------
	File Library
-----------------------------------------------]]

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
	if ( !f ) then return false end

	f:Write( contents )
	f:Close()

	return true

end

function file.Append( filename, contents )

	local f = file.Open( filename, "ab", "DATA" )
	if ( !f ) then return false end

	f:Write( contents )
	f:Close()

	return true

end

--[[---------------------------------------------
	File Meta
-----------------------------------------------]]

local File = FindMetaTable( "File" )

local function lineIterator( lines )

    local i = lines.i
	local last = lines.last

	if ( last and i > last ) then return end

    local line = lines[ i ]

    lines.i = i + 1

    return line

end

function File:Lines( fromLine, toLine )

    local position = self:Tell()
    local data = self:Read( self:Size() )

    self:Seek( position )

    local lines = string.Explode( "\n", data )
    
    lines.i = fromLine or 1
	lines.last = toLine

    return lineIterator, lines

end
