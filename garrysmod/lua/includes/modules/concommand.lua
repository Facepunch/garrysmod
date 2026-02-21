
local AddConsoleCommand = AddConsoleCommand
local string = string
local Msg = Msg

--[[---------------------------------------------------------
   Name: concommand
   Desc: A module to take care of the registration and calling
         of Lua console commands.
-----------------------------------------------------------]]
module( "concommand" )

local CommandList = {}
local CompleteList = {}

--[[---------------------------------------------------------
   Name: concommand.GetTable( )
   Desc: Returns the table of console commands and auto complete
-----------------------------------------------------------]]
function GetTable()
	return CommandList, CompleteList
end

--[[---------------------------------------------------------
   Name: concommand.Add( name, func, completefunc )
   Desc: Register a new console command
-----------------------------------------------------------]]
function Add( name, func, completefunc, help, flags )
	local LowerName = string.lower( name )
	CommandList[ LowerName ] = func
	CompleteList[ LowerName ] = completefunc
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
end

--[[---------------------------------------------------------
   Name: concommand.Run( )
   Desc: Called by the engine when an unknown console command is run
-----------------------------------------------------------]]
function Run( player, command, arguments, argumentsStr )

	local LowerCommand = string.lower( command )

	if ( CommandList[ LowerCommand ] != nil ) then
		CommandList[ LowerCommand ]( player, command, arguments, argumentsStr )
		return true
	end

	Msg( "Unknown command: " .. command .. "\n" )

	return false
end

--[[---------------------------------------------------------
   Name: concommand.AutoComplete( )
   Desc: Returns a table for the autocompletion
-----------------------------------------------------------]]
function AutoComplete( command, argumentsStr, arguments )

	local LowerCommand = string.lower( command )

	if ( CompleteList[ LowerCommand ] != nil ) then
		return CompleteList[ LowerCommand ]( command, argumentsStr, arguments )
	end

end
