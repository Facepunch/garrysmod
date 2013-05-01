
-- Please don't edit this file!

-- Redirect call from the engine to the module (todo: change engine)
function InjectConsoleCommand( player, command, arguments, args )
	return concommand.Run( player, command, arguments, args )
end


function InjectCommandAutocomplete( command, arguments )
	return concommand.AutoComplete( command, arguments )
end



local AddConsoleCommand = AddConsoleCommand
local string = string


--[[---------------------------------------------------------
   Name: concommand
   Desc: A module to take care of the registration and calling
         of Lua console commands.
-----------------------------------------------------------]]
module("concommand")

local CommandList 		= {}
local CompleteList 		= {}
local CommandInfoList	= {}

--[[---------------------------------------------------------
   Name: concommand.GetTable( )
   Desc: Returns the table of console commands and auto complete
-----------------------------------------------------------]]
function GetTable()
	return CommandList, CompleteList
end

--[[---------------------------------------------------------
   Name: concommand.Get( )
   Desc: Returns info about the console command, such as helptext and flags.
-----------------------------------------------------------]]
function Get( cmd )
	return CommandInfoList[ cmd ]
end

--[[---------------------------------------------------------
   Name: concommand.Add( name, func, completefunc )
   Desc: Register a new console command
-----------------------------------------------------------]]
function Add( name, func, completefunc, help, flags )
	local LowerName = string.lower( name )
	CommandList[ LowerName ] = func
	CompleteList[ LowerName ] = completefunc
	CommandInfoList[ LowerName ] = { help = help, flags = flags, func = func, autocomplete = completefunc }
	AddConsoleCommand( name, help, flags )
end

--[[---------------------------------------------------------
   Name: concommand.Remove( name )
   Desc: Removes a console command
-----------------------------------------------------------]]
function Remove( name )
	local LowerName = string.lower( name )
	CommandList[ LowerName ] = nil
	CompleteList[ LowerName ] = nil
	CommandInfoList[ LowerName] = nil
end


--[[---------------------------------------------------------
   Name: concommand.Run( )
   Desc: Called by the engine when an unknown console command is run
-----------------------------------------------------------]]
function Run( player, command, arguments, args )

	local LowerCommand = string.lower( command )

	if ( CommandList[ LowerCommand ] != nil ) then
		CommandList[ LowerCommand ]( player, command, arguments, args )
		return true
	end

	if ( player:IsValid() ) then
		player:ChatPrint( "Unknown Command: '" .. command .. "'\n" )
	end
	
	return false;
end

--[[---------------------------------------------------------
   Name: concommand.AutoComplete( )
   Desc: Returns a table for the autocompletion
-----------------------------------------------------------]]
function AutoComplete( command, arguments )

	local LowerCommand = string.lower( command )

	if ( CompleteList[ LowerCommand ] != nil ) then
		return CompleteList[ LowerCommand ]( command, arguments )
	end
	
end

