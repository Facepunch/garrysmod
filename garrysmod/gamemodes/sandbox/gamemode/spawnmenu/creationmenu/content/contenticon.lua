
AddCSLuaFile()

local PANEL = {}

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )

AccessorFunc( PANEL, "m_Color", 			"Color" )
AccessorFunc( PANEL, "m_Type", 				"ContentType" )
AccessorFunc( PANEL, "m_SpawnName", 		"SpawnName" )
AccessorFunc( PANEL, "m_NPCWeapon", 		"NPCWeapon" )

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDrawBackground( false )
	self:SetSize( 128, 128 )
	self:SetText( "" )
	self:SetDoubleClickingEnabled( false )
	
	self.Image = self:Add( "DImage" )
	self.Image:SetPos( 3, 3 )
	self.Image:SetSize( 128 - 6, 128 - 6 )
	self.Image:SetVisible( false )

	self.Label = self:Add( "DLabel" )
	self.Label:Dock( BOTTOM )
	self.Label:SetContentAlignment( 2 )
	self.Label:DockMargin( 4, 0, 4, 10 )
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )

	self.Border = 0
	
end

function PANEL:SetName( name )

	self:SetTooltip( name )
	self.Label:SetText( name )
	self.m_NiceName = name;
	

end

function PANEL:SetMaterial( name )

	self.m_MaterialName = name;

	local mat = Material( name )
	
	-- Look for the old style material
	if ( !mat || mat:IsError() ) then
	
		name = name:Replace( "entities/", "VGUI/entities/" )
		name = name:Replace( ".png", "" )
		mat = Material( name );
		
	end

	-- Couldn't find any material.. just return
	if ( !mat || mat:IsError() ) then
		return 
	end
	
	self.Image:SetMaterial( mat );
	
end

function PANEL:SetAdminOnly( b )
	
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
	
	self.Image:PaintAt( 3 + self.Border, 3 + self.Border, 128-8-self.Border*2, 128-8-self.Border*2 )

	surface.SetDrawColor( 255, 255, 255, 255 )
	
	if ( !dragndrop.IsDragging() && (self:IsHovered() || self:IsChildHovered( 2 )) ) then

		surface.SetMaterial( matOverlay_Hovered )
		self.Label:Hide()

	else

		surface.SetMaterial( matOverlay_Normal )
		self.Label:Show()

	end
	
	surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

function PANEL:ToTable( bigtable )

	local tab = {}
	
	tab.type		= self:GetContentType();
	tab.nicename	= self.m_NiceName;
	tab.material	= self.m_MaterialName;
	tab.spawnname	= self:GetSpawnName();
	tab.weapon		= self:GetNPCWeapon();

	table.insert( bigtable, tab )

end

function PANEL:Copy()

	local copy = vgui.Create( "ContentIcon", self:GetParent() )

	copy:SetContentType( self:GetContentType() )
	copy:SetSpawnName( self:GetSpawnName() )
	copy:SetName( self.m_NiceName )
	copy:SetMaterial( self.m_MaterialName )
	copy:SetNPCWeapon( self:GetNPCWeapon() )
	-- copy:SetAdminOnly( obj.admin )
	copy:CopyBase( self )
	copy.DoClick = self.DoClick
	copy.OpenMenu = self.OpenMenu

	return copy;

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
						RunConsoleCommand( "gm_spawnsent", obj.spawnname ); 
						surface.PlaySound( "ui/buttonclickrelease.wav" ) 
					end
		icon.OpenMenu = function( icon ) 

						local menu = DermaMenu()
							menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
							menu:AddOption( "Spawn Using Toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ); RunConsoleCommand( "creator_type", "0" ); RunConsoleCommand( "creator_name", obj.spawnname ) end )
							menu:AddSpacer()							
							menu:AddOption( "Delete", function() icon:Remove(); hook.Run( "SpawnlistContentChanged", icon ) end )
						menu:Open()
						
					end

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon;

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
						RunConsoleCommand( "gm_spawnvehicle", obj.spawnname ); 
						surface.PlaySound( "ui/buttonclickrelease.wav" ) 
					end
		icon.OpenMenu = function( icon ) 

						local menu = DermaMenu()
							menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
							menu:AddOption( "Spawn Using Toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ); RunConsoleCommand( "creator_type", "1" ); RunConsoleCommand( "creator_name", obj.spawnname ) end )
							menu:AddSpacer()							
							menu:AddOption( "Delete", function() icon:Remove(); hook.Run( "SpawnlistContentChanged", icon ) end )
						menu:Open()
						
					end
		
	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon;

end )

gmod_npcweapon = CreateConVar( "gmod_npcweapon", "", { FCVAR_ARCHIVE } );

spawnmenu.AddContentType( "npc", function( container, obj )

	if ( !obj.material ) then return end
	if ( !obj.nicename ) then return end
	if ( !obj.spawnname ) then return end

	if ( !obj.weapon ) then obj.weapon = gmod_npcweapon:GetString() end
	
	local icon = vgui.Create( "ContentIcon", container )
		icon:SetContentType( "npc" )
		icon:SetSpawnName( obj.spawnname )
		icon:SetName( obj.nicename )
		icon:SetMaterial( obj.material )
		icon:SetAdminOnly( obj.admin )
		icon:SetNPCWeapon( obj.weapon )
		icon:SetColor( Color( 244, 164, 96, 255 ) )

		icon.DoClick = function() 
						
						local weapon = obj.weapon;
						if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString(); end

						RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, weapon ); 
						surface.PlaySound( "ui/buttonclickrelease.wav" ) 
					end

		icon.OpenMenu = function( icon ) 

						local menu = DermaMenu()

							local weapon = obj.weapon;
							if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString(); end

							menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
							menu:AddOption( "Spawn Using Toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ); RunConsoleCommand( "creator_type", "2" ); RunConsoleCommand( "creator_name", obj.spawnname ); RunConsoleCommand( "creator_arg", weapon ); end )
							menu:AddSpacer()							
							menu:AddOption( "Delete", function() icon:Remove(); hook.Run( "SpawnlistContentChanged", icon ) end )
						menu:Open()
						
					end


		
	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon;

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
		
						RunConsoleCommand( "gm_giveswep", obj.spawnname ); 						
						surface.PlaySound( "ui/buttonclickrelease.wav" ) 
						
					end

		icon.DoMiddleClick = function() 
		
						RunConsoleCommand( "gm_spawnswep", obj.spawnname ); 						
						surface.PlaySound( "ui/buttonclickrelease.wav" ) 
						
					end
					

		icon.OpenMenu = function( icon ) 

						local menu = DermaMenu()
							menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
							menu:AddOption( "Spawn Using Toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ); RunConsoleCommand( "creator_type", "3" ); RunConsoleCommand( "creator_name", obj.spawnname ) end )
							menu:AddSpacer()							
							menu:AddOption( "Delete", function() icon:Remove(); hook.Run( "SpawnlistContentChanged", icon ) end )
						menu:Open()

						end
				
		
	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon;

end )