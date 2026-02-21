
local PANEL = {}

AccessorFunc( PANEL, "m_bBackground",		"PaintBackground",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bBackground",		"DrawBackground",	FORCE_BOOL ) -- deprecated
AccessorFunc( PANEL, "m_bIsMenuComponent",	"IsMenu",			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDisableTabbing",	"TabbingDisabled",	FORCE_BOOL )

AccessorFunc( PANEL, "m_bDisabled",	"Disabled" )
AccessorFunc( PANEL, "m_bgColor",	"BackgroundColor" )

Derma_Hook( PANEL, "Paint", "Paint", "Panel" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "Panel" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "Panel" )

function PANEL:Init()

	self:SetPaintBackground( true )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

function PANEL:SetDisabled( bDisabled )

	self.m_bDisabled = bDisabled

	if ( bDisabled ) then
		self:SetAlpha( 75 )
		self:SetMouseInputEnabled( false )
	else
		self:SetAlpha( 255 )
		self:SetMouseInputEnabled( true )
	end

end

function PANEL:SetEnabled( bEnabled )

	self:SetDisabled( !bEnabled )

end

function PANEL:IsEnabled()

	return !self:GetDisabled()

end

function PANEL:OnMousePressed( mousecode )

	if ( self:IsSelectionCanvas() && !dragndrop.IsDragging() ) then
		self:StartBoxSelection()
		return
	end

	if ( self:IsDraggable() ) then

		self:MouseCapture( true )
		self:DragMousePress( mousecode )

	end

end

function PANEL:OnMouseReleased( mousecode )

	if ( self:EndBoxSelection() ) then return end

	self:MouseCapture( false )

	if ( self:DragMouseRelease( mousecode ) ) then
		return
	end

end

function PANEL:UpdateColours()
end

derma.DefineControl( "DPanel", "", PANEL, "Panel" )
