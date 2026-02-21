
local PANEL = {}

function PANEL:Init()

	self.Mixer = vgui.Create( "DColorMixer", self )
	self.Mixer:Dock( FILL )

	self:SetTall( 245 )

end

function PANEL:PerformLayout( x, y )

	-- Magic number, the target width for self.Mixer
	-- Number picked to that Palette would not have a gap, at button size 17
	local targetWidth = 272

	-- Don't scale the Mixer in width, keep it to the target width
	local s = math.max( ( self:GetWide() - targetWidth ) / 2, 0 )
	self.Mixer:DockMargin( s, 8, s, 0 )

	-- Ugly hack, because of the docking system
	self.OldMixerW = self.OldMixerW or self.Mixer:GetWide()

	-- Number of panels in one row
	local ColorRows = math.ceil( #self.Mixer.Palette:GetChildren() / 3 )

	-- Set the button size closest to fill the Mixer width
	local bSize = math.floor( self:GetWide() / ColorRows )
	self.Mixer.Palette:SetButtonSize( math.min( bSize, 17 ) )

end

function PANEL:Paint()
	-- Invisible background!
end

function PANEL:SetLabel( text ) self.Mixer:SetLabel( text ) end
function PANEL:SetConVarR( cvar ) self.Mixer:SetConVarR( cvar ) end
function PANEL:SetConVarG( cvar ) self.Mixer:SetConVarG( cvar ) end
function PANEL:SetConVarB( cvar ) self.Mixer:SetConVarB( cvar ) end
function PANEL:SetConVarA( cvar ) self.Mixer:SetConVarA( cvar ) end
function PANEL:GetConVarR() return self.Mixer:GetConVarR() end
function PANEL:GetConVarG() return self.Mixer:GetConVarG() end
function PANEL:GetConVarB() return self.Mixer:GetConVarB() end
function PANEL:GetConVarA() return self.Mixer:GetConVarA() end

vgui.Register( "CtrlColor", PANEL, "DPanel" )
