
function file.Read( filename, path )

	if ( path == true ) then path = "GAME" end
	if ( path == nil || path == false ) then path = "DATA" end

	local f = file.Open( filename, "rb", path )
	if ( !f ) then return nil end

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
