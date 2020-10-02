
module( "properties", package.seeall )

local meta = {
	MsgStart = function( self )

		net.Start( "properties" )
		net.WriteString( self.InternalName )

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

function OnScreenClick( eyepos, eyevec )

	local ent, tr = GetHovered( eyepos, eyevec )
	if ( !IsValid( ent ) ) then return end

	OpenEntityMenu( ent, tr )

end

-- Use this check in your properties to see if given entity can be affected by it
-- Ideally this should be done automatically for you, but due to how this system was set up, its now impossible
function CanBeTargeted( ent, ply )
	if ( !IsValid( ent ) ) then return false end
	if ( ent:IsPlayer() ) then return false end

	-- Check the range if player object is given
	-- This is not perfect, but it is close enough and its definitely better than nothing
	if ( IsValid( ply ) ) then
		local mins = ent:OBBMins()
		local maxs = ent:OBBMaxs()
		local maxRange = math.max( math.abs( mins.x ) + maxs.x, math.abs( mins.y ) + maxs.y, math.abs( mins.z ) + maxs.z )
		if ( ent:GetPos():Distance( ply:GetShootPos() ) > maxRange + 1024 ) then return false end
	end

	return !( ent:GetPhysicsObjectCount() < 1 && ent:GetSolid() == SOLID_NONE && bit.band( ent:GetSolidFlags(), FSOLID_USE_TRIGGER_BOUNDS ) == 0 && bit.band( ent:GetSolidFlags(), FSOLID_CUSTOMRAYTEST ) == 0 )
end

function GetHovered( eyepos, eyevec )

	local ply = LocalPlayer()
	local filter = ply:GetViewEntity()

	if ( filter == ply ) then
		local veh = ply:GetVehicle()

		if ( veh:IsValid() && ( !veh:IsVehicle() || !veh:GetThirdPersonMode() ) ) then
			-- A dirty hack for prop_vehicle_crane. util.TraceLine returns the vehicle but it hits phys_bone_follower - something that needs looking into
			filter = { filter, veh, unpack( ents.FindByClass( "phys_bone_follower" ) ) }
		end
	end

	local trace = util.TraceLine( {
		start = eyepos,
		endpos = eyepos + eyevec * 1024,
		filter = filter
	} )

	-- Hit COLLISION_GROUP_DEBRIS and stuff
	if ( !trace.Hit || !IsValid( trace.Entity ) ) then
		trace = util.TraceLine( {
			start = eyepos,
			endpos = eyepos + eyevec * 1024,
			filter = filter,
			mask = MASK_ALL
		} )
	end

	if ( !trace.Hit || !IsValid( trace.Entity ) ) then return end

	return trace.Entity, trace

end

-- Receives commands from clients
if ( SERVER ) then

	util.AddNetworkString( "properties" )

	net.Receive( "properties", function( len, client )
		if ( !IsValid( client ) ) then return end

		local name = net.ReadString()
		if ( !name ) then return end

		local prop = List[ name ]
		if ( !prop ) then return end
		if ( !prop.Receive ) then return end

		prop:Receive( len, client )

	end )

end

if ( CLIENT ) then

	hook.Add( "PreDrawHalos", "PropertiesHover", function()

		if ( !IsValid( vgui.GetHoveredPanel() ) || !vgui.GetHoveredPanel():IsWorldClicker() ) then return end

		local ent = GetHovered( EyePos(), LocalPlayer():GetAimVector() )
		if ( !IsValid( ent ) ) then return end

		local c = Color( 255, 255, 255, 255 )
		c.r = 200 + math.sin( RealTime() * 50 ) * 55
		c.g = 200 + math.sin( RealTime() * 20 ) * 55
		c.b = 200 + math.cos( RealTime() * 60 ) * 55

		local t = { ent }
		if ( ent.GetActiveWeapon && IsValid( ent:GetActiveWeapon() ) ) then table.insert( t, ent:GetActiveWeapon() ) end
		halo.Add( t, c, 2, 2, 2, true, false )

	end )

	hook.Add( "GUIMousePressed", "PropertiesClick", function( code, vector )

		if ( !IsValid( vgui.GetHoveredPanel() ) || !vgui.GetHoveredPanel():IsWorldClicker() ) then return end

		if ( code == MOUSE_RIGHT && !input.IsButtonDown( MOUSE_LEFT ) ) then
			OnScreenClick( EyePos(), vector )
		end

	end )

	local wasPressed = false
	hook.Add( "PreventScreenClicks", "PropertiesPreventClicks", function()

		if ( !input.IsButtonDown( MOUSE_RIGHT ) ) then wasPressed = false end

		if ( wasPressed && input.IsButtonDown( MOUSE_RIGHT ) && !input.IsButtonDown( MOUSE_LEFT ) ) then return true end

		if ( !IsValid( vgui.GetHoveredPanel() ) || !vgui.GetHoveredPanel():IsWorldClicker() ) then return end

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
			local hovered = GetHovered( EyePos(), ply:GetAimVector() )

			if ( IsValid( hovered ) ) then
				wasPressed = true
				return true
			end

		end

	end )

end
