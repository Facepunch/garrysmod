--[[ _
	( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DLabel
--]]

local PANEL = {}

AccessorFunc( PANEL, "m_colText",				"TextColor" )
AccessorFunc( PANEL, "m_colTextStyle",			"TextStyleColor" )
AccessorFunc( PANEL, "m_FontName",				"Font" )
AccessorFunc( PANEL, "m_bDoubleClicking",		"DoubleClickingEnabled",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bAutoStretchVertical",	"AutoStretchVertical",		FORCE_BOOL )
AccessorFunc( PANEL, "m_bBackground",			"PaintBackground",			FORCE_BOOL ) -- Why do we have both?
AccessorFunc( PANEL, "m_bBackground",			"DrawBackground",			FORCE_BOOL ) -- Why do we have both?
AccessorFunc( PANEL, "m_bHighlight",			"Highlight",				FORCE_BOOL )
AccessorFunc( PANEL, "m_bIsToggle",				"IsToggle",					FORCE_BOOL )
AccessorFunc( PANEL, "m_bDisabled",				"Disabled",					FORCE_BOOL )
AccessorFunc( PANEL, "m_bToggle",				"Toggle",					FORCE_BOOL )
AccessorFunc( PANEL, "m_bIsMenuComponent",		"IsMenu",					FORCE_BOOL )
AccessorFunc( PANEL, "m_bBright",				"Bright",					FORCE_BOOL )
AccessorFunc( PANEL, "m_bDark",					"Dark",						FORCE_BOOL )

--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetIsToggle( false )
	self:SetToggle( false )
	self:SetDisabled( false )
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	self:SetDoubleClickingEnabled( true )

	-- Nicer default height
	self:SetTall( 20 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self:SetFont( "DermaDefault" )

end

function PANEL:SetFont( strFont )

	self.m_FontName = strFont
	self:SetFontInternal( self.m_FontName )
	self:ApplySchemeSettings()

end

function PANEL:SetTextColor( clr )

	self.m_colText = clr
	self:UpdateFGColor()

end
PANEL.SetColor = PANEL.SetTextColor

function PANEL:UpdateFGColor()

	local col = self.m_colTextStyle
	if ( self.m_colText ) then col = self.m_colText end

	self:SetFGColor( col.r, col.g, col.b, col.a )

end

function PANEL:ApplySchemeSettings()

	self:UpdateColours( self:GetSkin() )

	self:UpdateFGColor()

end

function PANEL:Think()

	if ( self.m_bAutoStretchVertical ) then
		self:SizeToContentsY()
	end

end

function PANEL:PerformLayout()

	self:ApplySchemeSettings()

end

--[[---------------------------------------------------------
	SetColor
-----------------------------------------------------------]]
function PANEL:GetColor()

	return self.m_colTextStyle

end

--[[---------------------------------------------------------
	Exited
-----------------------------------------------------------]]
function PANEL:OnCursorEntered()

	self:InvalidateLayout( true )

end

--[[---------------------------------------------------------
	Entered
-----------------------------------------------------------]]
function PANEL:OnCursorExited()

	self:InvalidateLayout( true )

end

--[[---------------------------------------------------------
	OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mousecode )

	if ( self:GetDisabled() ) then return end
	
	if ( mousecode == MOUSE_LEFT && !dragndrop.IsDragging() && self.m_bDoubleClicking ) then
	
		if ( self.LastClickTime && SysTime() - self.LastClickTime < 0.2 ) then
		
			self:DoDoubleClickInternal()
			self:DoDoubleClick()
			return 
			
		end
		
		self.LastClickTime = SysTime()
	end
	
	-- If we're selectable and have shift held down then go up
	-- the parent until we find a selection canvas and start box selection
	if ( self:IsSelectable() && mousecode == MOUSE_LEFT ) then
	
		if ( input.IsShiftDown() ) then 
			return self:StartBoxSelection()
		end
		
	end
	
	self:MouseCapture( true )
	self.Depressed = true
	self:OnDepressed()
	self:InvalidateLayout( true )
	
	--
	-- Tell DragNDrop that we're down, and might start getting dragged!
	--
	self:DragMousePress( mousecode )

end

function PANEL:OnDepressed()

end

--[[---------------------------------------------------------
	OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased( mousecode )

	self:MouseCapture( false )
	
	if ( self:GetDisabled() ) then return end
	if ( !self.Depressed ) then return end
	
	self.Depressed = nil
	self:OnReleased()
	self:InvalidateLayout( true )
	--
	-- If we were being dragged then don't do the default behaviour!
	--
	if ( self:DragMouseRelease( mousecode ) ) then
		return
	end
	
	if ( self:IsSelectable() && mousecode == MOUSE_LEFT ) then
		
		local canvas = self:GetSelectionCanvas()
		if ( canvas ) then
			canvas:UnselectAll()
		end
		
	end
	
	if ( !self.Hovered ) then return end

	--
	-- For the purposes of these callbacks we want to 
	-- keep depressed true. This helps us out in controls
	-- like the checkbox in the properties dialog. Because
	-- the properties dialog will only manualloy change the value
	-- if IsEditing() is true - and the only way to work out if
	-- a label/button based control is editing is when it's depressed.
	--
	self.Depressed = true

	if ( mousecode == MOUSE_RIGHT ) then
		self:DoRightClick()
	end
	
	if ( mousecode == MOUSE_LEFT ) then	
		self:DoClickInternal()
		self:DoClick()
	end

	if ( mousecode == MOUSE_MIDDLE ) then
		self:DoMiddleClick()
	end

	self.Depressed = nil

end

function PANEL:OnReleased()

end

--[[---------------------------------------------------------
	DoRightClick
-----------------------------------------------------------]]
function PANEL:DoRightClick()

end

--[[---------------------------------------------------------
	DoMiddleClick
-----------------------------------------------------------]]
function PANEL:DoMiddleClick()

end

--[[---------------------------------------------------------
	DoClick
-----------------------------------------------------------]]
function PANEL:DoClick()

	self:Toggle()

end

function PANEL:Toggle()

	if ( !self:GetIsToggle() ) then return end

	self.m_bToggle = !self.m_bToggle
	self:OnToggled( self.m_bToggle )

end

function PANEL:OnToggled( bool )
end

--[[---------------------------------------------------------
	DoClickInternal
-----------------------------------------------------------]]
function PANEL:DoClickInternal()
end

--[[---------------------------------------------------------
	DoDoubleClick
-----------------------------------------------------------]]
function PANEL:DoDoubleClick()
end

--[[---------------------------------------------------------
	DoDoubleClickInternal
-----------------------------------------------------------]]
function PANEL:DoDoubleClickInternal()
end

--[[---------------------------------------------------------
	UpdateColours
-----------------------------------------------------------]]
function PANEL:UpdateColours( skin )

	if ( self.m_bBright )		then return self:SetTextStyleColor( skin.Colours.Label.Bright ) end
	if ( self.m_bDark )			then return self:SetTextStyleColor( skin.Colours.Label.Dark ) end
	if ( self.m_bHighlight )	then return self:SetTextStyleColor( skin.Colours.Label.Highlight ) end

	return self:SetTextStyleColor( skin.Colours.Label.Default )

end

--[[---------------------------------------------------------
	Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetText( "This is a label example." )
	ctrl:SizeToContents()

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DLabel", "A Label", PANEL, "Label" )

--[[---------------------------------------------------------
	Name: Convenience Function
-----------------------------------------------------------]]
function Label( strText, parent )

	local lbl = vgui.Create( "DLabel", parent )
	lbl:SetText( strText )

	return lbl

end
