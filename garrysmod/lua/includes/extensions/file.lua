


function file.Read( filename, path )

	if ( path == true ) then path = "GAME" end
	if ( path == nil || path == false ) then path = "DATA" end

	local f = file.Open( filename, "r", path )
	if ( !f ) then return end

	local str = f:Read( f:Size() )

	f:Close()

	if ( !str ) then str = "" end
	return str

end

function file.Write( filename, contents )

	local f = file.Open( filename, "w", "DATA" )
	if ( !f ) then return end

	f:Write( contents )
	f:Close()

end

function file.Append( filename, contents )

	local f = file.Open( filename, "a", "DATA" )
	if ( !f ) then return end

	f:Write( contents )
	f:Close()

end