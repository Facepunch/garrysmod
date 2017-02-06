local oldError = debug.getregistry()[1]

-- Override the error function to call our hook
debug.getregistry()[1] = function( strError )

	oldError( strError )
	hook.Run( "OnLuaError", strError, (CLIENT and 1 or 0) )
	
end
