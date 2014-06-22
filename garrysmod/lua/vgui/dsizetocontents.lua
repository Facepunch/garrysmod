--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DSlider

--]]
local PANEL = {}
AccessorFunc( PANEL, "m_bSizeX", 			"SizeX" )
AccessorFunc( PANEL, "m_bSizeY", 			"SizeY" )

--[[---------------------------------------------------------
	
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	
	self:SetSizeX( true );
	self:SetSizeY( true );

end

function PANEL:PerformLayout()

	self:SizeToChildren( self.m_bSizeX, self.m_bSizeY )

end

derma.DefineControl( "DSizeToContents", "", PANEL, "Panel" )