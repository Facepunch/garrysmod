--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ /
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--
--

local PANEL = {}

AccessorFunc( PANEL, "m_ConVarR", 				"ConVarR" )
AccessorFunc( PANEL, "m_ConVarG", 				"ConVarG" )
AccessorFunc( PANEL, "m_ConVarB", 				"ConVarB" )
AccessorFunc( PANEL, "m_ConVarA", 				"ConVarA" )

local ColorRows = 16

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

	-- We try to avoid the ugly gap on the right.
	-- This seems a bit heavy handed to be calling in PerformLayout.
	self.Mixer.Palette:SetButtonSize( self:GetWide() / ColorRows )

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