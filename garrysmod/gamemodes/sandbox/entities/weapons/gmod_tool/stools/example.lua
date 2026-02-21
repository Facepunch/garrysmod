
-- Remove this to add it to the menu
TOOL.AddToMenu = false

-- Define these!
TOOL.Category = "My Category" -- Name of the category
TOOL.Name = "#tool.example.name" -- Name to display. # means it will be translated ( see below )

if ( true ) then return end -- Don't actually run anything below, remove this to make everything below functional

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( "tool.example.name", "My example tool" ) -- Add translation
end

-- An example clientside convar
TOOL.ClientConVar[ "CLIENTSIDE" ] = "default"

-- An example serverside convar
TOOL.ServerConVar[ "SERVERSIDE" ] = "default"

-- This function/hook is called when the player presses their left click
function TOOL:LeftClick( trace )
	Msg( "PRIMARY FIRE\n" )
end

-- This function/hook is called when the player presses their right click
function TOOL:RightClick( trace )
	Msg( "ALT FIRE\n" )
end

-- This function/hook is called when the player presses their reload key
function TOOL:Reload( trace )
	-- The SWEP doesn't reload so this does nothing :(
	Msg( "RELOAD\n" )
end

-- This function/hook is called every frame on client and every tick on the server
function TOOL:Think()
end
