
concommand.Add( "whereis", function( _, _, _, path )

	local absolutePath = util.RelativePathToFull_Menu( path, "GAME" )

	if ( !absolutePath or !file.Exists( path, "GAME" ) ) then
		MsgN "File not found."
		return
	end

	local relativePath = util.FullPathToRelative_Menu( absolutePath, "MOD" )

	-- If the relative path is inside the workshop dir, it's part of a workshop addon
	if ( relativePath && relativePath:match( "^workshop[\\/].*" ) ) then

		local addonInfo = util.RelativePathToGMA_Menu( path )

		-- Not here? Maybe somebody just put their own file in ./workshop
		if ( addonInfo ) then

			local addonRelativePath = util.RelativePathToFull_Menu( addonInfo.File )

			MsgN( "'", addonInfo.Title, "' - ", addonRelativePath or addonInfo.File )
			return

		end

	end

	MsgN( absolutePath )

end, nil, "Searches for the highest priority instance of a file within the GAME mount path." )
