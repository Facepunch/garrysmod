local AddConsoleCommand = AddConsoleCommand
local string_lower = string.lower
local Msg = Msg

--[[---------------------------------------------------------
   Name: concommand
   Desc: A module to take care of the registration and calling
         of Lua console commands.
-----------------------------------------------------------]]
module( "concommand" )

local commandList = {}
local completeList = {}

--[[---------------------------------------------------------
   Name: concommand.GetTable( )
   Desc: Returns the table of console commands and auto complete
-----------------------------------------------------------]]
function GetTable()
	return commandList, completeList
end

--[[---------------------------------------------------------
   Name: concommand.Exists( name )
   Desc: Returns true if concommand exists
-----------------------------------------------------------]]
function Exists( name )
	return commandList[ string_lower( name ) ] != nil
end

--[[---------------------------------------------------------
   Name: concommand.Add( name, func, completefunc )
   Desc: Register a new console command
-----------------------------------------------------------]]
function Add( name, func, completefunc, help, flags )
	local LowerName = string_lower( name )
	commandList[ LowerName ] = func
	completeList[ LowerName ] = completefunc
	AddConsoleCommand( name, help, flags )
end

--[[---------------------------------------------------------
   Name: concommand.Remove( name )
   Desc: Removes a console command
-----------------------------------------------------------]]
function Remove( name )
	local LowerName = string_lower( name )
	commandList[ LowerName ] = nil
	completeList[ LowerName ] = nil
end

--[[---------------------------------------------------------
   Name: concommand.Run( )
   Desc: Called by the engine when an unknown console command is run
-----------------------------------------------------------]]
function Run( ply, command, arguments, argumentsString )
	local lowerCommand = string_lower( command )
	if (commandList[ lowerCommand ] != nil) then
		commandList[ lowerCommand ]( ply, command, arguments, argumentsString )
		return true
	end

	Msg( "Unknown command: " .. command .. "\n" )
	return false
end

--[[---------------------------------------------------------
   Name: concommand.AutoComplete( )
   Desc: Returns a table for the autocompletion
-----------------------------------------------------------]]
function AutoComplete( command, arguments )
	local lowerCommand = string_lower( command )
	if (completeList[ lowerCommand ] != nil) then
		return completeList[ lowerCommand ]( command, arguments )
	end
end