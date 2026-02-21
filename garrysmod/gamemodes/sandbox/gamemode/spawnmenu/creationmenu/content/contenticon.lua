
AddCSLuaFile()

local PANEL = {}

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )

local matOverlay_AdminOnly = Material( "icon16/shield.png" )
local matOverlay_NPCWeapon = Material( "icon16/monkey.png" )
local matOverlay_NPCWeaponSelected = Material( "icon16/monkey_tick.png" )

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_Type", "ContentType" )
AccessorFunc( PANEL, "m_SpawnName", "SpawnName" )
AccessorFunc( PANEL, "m_NPCWeapon", "NPCWeapon" )
AccessorFunc( PANEL, "m_bAdminOnly", "AdminOnly" )
AccessorFunc( PANEL, "m_bIsNPCWeapon", "IsNPCWeapon" )

function PANEL:OpenGenericSpawnmenuRightClickMenu()

	local menu = DermaMenu()

		if ( self:GetSpawnName() and self:GetSpawnName() != "" ) then
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( self:GetSpawnName() ) end ):SetIcon( "icon16/page_copy.png" )
		end

		if ( isfunction( self.OpenMenuExtra ) ) then
			self:OpenMenuExtra( menu )
		end

		hook.Run( "SpawnmenuIconMenuOpen", menu, self, self:GetContentType() )

		if ( !IsValid( self:GetParent() ) || !self:GetParent().GetReadOnly || !self:GetParent():GetReadOnly() ) then
			menu:AddSpacer()
			menu:AddOption( "#spawnmenu.menu.delete", function()
				self:Remove()
				hook.Run( "SpawnlistContentChanged" )
			end ):SetIcon( "icon16/bin_closed.png" )
		end
	menu:Open()

end

function PANEL:Init()

	self:SetPaintBackground( false )
	self:SetSize( 128, 128 )
	self:SetText( "" )
	self:SetDoubleClickingEnabled( false )

	self.Image = self:Add( "DImage" )
	self.Image:SetPos( 3, 3 )
	self.Image:SetSize( 128 - 6, 128 - 6 )
	self.Image:SetVisible( false )

	self.Border = 0

end

function PANEL:SetName( name )

	self:SetTooltip( name )
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

function PANEL:DoRightClick()

	local pCanvas = self:GetSelectionCanvas()
	if ( IsValid( pCanvas ) && pCanvas:NumSelectedChildren() > 0 && self:IsSelected() ) then
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

local shadowColor = Color( 0, 0, 0, 200 )
local function DrawTextShadow( text, x, y )
	draw.SimpleText( text, "DermaDefault", x + 1, y + 1, shadowColor )
	draw.SimpleText( text, "DermaDefault", x, y, color_white )
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

	local drawText = false
	if ( !dragndrop.IsDragging() && ( self:IsHovered() || self.Depressed || self:IsChildHovered() ) ) then

		surface.SetMaterial( matOverlay_Hovered )

	else

		surface.SetMaterial( matOverlay_Normal )
		drawText = true

	end

	surface.DrawTexturedRect( self.Border, self.Border, w - self.Border * 2, h - self.Border * 2 )

	-- Admin only icon
	if ( self:GetAdminOnly() ) then
		surface.SetMaterial( matOverlay_AdminOnly )
		surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
	end

	-- Draw NPC weapon support icon
	-- This whole thing could be more dynamic
	if ( self:GetIsNPCWeapon() ) then
		surface.SetMaterial( matOverlay_NPCWeapon )

		if ( self:GetSpawnName() == GetConVarString( "gmod_npcweapon" ) ) then
			surface.SetMaterial( matOverlay_NPCWeaponSelected )
		end

		surface.DrawTexturedRect( w - self.Border - 24, self.Border + 8, 16, 16 )
	end

	self:ScanForNPCWeapons()

	if ( drawText ) then
		local buffere = self.Border + 10

		-- Set up smaller clipping so cut text looks nicer
		local px, py = self:LocalToScreen( buffere, 0 )
		local pw, ph = self:LocalToScreen( w - buffere, h )
		render.SetScissorRect( px, py, pw, ph, true )

		-- Calculate X pos
		surface.SetFont( "DermaDefault" )
		local tW, tH = surface.GetTextSize( self.m_NiceName )

		local x = w / 2 - tW / 2
		if ( tW > ( w - buffere * 2 ) ) then
			local mx, my = self:ScreenToLocal( input.GetCursorPos() )
			local diff = tW - w + buffere * 2

			x = buffere + math.Remap( math.Clamp( mx, 0, w ), 0, w, 0, -diff )
		end

		-- Draw
		DrawTextShadow( self.m_NiceName, x, h - tH - 9 )

		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

function PANEL:ScanForNPCWeapons()
	if ( self.HasScanned ) then return end
	self.HasScanned = true

	for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
		if ( v.class == self:GetSpawnName() ) then
			self:SetIsNPCWeapon( true )
			break
		end
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
	tab.admin		= self:GetAdminOnly()
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
	copy:SetAdminOnly( self:GetAdminOnly() )
	copy:CopyBase( self )
	copy.DoClick = self.DoClick
	copy.OpenMenu = self.OpenMenu
	copy.OpenMenuExtra = self.OpenMenuExtra
	copy:SetTooltip( self:GetTooltip() )

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

	local toolTip = language.GetPhrase( obj.nicename )

	-- Generate a nice tooltip with extra info.
	local ENTinfo = scripted_ents.Get( obj.spawnname )
	if ( !ENTinfo ) then ENTinfo = list.GetEntry( "SpawnableEntities", obj.spawnname ) end
	if ( ENTinfo ) then
		local extraInfo = ""
		if ( ENTinfo.Information and ENTinfo.Information != "" ) then extraInfo = extraInfo .. "\n" .. ENTinfo.Information end
		if ( ENTinfo.Author and ENTinfo.Author != "" ) then extraInfo = extraInfo .. "\n" .. language.GetPhrase( "entityinfo.author" ) .. " " .. ENTinfo.Author end
		if ( #extraInfo > 0 ) then toolTip = toolTip .. "\n" .. extraInfo end
	end

	icon:SetTooltip( toolTip )

	icon.DoClick = function()
		RunConsoleCommand( "gm_spawnsent", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	icon.OpenMenuExtra = function( self, menu )
		menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function()
			RunConsoleCommand( "gmod_tool", "creator" )
			RunConsoleCommand( "creator_type", "0" )
			RunConsoleCommand( "creator_name", obj.spawnname )
		end ):SetIcon( "icon16/brick_add.png" )
	end
	icon.OpenMenu = icon.OpenGenericSpawnmenuRightClickMenu

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

	local toolTip = language.GetPhrase( obj.nicename )

	-- Generate a nice tooltip with extra info
	local VehInfo = list.GetEntry( "Vehicles", obj.spawnname )
	if ( VehInfo ) then
		local extraInfo = ""
		if ( VehInfo.Information and VehInfo.Information != "" ) then extraInfo = extraInfo .. "\n" .. VehInfo.Information end
		if ( VehInfo.Author and VehInfo.Author != "" ) then extraInfo = extraInfo .. "\n" .. language.GetPhrase( "entityinfo.author" ) .." " .. VehInfo.Author end
		if ( #extraInfo > 0 ) then toolTip = toolTip .. "\n" .. extraInfo end
	end

	icon:SetTooltip( toolTip )

	icon.DoClick = function()
		RunConsoleCommand( "gm_spawnvehicle", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	icon.OpenMenuExtra = function( self, menu )
		menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function()
			RunConsoleCommand( "gmod_tool", "creator" )
			RunConsoleCommand( "creator_type", "1" )
			RunConsoleCommand( "creator_name", obj.spawnname )
		end ):SetIcon( "icon16/brick_add.png" )
	end
	icon.OpenMenu = icon.OpenGenericSpawnmenuRightClickMenu

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

local gmod_npcweapon = CreateConVar( "gmod_npcweapon", "", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "Overrides the weapon all spawnmenu NPCs will spawn with. Set to \"\" to not override." )

spawnmenu.AddContentType( "npc", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	if ( !obj.weapon ) then obj.weapon = {} end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "npc" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon:SetAdminOnly( obj.admin )
	icon:SetNPCWeapon( obj.weapon )
	icon:SetColor( Color( 244, 164, 96, 255 ) )

	local toolTip = language.GetPhrase( obj.nicename )

	-- Generate a nice tooltip with extra info.
	local NPCinfo = scripted_ents.Get( obj.spawnname )
	if ( !NPCinfo ) then NPCinfo = list.GetEntry( "NPC", obj.spawnname ) end
	if ( NPCinfo ) then
		local extraInfo = ""
		if ( NPCinfo.Information and NPCinfo.Information != "" ) then extraInfo = extraInfo .. "\n" .. NPCinfo.Information end
		if ( NPCinfo.Author and NPCinfo.Author != "" ) then extraInfo = extraInfo .. "\n" .. language.GetPhrase( "entityinfo.author" ) .. " " .. NPCinfo.Author end
		if ( #extraInfo > 0 ) then toolTip = toolTip .. "\n" .. extraInfo end
	end

	icon:SetTooltip( toolTip )

	icon.DoClick = function()
		local weapon = table.Random( obj.weapon ) or ""
		if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end

		RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, weapon )
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end

	icon.OpenMenuExtra = function( self, menu )

		local creatorOption = menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function()
			RunConsoleCommand( "gmod_tool", "creator" )
			RunConsoleCommand( "creator_type", "2" )
			RunConsoleCommand( "creator_name", obj.spawnname )
			RunConsoleCommand( "creator_override", "" )
		end )
		creatorOption:SetIcon( "icon16/brick_add.png" )

		-- Quick access to spawning NPCs with a spcific weapon without the need to change gmod_npcweapon
		if ( table.IsEmpty( obj.weapon ) ) then return end

		local creatorMenu = creatorOption:AddSubMenu()

		local wepMenu, swg = menu:AddSubMenu( "#spawnmenu.menu.spawn_with_weapon" )
		swg:SetIcon( "icon16/gun.png" )

		local function addWeps( menu1, menu2, weps )
			if ( table.Count( weps ) < 1 ) then return end

			menu1:AddSpacer()
			for title, info in SortedPairs( weps ) do
				menu1:AddOption( title, function() RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, info.class ) end ):SetIcon( info.icon )
			end

			menu2:AddSpacer()
			for title, info in SortedPairs( weps ) do
				menu2:AddOption( title, function()
					RunConsoleCommand( "gmod_tool", "creator" )
					RunConsoleCommand( "creator_type", "2" )
					RunConsoleCommand( "creator_name", obj.spawnname )
					RunConsoleCommand( "creator_override", info.class )
				end ):SetIcon( info.icon )
			end
		end

		-- Default weapons
		local weaps = {}
		for _, class in pairs( obj.weapon ) do
			if ( class == "" ) then continue end
			weaps[ language.GetPhrase( class ) ] = { class = class, icon = "icon16/gun.png" }
		end
		addWeps( wepMenu, creatorMenu, weaps )

		-- After the default weapons for consistency with other menus that do this
		weaps = { [ "#menubar.npcs.noweapon" ] = { class = "none", icon = "icon16/cross.png" } }
		addWeps( wepMenu, creatorMenu, weaps )

		-- Custom weapons, sorted the items by name, and group by category
		local groupedWeps = {}
		local CustomIcons = list.Get( "ContentCategoryIcons" )
		for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
			if ( table.HasValue( obj.weapon, v.class ) ) then continue end
	
			local cat = ( v.category or "" ):lower()
			groupedWeps[ cat ] = groupedWeps[ cat ] or {}
			groupedWeps[ cat ][ language.GetPhrase( v.title ) ] = { class = v.class, icon = CustomIcons[ v.category or "" ] or "icon16/gun.png" }
		end
		for group, items in SortedPairs( groupedWeps ) do
			addWeps( wepMenu, creatorMenu, items )
		end

	end
	icon.OpenMenu = icon.OpenGenericSpawnmenuRightClickMenu

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

	local toolTip = language.GetPhrase( obj.nicename )

	-- Generate a nice tooltip with extra info.
	local SWEPinfo = weapons.Get( obj.spawnname )
	if ( !SWEPinfo ) then SWEPinfo = list.GetEntry( "Weapon", obj.spawnname ) end
	if ( SWEPinfo ) then
		local extraInfo = ""
		-- These 2 really should be one
		if ( SWEPinfo.Purpose and SWEPinfo.Purpose != "" ) then toolTip = toolTip .. "\n" .. SWEPinfo.Purpose end
		if ( SWEPinfo.Instructions and SWEPinfo.Instructions != "" ) then toolTip = toolTip .. "\n" .. SWEPinfo.Instructions end

		if ( SWEPinfo.Author and SWEPinfo.Author != "" ) then toolTip = toolTip .. "\n" .. language.GetPhrase( "entityinfo.author" ) .. " " .. SWEPinfo.Author end
		if ( #extraInfo > 0 ) then toolTip = toolTip .. "\n" .. extraInfo end
	end

	toolTip = toolTip .. "\n\n" .. language.GetPhrase( "spawnmenu.mmb_weapons" )

	icon:SetTooltip( toolTip )

	icon.DoClick = function()

		RunConsoleCommand( "gm_giveswep", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )

	end

	icon.DoMiddleClick = function()

		RunConsoleCommand( "gm_spawnswep", obj.spawnname )
		surface.PlaySound( "ui/buttonclickrelease.wav" )

	end

	icon.OpenMenuExtra = function( self, menu )
		menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function()
			RunConsoleCommand( "gmod_tool", "creator" )
			RunConsoleCommand( "creator_type", "3" )
			RunConsoleCommand( "creator_name", obj.spawnname )
		end ):SetIcon( "icon16/brick_add.png" )

		if ( self:GetIsNPCWeapon() ) then
			local opt = menu:AddOption( "#spawnmenu.menu.use_as_npc_gun", function() RunConsoleCommand( "gmod_npcweapon", self:GetSpawnName() ) end )
			if ( self:GetSpawnName() == GetConVarString( "gmod_npcweapon" ) ) then
				opt:SetIcon( "icon16/monkey_tick.png" )
			else
				opt:SetIcon( "icon16/monkey.png" )
			end
		end
	end
	icon.OpenMenu = icon.OpenGenericSpawnmenuRightClickMenu

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )
