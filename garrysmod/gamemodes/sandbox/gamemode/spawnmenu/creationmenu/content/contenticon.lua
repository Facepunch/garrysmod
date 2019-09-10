
AddCSLuaFile()

local PANEL = {}

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )
local matOverlay_AdminOnly = Material( "icon16/shield.png" )

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_Type", "ContentType" )
AccessorFunc( PANEL, "m_SpawnName", "SpawnName" )
AccessorFunc( PANEL, "m_NPCWeapon", "NPCWeapon" )

function PANEL:Init()

	self:SetPaintBackground( false )
	self:SetSize( 128, 128 )
	self:SetText( "" )
	self:SetDoubleClickingEnabled( false )

	self.Image = self:Add( "DImage" )
	self.Image:SetPos( 3, 3 )
	self.Image:SetSize( 128 - 6, 128 - 6 )
	self.Image:SetVisible( false )

	self.Label = self:Add( "DLabel" )
	self.Label:Dock( BOTTOM )
	self.Label:SetTall( 18 )
	self.Label:SetContentAlignment( 5 )
	self.Label:DockMargin( 4, 0, 4, 6 )
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )

	self.Border = 0

end

function PANEL:SetName( name )

	self:SetTooltip( name )
	self.Label:SetText( name )
	self.m_NiceName = name

end

function PANEL:SetMaterial( name )

	self.m_MaterialName = name

	local mat = Material( name )

	-- Look for the old style material
	if ( !mat || mat:IsError() ) then

		name = name:Replace( "entities/", "VGUI/entities/" )
		name = name:Replace( ".png", "" )
		mat = Material( name )

	end

	-- Couldn't find any material.. just return
	if ( !mat || mat:IsError() ) then
		return
	end

	self.Image:SetMaterial( mat )

end

function PANEL:SetAdminOnly( b )
	self.AdminOnly = b
end

function PANEL:DoRightClick()

	local pCanvas = self:GetSelectionCanvas()
	if ( IsValid( pCanvas ) && pCanvas:NumSelectedChildren() > 0 ) then
		return hook.Run( "SpawnlistOpenGenericMenu", pCanvas )
	end

	self:OpenMenu()

end

function PANEL:DoClick()
end

function PANEL:OpenMenu()
end

function PANEL:OnDepressionChanged( b )
end

function PANEL:Paint( w, h )

	if ( self.Depressed && !self.Dragging ) then
		if ( self.Border != 8 ) then
			self.Border = 8
			self:OnDepressionChanged( true )
		end
	else
		if ( self.Border != 0 ) then
			self.Border = 0
			self:OnDepressionChanged( false )
		end
	end

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	self.Image:PaintAt( 3 + self.Border, 3 + self.Border, 128 - 8 - self.Border * 2, 128 - 8 - self.Border * 2 )

	render.PopFilterMin()
	render.PopFilterMag()

	surface.SetDrawColor( 255, 255, 255, 255 )

	if ( !dragndrop.IsDragging() && ( self:IsHovered() || self.Depressed || self:IsChildHovered() ) ) then

		surface.SetMaterial( matOverlay_Hovered )
		self.Label:Hide()

	else

		surface.SetMaterial( matOverlay_Normal )
		self.Label:Show()

	end

	surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

	if ( self.AdminOnly ) then
		surface.SetMaterial( matOverlay_AdminOnly )
		surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
	end

end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

function PANEL:ToTable( bigtable )

	local tab = {}

	tab.type		= self:GetContentType()
	tab.nicename	= self.m_NiceName
	tab.material	= self.m_MaterialName
	tab.admin		= self.AdminOnly
	tab.spawnname	= self:GetSpawnName()
	tab.weapon		= self:GetNPCWeapon()

	table.insert( bigtable, tab )

end

function PANEL:Copy()

	local copy = vgui.Create( "ContentIcon", self:GetParent() )

	copy:SetContentType( self:GetContentType() )
	copy:SetSpawnName( self:GetSpawnName() )
	copy:SetName( self.m_NiceName )
	copy:SetMaterial( self.m_MaterialName )
	copy:SetNPCWeapon( self:GetNPCWeapon() )
	copy:SetAdminOnly( self.AdminOnly )
	copy:CopyBase( self )
	copy.DoClick = self.DoClick
	copy.OpenMenu = self.OpenMenu

	return copy

end

vgui.Register( "ContentIcon", PANEL, "DButton" )

spawnmenu.AddContentType( "entity", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "entity" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetColor( Color( 205, 92, 92, 255 ) )
	icon.DoClick = function()
		RunConsoleCommand( "gm_spawnsent", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( obj.spawnname ) end ):SetIcon( "icon16/page_copy.png" )
			menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "0" ) RunConsoleCommand( "creator_name", obj.spawnname ) end ):SetIcon( "icon16/brick_add.png" )
			menu:AddSpacer()
			menu:AddOption( "#spawnmenu.menu.delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end ):SetIcon( "icon16/bin_closed.png" )
		menu:Open()

	end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

spawnmenu.AddContentType( "vehicle", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "vehicle" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetColor( Color( 0, 0, 0, 255 ) )
	icon.DoClick = function()
		RunConsoleCommand( "gm_spawnvehicle", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( obj.spawnname ) end ):SetIcon( "icon16/page_copy.png" )
			menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "1" ) RunConsoleCommand( "creator_name", obj.spawnname ) end ):SetIcon( "icon16/brick_add.png" )
			menu:AddSpacer()
			menu:AddOption( "#spawnmenu.menu.delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end ):SetIcon( "icon16/bin_closed.png" )
		menu:Open()

	end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

local gmod_npcweapon = CreateConVar( "gmod_npcweapon", "", { FCVAR_ARCHIVE } )

spawnmenu.AddContentType( "npc", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	if ( !obj.weapon ) then obj.weapon = { "" } end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "npc" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetNPCWeapon( obj.weapon )
	icon:SetColor( Color( 244, 164, 96, 255 ) )

	icon.DoClick = function()

		local weapon = table.Random( obj.weapon )
		if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end

		RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, weapon )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end

	icon.OpenMenu = function( icon )

		local menu = DermaMenu()

			local weapon = table.Random( obj.weapon )
			if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end

			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( obj.spawnname ) end ):SetIcon( "icon16/page_copy.png" )
			menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "2" ) RunConsoleCommand( "creator_name", obj.spawnname ) RunConsoleCommand( "creator_arg", weapon ) end ):SetIcon( "icon16/brick_add.png" )
			menu:AddSpacer()
			menu:AddOption( "#spawnmenu.menu.delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end ):SetIcon( "icon16/bin_closed.png" )
		menu:Open()

	end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

spawnmenu.AddContentType( "weapon", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "weapon" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetColor( Color( 135, 206, 250, 255 ) )
	icon.DoClick = function()

		RunConsoleCommand( "gm_giveswep", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )

	end

	icon.DoMiddleClick = function()

		RunConsoleCommand( "gm_spawnswep", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )

	end

	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( obj.spawnname ) end ):SetIcon( "icon16/page_copy.png" )
			menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "3" ) RunConsoleCommand( "creator_name", obj.spawnname ) end ):SetIcon( "icon16/brick_add.png" )
			menu:AddSpacer()
			menu:AddOption( "#spawnmenu.menu.delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end ):SetIcon( "icon16/bin_closed.png" )
		menu:Open()

	end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )
