--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DPanel

--]]
local PANEL = {}

AccessorFunc( PANEL, "m_bBackground", 			"PaintBackground",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bBackground", 			"DrawBackground", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )

AccessorFunc( PANEL, "m_bDisabled", 	"Disabled" )
AccessorFunc( PANEL, "m_bgColor", 		"BackgroundColor" )

Derma_Hook( PANEL, "Paint", "Paint", "MenuBar" )

--[[---------------------------------------------------------
	
-----------------------------------------------------------]]
function PANEL:Init()

	self:Dock( TOP )
	self:SetTall( 24 )

	self.Menus = {}

end

function PANEL:GetOpenMenu()

	for k, v in pairs( self.Menus ) do
		if ( v:IsVisible() ) then return v end
	end
	
	return nil

end

function PANEL:AddOrGetMenu( label )

	if ( self.Menus[ label ] ) then return self.Menus[ label ] end
	return self:AddMenu( label )

end

function PANEL:AddMenu( label )

	local m = DermaMenu()
		m:SetDeleteSelf( false )
		m:SetDrawColumn( true )
		m:Hide()
	self.Menus[ label ] = m
	
	local b = self:Add( "DButton" )
	b:SetText( label )
	b:Dock( LEFT )
	b:DockMargin( 5, 0, 0, 0 )
	b:SetIsMenu( true )
	b:SetDrawBackground( false )
	b:SizeToContentsX( 16 )
	b.DoClick = function() 
	
		if ( m:IsVisible() ) then
			m:Hide() 
			return 
		end
	
		local x, y = b:LocalToScreen( 0, 0 )
		m:Open( x, y + b:GetTall(), false, b )
		
	end
	
	b.OnCursorEntered = function()
		local opened = self:GetOpenMenu()
		if ( !IsValid( opened ) || opened == m ) then return end
		opened:Hide()
		b:DoClick()
	end
	
	return m

end

function PANEL:OnRemove()

	for id, pnl in pairs( self.Menus ) do
		pnl:Remove()
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local pnl = vgui.Create( "Panel" )
	pnl:Dock( FILL )
	pnl:DockMargin( 2, 22, 2, 2 )

	local ctrl = pnl:Add( ClassName )
		local m = ctrl:AddMenu( "File" )
			m:AddOption( "New", function() Msg( "Chose New\n" ) end )
			m:AddOption( "File", function() Msg( "Chose File\n" ) end )
			m:AddOption( "Exit", function() Msg( "Chose Exit\n" ) end )
		local m = ctrl:AddMenu( "Edit" )
			m:AddOption( "Copy", function() Msg( "Chose Copy\n" ) end )
			m:AddOption( "Paste", function() Msg( "Chose Paste\n" ) end )
			m:AddOption( "Blah", function() Msg( "Chose Blah\n" ) end )
	
	PropertySheet:AddSheet( ClassName, pnl, nil, true, true )

end


derma.DefineControl( "DMenuBar", "", PANEL, "DPanel" )