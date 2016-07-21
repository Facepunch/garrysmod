
local PANEL = {}

AccessorFunc( PANEL, "m_ConVarR", "ConVarR" )
AccessorFunc( PANEL, "m_ConVarG", "ConVarG" )
AccessorFunc( PANEL, "m_ConVarB", "ConVarB" )
AccessorFunc( PANEL, "m_ConVarA", "ConVarA" )

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Mixer = vgui.Create( "DColorMixer", self )
	self.Mixer:Dock( FILL )
	self:SetTall( 230 )

end

--[[---------------------------------------------------------
	Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout( x, y )

	-- Number of panels in one row
	local ColorRows = math.ceil( #self.Mixer.Palette:GetChildren() / 3 )

	-- We try to avoid the ugly gap on the right.
	-- This seems a bit heavy handed to be calling in PerformLayout.
	self.Mixer.Palette:SetButtonSize( self:GetWide() / ColorRows )

	-- Get rid of the gap by centering the palette using an ugly hack
	local s = ( self:GetWide() - ColorRows * self.Mixer.Palette:GetButtonSize() ) / 2
	self.Mixer.Palette:DockMargin( s, 8, s, 0 )

	-- Better height scaling for extra wide panels
	self:SetTall( math.max( 230, self:GetWide() / 1.5 ) )

end

--[[---------------------------------------------------------
	Name: SetLabel
-----------------------------------------------------------]]
function PANEL:SetLabel( text )

	self.Mixer:SetLabel( text )

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint()

	-- Invisible background!

end

--[[---------------------------------------------------------
	Name: ConVarR
-----------------------------------------------------------]]
function PANEL:SetConVarR( cvar )

	self.Mixer:SetConVarR( cvar )

end

--[[---------------------------------------------------------
	Name: ConVarG
-----------------------------------------------------------]]
function PANEL:SetConVarG( cvar )

	self.Mixer:SetConVarG( cvar )

end

--[[---------------------------------------------------------
	Name: ConVarB
-----------------------------------------------------------]]
function PANEL:SetConVarB( cvar )

	self.Mixer:SetConVarB( cvar )

end

--[[---------------------------------------------------------
	Name: ConVarA
-----------------------------------------------------------]]
function PANEL:SetConVarA( cvar )

	self.Mixer:SetConVarA( cvar )

end

vgui.Register( "CtrlColor", PANEL, "DPanel" )
