
-- Outputs functions and stuff in wiki format

local OUTPUT = ""

if ( SERVER ) then
	xside = file.Read( "ClientFunctions.txt" )
else
	xside = file.Read( "ServerFunctions.txt" )
end

file.CreateDir( "wikipages" )

xside = xside or ""

local function XSide( class, name )
	if ( string.find( xside, class .. "	" .. name ) ) then return "shared" end
	if ( string.find( xside, class .. "	" .. name ) ) then return "shared" end
	if ( SERVER ) then return "server" end
	return "client"
	
end

local IDelay = 1

local function AddWikiInfo( pagename, name, funcname )

	pagename = pagename:gsub( "^%l", string.upper )
	
	local url = "http://wiki.garrysmod.com/?title=" .. pagename
	local filename = "wikipages/"..pagename:Replace( ".", "_" )..".txt"
	if ( !file.Exists( filename, "GAME" ) ) then
	
		timer.Simple( IDelay, function()
		
			http.Get( url, "", function( c, s )
				if ( c != "" ) then
					Msg( "WRITING TO "..filename.."\n" )
				end
				file.Write( filename, c )
			end
			 )
			 
		end )
		
		IDelay = IDelay + 0.1
	
		 return "";
	end

	local str = file.Read( filename )
	
	local lines = string.Split( str, "\n" )
	local lineDesc = 0
	local lineSyntax = 0
	
	for num, line in pairs( lines ) do
	
		if ( line:find( "<b>Description:</b></td>" ) ) then lineDesc = num + 4 end
		if ( line:find( "<b>Syntax</b></td>" ) ) then lineSyntax = num + 2 end
				
	end
		
	local desc = tostring( lines[lineDesc] )
		desc = desc:Replace( "	", " " )
		desc = desc:gsub("<[^>]+", "" )
		desc = desc:Replace( ">", "" )
		desc = desc:Replace( "&nbsp;", " " )
		desc = desc:Replace( "  ", " " )
		desc = desc:Replace( "  ", " " )
		desc = desc:Trim( " " )	
			
	local syntax = tostring( lines[lineSyntax] )
		syntax = syntax:Replace( "	", " " )
		syntax = syntax:gsub("<[^>]+", "" )
		syntax = syntax:Replace( ">", "" )
		syntax = syntax:Replace( ">", "" )
		syntax = syntax:Replace( "&nbsp;", " " )
		syntax = syntax:Replace( "Where is this used?", "" )		
		syntax = syntax:Replace( "[", "" )
		syntax = syntax:Replace( "]", "" )
		syntax = syntax:Replace( "  ", " " )
		syntax = syntax:Replace( "  ", " " )
		syntax = syntax:Replace( name..":"..funcname, "" )
		syntax = syntax:Replace( name.."."..funcname, "" )
		syntax = syntax:Replace( funcname, "" )
		syntax = syntax:Replace( "(", "" )
		syntax = syntax:Replace( ")", "" )
		syntax = syntax:Replace( " ,", "," )
		syntax = syntax:Trim( " " )
		
	return desc .. "	" .. syntax

end


local function GetFunctions( tab )

	local functions = {}

	for k, v in pairs( tab ) do

		if ( isfunction(v) ) then
		
			table.insert( functions, tostring(k) )
		
		end
	
	end
	
	table.sort( functions )
	return functions

end


local function DoMetaTable( name )
	
	local func = GetFunctions( _R[ name ] )
	
	if ( type(_R[ name ]) != "table" ) then
		Msg("Error: _R["..name.."] is not a table!\n")
	end
	
	for k, v in pairs( func ) do
		OUTPUT = OUTPUT.."meta	"..name.."	"..v.."	"..XSide( name, v ).."	"..AddWikiInfo( name.."."..v, name, v ).."\n"
	end
	
end

local function DoLibrary( name )
	
--	OUTPUT = OUTPUT .. "\n\r==[["..name.."]] ([[Library]])==\n\r"
	
	if ( type(_G[ name ]) != "table" ) then
		Msg("Error: _G["..name.."] is not a table!\n")
	end
	
	local func = GetFunctions( _G[ name ] )
	for k, v in pairs( func ) do
		--OUTPUT = OUTPUT .. XSide( name, v ) .. " [["..name.."]].[["..name.."."..v.."|"..v.."]]<br />\n"
		OUTPUT = OUTPUT.."library	"..name.."	"..v.."	"..XSide( name, v ).."	"..AddWikiInfo( name.."."..v, name, v ).."\n"
	end
	
end

local function DoGlobals()
	
	local func = GetFunctions( _G )
	for k, v in pairs( func ) do
		OUTPUT = OUTPUT.."global	global	"..v.."	"..XSide( "global", v ).."	"..AddWikiInfo( "G."..v, v, v ).."\n"
	end
	
end

local Ignores = { "mathx", "stringx", "_G", "_R", "_E", "GAMEMODE", "g_SBoxObjects", "tablex", "color_black",
				  "color_white", "_LOADLIB", "_LOADED", "color_transparent", "func", "DOF_Ents", 
				  "Morph", "_ENT", "SKIN", "ComboBox_Emitter_Options", "ENT", "SpawniconGenFunctions" }

DoGlobals()

local t ={}

for k, v in pairs(_G) do
	if ( type(v) == "table" && type(k) == "string" && !table.HasValue( Ignores, k ) ) then
		table.insert( t, tostring(k) )
	end
end

table.sort( t )
for k, v in pairs( t ) do
	DoLibrary( v )
end


local t = {}

for k, v in pairs(_R) do
	if ( type(v) == "table" && type(k) == "string" && !table.HasValue( Ignores, k )  ) then
		table.insert( t, tostring(k) )
	end
end

table.sort( t )
for k, v in pairs( t ) do
	DoMetaTable( v )
end


if ( SERVER ) then
	file.Write( "ServerFunctions.txt", OUTPUT )
else
	file.Write( "ClientFunctions.txt", OUTPUT )
end


-- Add Missing functions...
local lines = string.Split( xside, "\n" )
for k, v in pairs( lines ) do
	if ( !string.find( OUTPUT, v ) ) then 
		OUTPUT = OUTPUT .. v .. "\n"
	end
end


file.Write( "All.txt", OUTPUT )
