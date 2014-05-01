
module( "properties", package.seeall )

local meta = {
	MsgStart = function( self )
	
		net.Start( "properties" )
		net.WriteUInt( util.NetworkStringToID( self.InternalName ), 32 )
	
	end,
	
	MsgEnd = function( self )
	
		net.SendToServer()
	
	end
}

meta.__index = meta

List = {}
-- .MenuLabel				[string]	Label to show on opened menu
-- .Filter( ent )			[function]	Return true if we should show a menu for this entity
-- .Action( ent )			[function]	On menu choice selected
-- .Order					[int]		The order in which it should be shown on the menu
-- .Receive( len, ply )		[function]	A message has been received from the clientside version

function Add( name, tab )

	name = name:lower()
	tab.InternalName = name	
	setmetatable( tab, meta )
	
	List[ name ] = tab
	
	if ( SERVER ) then
		util.AddNetworkString( name )
	end

end

local function AddToggleOption( data, menu, ent, ply, tr )

	if ( !menu.ToggleSpacer ) then
		menu.ToggleSpacer = menu:AddSpacer()
		menu.ToggleSpacer:SetZPos( 500 )
	end

	local option = menu:AddOption( data.MenuLabel, function() data:Action( ent, tr ) end )
	option:SetChecked( data:Checked( ent, ply ) )
	option:SetZPos( 501 )
	return option

end

local function AddOption( data, menu, ent, ply, tr )

	if ( data.Type == "toggle" ) then return AddToggleOption( data, menu, ent, ply, tr ) end

	if ( data.PrependSpacer ) then 
		menu:AddSpacer()
	end

	local option = menu:AddOption( data.MenuLabel, function() data:Action( ent, tr ) end )

	if ( data.MenuIcon ) then
		option:SetImage( data.MenuIcon )
	end

	if ( data.MenuOpen ) then
		data.MenuOpen( data, option, ent, tr )
	end

	return option

end

function OpenEntityMenu( ent, tr )

	local menu = DermaMenu()
	
	for k, v in SortedPairsByMemberValue( List, "Order" ) do
		
		if ( !v.Filter ) then continue end
		if ( !v:Filter( ent, LocalPlayer() ) ) then continue end
		
		local option = AddOption( v, menu, ent, LocalPlayer(), tr )

		if ( v.OnCreate ) then v:OnCreate( menu, option ) end

	end
	
	menu:Open()

end

function GetHovered( eyepos, eyevec )

	local filter = { LocalPlayer():GetViewEntity() }
	if ( LocalPlayer():GetViewEntity() == LocalPlayer() && IsValid( LocalPlayer():GetVehicle() ) && !LocalPlayer():GetVehicle():GetThirdPersonMode() ) then table.insert( filter, LocalPlayer():GetVehicle() ) end

	local trace = util.TraceLine( {
		start = eyepos,
		endpos = eyepos + eyevec * 1024,
		filter = filter
	} )
	
	if ( !trace.Hit ) then return end
	if ( !IsValid( trace.Entity ) ) then return end
	
	return trace.Entity, trace

end

function OnScreenClick( eyepos, eyevec )

	local ent, tr = GetHovered( eyepos, eyevec )
	if ( !IsValid( ent ) ) then return end
	
	OpenEntityMenu( ent, tr )

end


-- Receives commands from clients
if ( SERVER ) then

	util.AddNetworkString( "properties" )

	net.Receive( "properties", function( len, client )
	
		local i = net.ReadUInt( 32 )
		local name = util.NetworkIDToString( i )

		if ( !name ) then return end
		if ( !IsValid( client ) ) then return end
		
		local prop = List[ name ]
		if ( !prop ) then return end
		if ( !prop.Receive ) then return end
		
		prop:Receive( len, client )
		
	end )

end

if ( CLIENT ) then

	function HaloThink()

		if ( vgui.GetHoveredPanel() != vgui.GetWorldPanel() && vgui.GetHoveredPanel() != g_ContextMenu ) then return end
	
		local ent = properties.GetHovered( EyePos(), LocalPlayer():GetAimVector() )
		if ( !IsValid( ent ) ) then return end
		
		local c = Color( 255, 255, 255, 255 )
		c.r = 200 + math.sin( RealTime() * 50 ) * 55
		c.g = 200 + math.sin( RealTime() * 20 ) * 55
		c.b = 200 + math.cos( RealTime() * 60 ) * 55
		
		halo.Add( { ent }, c, 2, 2, 2, true, false )
	
	end 

	--
	-- Hook the GUIMousePressed call, which is called when the client clicks on the
	-- gui.
	--
	hook.Add( "GUIMousePressed", "PropertiesClick", function( code, vector )

		if ( code == MOUSE_RIGHT && !input.IsButtonDown( MOUSE_LEFT ) ) then
			OnScreenClick( EyePos(), vector )
		end

	end )

	--
	-- Hook the GUIMousePressed call, which is called when the client clicks on the
	-- gui.
	--
	hook.Add( "PreventScreenClicks", "PropertiesPreventClicks", function()

		local ply = LocalPlayer()
		if ( !IsValid( ply ) ) then return end

		--
		-- Are we pressing the right mouse button?
		-- (We check whether we're pressing the left too, to allow for physgun freezes)
		--
		if ( input.IsButtonDown( MOUSE_RIGHT ) && !input.IsButtonDown( MOUSE_LEFT ) ) then

			--
			-- Are we hovering an entity? If so, then stomp the action
			--
			local hovered = GetHovered( ply:EyePos(), ply:GetAimVector() )

			if ( IsValid( hovered )  ) then
				return true
			end

		end

	end )

end
